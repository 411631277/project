import 'dart:convert';

import 'package:doctor_2/function/main.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

//註解已完成

final FirestoreService firestoreService = FirestoreService();
final Logger logger = Logger();


class FaRegisterWidget extends StatefulWidget {
  const FaRegisterWidget({super.key, required String role});

  @override
  FaRegisterWidgetState createState() => FaRegisterWidgetState();
  }
  
  bool _obscurePassword = true;
  
  // 🔹 用戶輸入控制器
  class FaRegisterWidgetState extends State<FaRegisterWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController prePregnancyWeightController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // 🔹 用戶選擇資料
  String? _accountCheckMessage;
  Color _accountCheckColor = Colors.transparent;
  String? maritalStatus;
  bool isEmailPreferred = false;
  bool isPhonePreferred = false;
  bool? isNewMom;
  Map<String, bool?> answers = {
    "是否會喝酒?": null,
    "是否會吸菸?": null,
    "是否會嚼食檳榔": null,
  };
  bool? hasChronicDisease;   // 是否有慢性病 (是/否)
  Map<String, bool> chronicDiseaseOptions = {
    "糖尿病": false,
    "高血壓": false,
    "肥胖症": false,
    "慢性腎臟病": false,
    "甲狀腺功能異常": false,
    "慢性肝病(肝硬化)": false,
    "自體免疫疾病": false,
    "靜脈曲張": false,
    "其他": false,
  };
  TextEditingController otherDiseaseController =
      TextEditingController(); // 具體選項

@override
  void initState() {
    super.initState();
    // 當使用者修改「帳號」欄位時，清除檢查結果，避免舊提示誤導
    accountController.addListener(() {
      setState(() {
        _accountCheckMessage = null;
        _accountCheckColor = Colors.transparent;
      });
    });
  }

// 釋放控制器，避免記憶體洩漏
  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    heightController.dispose();
    weightController.dispose();
    prePregnancyWeightController.dispose();
    emailController.dispose();
    phoneController.dispose();
    accountController.dispose();
    passwordController.dispose();
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
                  Expanded(child: _buildheightPickerField(context, '身高', heightController)),
                  SizedBox(width: screenWidth * 0.05),
                ],
              ),

              SizedBox(height: screenHeight * 0.02), // 🔹 體重
              Row(
                children: [
                  Expanded(
                    child: _buildWeightPickerField(
                    context, '目前體重', weightController),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                ],
              ),

              // 🔹 帳號&密碼&信箱&電話
              SizedBox(height: screenHeight * 0.02),
               _buildAccountRow(), //帳號
              _buildPasswordField(),
              _buildLabeledTextField('E-Mail', emailController),
              _buildLabeledTextField('電話', phoneController),

              // 🔹 聯絡偏好設定
              _buildLabel('聯絡偏好設定'),
              Row(
                children: [
                Expanded(
                    child: _buildCheckbox("E-Mail", isEmailPreferred, (value) {
                    setState(() => isEmailPreferred = value ?? false);
                    }
                    ),
                    ),
                Expanded(
                    child: _buildCheckbox("電話", isPhonePreferred, (value) {
                      setState(() => isPhonePreferred = value ?? false);
                    }
                    ),
                  ),
                ],
              ),

              // 🔹 是非題
              SizedBox(height: screenHeight * 0.02),
              ...answers.keys.map((question) => _buildYesNoRow(question)),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //「有無慢性病」標籤
                  _buildLabel("有無慢性病"),
                  CheckboxListTile(
                    title: Text("有慢性病"),
                    value: hasChronicDisease ?? false,
                    onChanged: (value) {
                      setState(() {
                      hasChronicDisease = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading, // 讓勾選框靠左
                  ),

                  //如果選擇「有慢性病」，顯示具體的慢性病選項
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
                            ListTileControlAffinity.leading, // 讓勾選框靠左
                      );
                    }),

                    // **如果勾選「其他」，顯示輸入框**
                    if (chronicDiseaseOptions["其他"] == true)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                          controller: otherDiseaseController,
                          decoration: const InputDecoration(
                                labelText: "請輸入其他慢性病",
                                border: OutlineInputBorder(),
                                filled: true, // 開啟填充背景
                                fillColor: Colors.white,
                              )
                            )
                          )
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

              // 🔹 是否為新手爸爸
              SizedBox(height: screenHeight * 0.02),
              _buildLabel('是否為新手爸爸'),
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

              // 🔹 按鈕
              const Divider(),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                _buildButton('返回', Colors.grey, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreenWidget()),
                    );
                  }
                  ),
                  _buildButton('下一步', Colors.blue, () async {
                    final String? userId =
                    await _saveUserData(); // ✅ 儲存資料並獲取 userId
                    if (!context.mounted) return;
                    if (userId != null && mounted) {
                      // 只有當 Widget 仍然掛載時，才導航到成功頁面
                      Navigator.pushNamed(
                        context,
                        '/FaSuccessWidget',
                        arguments: userId, //傳遞'userId'
                      );
                    }
                  }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
     }

 Widget _buildAccountRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('帳號'),
        Row(
        children: [
            // 帳號輸入框
            Expanded(
            child: TextField(
            controller: accountController,
            decoration: _inputDecoration(),
            ),
            ),

          const SizedBox(width: 8),
          
          //檢查帳號按鈕
          ElevatedButton(
          style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: const Color.fromARGB(255, 148, 235, 235),
          ),
          onPressed: _checkAccountDuplicate,
          child: const Text("檢查"),
          )
          ],
          ),
        
          // 若有檢查結果，顯示提示文字
          if (_accountCheckMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
            _accountCheckMessage!,
            style: TextStyle(color: _accountCheckColor),
            ),
           ),
           ],
           );
           }

  Future<void> _checkAccountDuplicate() async {
  final acc = accountController.text.trim();
  if (acc.isEmpty) {
    setState(() {
    _accountCheckMessage = "請先輸入帳號";
     _accountCheckColor = Colors.red;
    });
    return;
  }

  try {
    final userQuery = await FirebaseFirestore.instance  // 先查 users
        .collection('users')
        .where('帳號', isEqualTo: acc)
        .limit(1)
        .get();

      if (userQuery.docs.isNotEmpty) {        // 已有相同帳號
      setState(() {
        _accountCheckMessage = "很抱歉，此帳號已註冊";
        _accountCheckColor = Colors.red;
      });
      return; // 直接結束
    }

    // 再查 man_users
    final manUserQuery = await FirebaseFirestore.instance
        .collection('Man_users')
        .where('帳號', isEqualTo: acc)
        .limit(1)
        .get();

    if (manUserQuery.docs.isNotEmpty) {
      setState(() {
        _accountCheckMessage = "很抱歉，此帳號已註冊";
        _accountCheckColor = Colors.red;
      });
      return;
    }

    // 兩邊都沒有 => 帳號可以使用
    setState(() {
      _accountCheckMessage = "此帳號可以使用";
      _accountCheckColor = Colors.green;
    });
  } catch (e) {
    logger.e("檢查帳號錯誤: $e");
    setState(() {
      _accountCheckMessage = "檢查時發生錯誤，請稍後再試";
      _accountCheckColor = Colors.red;
    });
  }
  }

  //日期選擇器
  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          readOnly: true, //禁止手動輸入
          decoration: _inputDecoration(),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // 預設今天
              firstDate: DateTime(1950), // 最早 1950 年
              lastDate: DateTime.now(), // 不能選未來
              locale: const Locale("zh", "TW"), //設定為繁體中文
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

  //儲存使用者資料
  Future<String?> _saveUserData() async {
    try {
      AggregateQuerySnapshot countSnapshot = await FirebaseFirestore.instance
          .collection('Man_users')
          .count()
          .get();

      Map<String, dynamic> selectedChronicDiseases = {
        for (var entry in chronicDiseaseOptions.entries)
          if (entry.value) entry.key: true
      };

      if (selectedChronicDiseases.containsKey("其他")) {
        selectedChronicDiseases["其他"] = otherDiseaseController.text.isNotEmpty
            ? otherDiseaseController.text
            : null;
      }

      int newId = (countSnapshot.count ?? 0) + 1; // 新 ID = 目前總數 + 1
      String userId = newId.toString(); // 確保 userId 是字串
      await FirebaseFirestore.instance.collection('Man_users').doc(userId).set({
        '帳號': accountController.text,
        '密碼': passwordController.text,
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
        '慢性病症狀': selectedChronicDiseases,
        
      });
      await sendDataToMySQL(userId);
      logger.i("✅ 使用者資料已存入 Firestore，ID：$userId");
      return userId; //回傳 userId
    } catch (e) {
      logger.e("❌ Firestore 儲存錯誤: $e");
      return null;
    }
  }

Future<void> sendDataToMySQL(String userId) async {
  final url = Uri.parse('http://163.13.201.85:3000/man_users');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'man_user_name': nameController.text,
      'user_id': int.parse(userId),
      'man_user_email': emailController.text,
      'user_gender': "男",
      'man_user_salutation': isNewMom == true ? "是" : "否",
      'man_user_birthdate': formatBirthForMySQL(birthController.text),
      'man_user_phone': phoneController.text,
      'man_user_id_number': accountController.text,
      'man_user_height': double.tryParse(heightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
      'man_current_weight': double.tryParse(weightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
      'man_emergency_contact_name': "",
      'man_emergency_contact_phone': "",
      'man_betel_nut_habit': answers["是否會嚼食檳榔"] == true ? '有' : '無',
      'man_smoking_habit': answers["是否會吸菸?"] == true ? '有' : '無',
      'man_drinking_habit': answers["是否會喝酒?"] == true ? '有' : '無',
      'man_marital_status': maritalStatus ?? '未婚',
      'man_contact_preference': [
        if (isEmailPreferred) 'e-mail',
        if (isPhonePreferred) '電話',
      ].join(','),
      'man_chronic_illness': hasChronicDisease == true
          ? [
              ...chronicDiseaseOptions.entries
                  .where((entry) => entry.value && entry.key != "其他")
                  .map((entry) => entry.key),
              if (chronicDiseaseOptions["其他"] == true) '其他',
            ].join(',')
          : '無',
      'man_chronic_illness_details': otherDiseaseController.text.isNotEmpty
          ? otherDiseaseController.text
          : '',
      'man_user_account': accountController.text,
      'man_user_password': passwordController.text,
    }),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    logger.i("✅ 爸爸資料同步至 MySQL 成功");
  } else {
    logger.e("❌ 爸爸同步 MySQL 失敗: ${response.body}");
  }
}

  //輸入框設定
  InputDecoration _inputDecoration() => const InputDecoration(
      filled: true, fillColor: Colors.white, border: OutlineInputBorder());

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          obscureText: obscureText, //如果是密碼欄位則隱藏文字
          decoration: _inputDecoration(),
        ),
      ],
    );
  }
Widget _buildPasswordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel("密碼"),
      TextField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          // 右側的眼睛圖示
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
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

//建立標籤
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

//建立 CheckBox 選擇框
Widget _buildCheckbox(String text, bool value, ValueChanged<bool?> onChanged) {
  return CheckboxListTile(
    title: Text(text),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
  );
}

//建立按鈕
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

//體重選項功能
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

//體重選項設定
void _showWeightPicker(BuildContext context, TextEditingController controller) {
  int selectedWeight = controller.text.isNotEmpty
      ? int.parse(controller.text.replaceAll(' kg', ''))
      : 50; // 預設公斤值

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
                    }
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                  controller.text = '$selectedWeight kg'; //更新controller.text
                  Navigator.pop(context); //關閉彈出視窗
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

//身高選項功能
Widget _buildheightPickerField(
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
          _showheightPicker(context, controller);
        },
      ),
    ],
  );
}

String formatBirthForMySQL(String text) {
    try {
      final parsed = DateFormat('yyyy年MM月dd日', 'zh_TW').parse(text);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return ""; // 防呆處理，避免錯誤時整個崩潰
    }
  }

//身高功能設定
void _showheightPicker(BuildContext context, TextEditingController controller) {
  int selectedHeight = controller.text.isNotEmpty
      ? int.parse(controller.text.replaceAll(' cm', ''))
      : 150; // 預設身高值

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
                    initialItem: selectedHeight - 100),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                    setModalState(() {
                    selectedHeight = index + 100;
                      }
                      );
                      },
                    children: List<Widget>.generate(121, (int index) {
                    return Center(child: Text('${index + 100} cm'));
                    }
                    ),
                    ),
                    ),
                ElevatedButton(
                  onPressed: () {
                    controller.text = '$selectedHeight cm'; //更新controller.text
                    Navigator.pop(context); //關閉彈出視窗
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
