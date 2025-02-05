import 'package:doctor_2/main.screen.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

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
    "有無慢性病": null,
  };

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
                  Expanded(
                      child: _buildLabeledTextField('生日', birthController)),
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
                      child: _buildLabeledTextField('目前體重', weightController)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                      child: _buildLabeledTextField(
                          '孕前體重', prePregnancyWeightController)),
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

  Future<String?> _saveUserData() async {
    try {
      AggregateQuerySnapshot countSnapshot =
          await FirebaseFirestore.instance.collection('users').count().get();

      int newId = (countSnapshot.count ?? 0) + 1; // 新 ID = 目前總數 + 1
      String userId = newId.toString(); // 確保 userId 是字串

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
      });

      logger.i("✅ 使用者資料已存入 Firestore，ID：$userId");
      return userId; // ✅ 回傳 userId
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

final Logger logger = Logger();
