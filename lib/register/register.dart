import 'package:doctor_2/main.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

final FirestoreService firestoreService = FirestoreService();

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  // 🔹 用戶輸入控制器
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController prePregnancyWeightController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // 🔹 用戶選擇資料
  String? maritalStatus;
  bool isEmailPreferred = false;
  bool isPhonePreferred = false;
  bool? isNewMom;
  Map<String, bool?> answers = {
    "是否會喝酒?": null,
    "是否會吸菸?": null,
    "是否會嚼食檳榔": null,
  };
  bool? hasChronicDisease; // 是否有慢性病 (是/否)
  Map<String, bool> chronicDiseaseOptions = {
    "妊娠糖尿病": false,
    "妊娠高血壓": false,
    "子癇前症": false,
    "甲狀腺功能異常": false,
    "慢性貧血": false,
    "慢性腎臟病": false,
    "自體免疫疾病": false,
    "胃腸道疾病": false,
    "其他": false,
  }; // 具體選項
  TextEditingController otherDiseaseController = TextEditingController();
  @override
  void dispose() {
    // 釋放控制器，避免記憶體洩漏
    nameController.dispose();
    birthController.dispose();
    heightController.dispose();
    weightController.dispose();
    prePregnancyWeightController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 姓名、生日、身高
              Row(
                children: [
                  Expanded(child: _buildLabeledTextField('姓名', nameController)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(child: _buildDatePickerField('生日', birthController)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                      child: _buildLabeledTextField('身高', heightController)),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // 🔹 體重
              Row(
                children: [
                  Expanded(
                    child: _buildWeightPickerField(
                        context, '目前體重', weightController),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                    child: _buildWeightPickerField(
                        context, '孕前體重', prePregnancyWeightController),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              // 🔹 Email
              _buildLabeledTextField('E-Mail', emailController),

              // 🔹 電話
              _buildLabeledTextField('電話', phoneController),

              // 🔹 聯絡偏好設定
              _buildLabel('聯絡偏好設定'),
              Row(
                children: [
                  Expanded(
                    child: _buildCheckbox("E-Mail", isEmailPreferred, (value) {
                      setState(() => isEmailPreferred = value ?? false);
                    }),
                  ),
                  Expanded(
                    child: _buildCheckbox("電話", isPhonePreferred, (value) {
                      setState(() => isPhonePreferred = value ?? false);
                    }),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // 🔹 是/否問題
              ...answers.keys.map((question) => _buildYesNoRow(question)),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // **「有無慢性病」標籤**
                  _buildLabel("有無慢性病"),

                  // **「有無慢性病」選項（改為 CheckboxListTile）**
                  CheckboxListTile(
                    title: Text("有慢性病"),
                    value: hasChronicDisease ?? false,
                    onChanged: (value) {
                      setState(() {
                        hasChronicDisease = value;
                      });
                    },
                    controlAffinity:
                        ListTileControlAffinity.leading, // **讓勾選框靠左**
                  ),

                  // **如果選擇「有慢性病」，顯示具體的慢性病選項**
                  if (hasChronicDisease == true) ...[
                    const SizedBox(height: 10),
                    _buildLabel("請選擇慢性病種類："),
                    ...chronicDiseaseOptions.keys.map((option) {
                      return CheckboxListTile(
                        title: Text(option),
                        value: chronicDiseaseOptions[option],
                        onChanged: (value) {
                          setState(() {
                            chronicDiseaseOptions[option] = value!;
                          });
                        },
                        controlAffinity:
                            ListTileControlAffinity.leading, // **讓勾選框靠左**
                      );
                    }), // **如果勾選「其他」，顯示輸入框**
                    if (chronicDiseaseOptions["其他"] == true)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                              controller: otherDiseaseController,
                              decoration: InputDecoration(
                                labelText: "請輸入其他慢性病",
                                border: OutlineInputBorder(),
                              )))
                  ],
                ],
              ),
              // 🔹 婚姻狀況
              _buildLabel('目前婚姻狀況'),
              DropdownButtonFormField<String>(
                value: maritalStatus,
                decoration: _inputDecoration(),
                hint: const Text('選擇婚姻狀況',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                items: ['結婚', '未婚', '離婚', '喪偶']
                    .map((status) =>
                        DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => maritalStatus = value),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 🔹 是否為新手媽媽
              _buildLabel('是否為新手媽媽'),
              Row(
                children: [
                  Expanded(
                      child: _buildCheckbox("是", isNewMom == true,
                          (value) => setState(() => isNewMom = true))),
                  Expanded(
                      child: _buildCheckbox("否", isNewMom == false,
                          (value) => setState(() => isNewMom = false))),
                ],
              ),
              const Divider(),
              SizedBox(height: screenHeight * 0.02),

              // 🔹 按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton('返回', Colors.grey, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Main_screenWidget()),
                    );
                  }),
                  _buildButton('下一步', Colors.blue, () async {
                    final String? userId =
                        await _saveUserData(); // ✅ 儲存資料並獲取 userId
                    if (!context.mounted) return;
                    if (userId != null && mounted) {
                      // 只有當 Widget 仍然掛載時，才導航到成功頁面
                      Navigator.pushNamed(
                        context,
                        '/SuccessWidget', // ✅ 使用 routes 而非 MaterialPageRoute
                        arguments: userId, // ✅ 傳遞 `userId`
                      );
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          readOnly: true, // 🔹 禁止手動輸入
          decoration: _inputDecoration(),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // 預設今天
              firstDate: DateTime(1950), // 最早 1950 年
              lastDate: DateTime.now(), // 不能選未來
              locale: const Locale("zh", "TW"), // ✅ 設定為繁體中文
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy年MM月dd日', 'zh_TW').format(pickedDate);
              setState(() {
                controller.text = formattedDate;
              });
            }
          },
        ),
      ],
    );
  }

  Future<String?> _saveUserData() async {
    try {
      AggregateQuerySnapshot countSnapshot =
          await FirebaseFirestore.instance.collection('users').count().get();

      int newId = (countSnapshot.count ?? 0) + 1; // 新 ID = 目前總數 + 1
      String userId = newId.toString(); // 確保 userId 是字串

      // **✅ 修正 `.toMap()` 錯誤，改為 `{}` 建立 Map**
      Map<String, dynamic> selectedChronicDiseases = {
        for (var entry in chronicDiseaseOptions.entries)
          if (entry.value) entry.key: true
      };

      // **如果「其他」被勾選，存入使用者輸入的值**
      if (selectedChronicDiseases.containsKey("其他")) {
        selectedChronicDiseases["其他"] = otherDiseaseController.text.isNotEmpty
            ? otherDiseaseController.text
            : null;
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        '名字': nameController.text,
        '生日': birthController.text,
        '身高': heightController.text,
        '目前體重': weightController.text,
        '孕前體重': prePregnancyWeightController.text,
        '電子信箱': emailController.text,
        '手機號碼': phoneController.text,
        '婚姻狀況': maritalStatus,
        '是否為新手媽咪': isNewMom,
        '聯絡偏好': {'email': isEmailPreferred, 'phone': isPhonePreferred},
        'answers': answers,
        '是否有慢性病': hasChronicDisease,
        '慢性病症狀': selectedChronicDiseases, // ✅ 修正後的 Map
      });

      logger.i("✅ 使用者資料已存入 Firestore，ID：$userId");
      return userId;
    } catch (e) {
      logger.e("❌ Firestore 儲存錯誤: $e");
      return null;
    }
  }

  InputDecoration _inputDecoration() => const InputDecoration(
      filled: true, fillColor: Colors.white, border: OutlineInputBorder());

  Widget _buildLabeledTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(controller: controller, decoration: _inputDecoration()),
      ],
    );
  }

  Widget _buildYesNoRow(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(question),
        Row(
          children: [
            Expanded(
                child: _buildCheckbox("是", answers[question] == true,
                    (value) => setState(() => answers[question] = true))),
            Expanded(
                child: _buildCheckbox("否", answers[question] == false,
                    (value) => setState(() => answers[question] = false))),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

// 🔹 建立標籤
Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}

// 🔹 建立 CheckBox 選擇框
Widget _buildCheckbox(String text, bool value, ValueChanged<bool?> onChanged) {
  return CheckboxListTile(
    title: Text(text),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
  );
}

// 🔹 建立按鈕
Widget _buildButton(String text, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onPressed,
    child:
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
  );
}

Widget _buildWeightPickerField(
    BuildContext context, String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label),
      TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showWeightPicker(context, controller);
        },
      ),
    ],
  );
}

void _showWeightPicker(BuildContext context, TextEditingController controller) {
  int selectedWeight = controller.text.isNotEmpty
      ? int.parse(controller.text.replaceAll(' kg', ''))
      : 50; // 預設 50kg

  showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SizedBox(
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: selectedWeight - 30),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      setModalState(() {
                        selectedWeight = index + 30;
                      });
                    },
                    children: List<Widget>.generate(121, (int index) {
                      return Center(child: Text('${index + 30} kg'));
                    }),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.text =
                        '$selectedWeight kg'; // ✅ 直接更新 controller.text
                    Navigator.pop(context); // ✅ 關閉彈出視窗
                  },
                  child: const Text("確定"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

final Logger logger = Logger();
