import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
 
  Future<void> _pickDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2000, 1, 1),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    helpText: '選擇生日',
  );
  if (picked != null) {
    setState(() {
      _birthdayController.text = DateFormat("yyyy年MM月dd日").format(picked);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final base = math.min(screenWidth, screenHeight);
    final spacing = screenHeight * 0.08;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE4),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.15),
                Text(
                  "請輸入註冊時的資料以重設密碼：",
                  style: TextStyle(
                    fontSize: base * 0.05,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing),

                // 姓名
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "姓名",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: spacing),

                // 生日
                GestureDetector(
  onTap: _pickDate,
  child: AbsorbPointer(
    child: TextField(
      controller: _birthdayController,
      decoration: const InputDecoration(
        labelText: "生日",
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
  ),
),
                SizedBox(height: spacing),

                // 電話
                TextField(
  controller: _phoneController,
  decoration: const InputDecoration(
    labelText: "電話號碼",
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Colors.white,
  ),
  keyboardType: TextInputType.phone,
  inputFormatters: [LengthLimitingTextInputFormatter(10)],
),
                SizedBox(height: spacing * 2),

                // ✅ 按鈕：作為 ScrollView 內容的一部分
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomButton("返回", onPressed: () {
                      Navigator.pop(context);
                    }, width: screenWidth * 0.35),
                     _buildCustomButton("確認資料", onPressed: _checkUserData, width: screenWidth * 0.35),
                  ],
                ),
                SizedBox(height: spacing), // 增加下方留白
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text,
      {required VoidCallback onPressed, double? width}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(1, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      );
    },
  );
}

  Future<void> _checkUserData() async {
  final name = _nameController.text.trim();
  final phone = _phoneController.text.trim();
  final birthdayText = _birthdayController.text.trim();

  if (birthdayText.isEmpty) {
  _showDialog("資料不完整", "請確認資料是否全部填寫");
  return;
}

// 將 "2003年12月23日" 轉換為 DateTime
final birthdayDate = DateFormat("yyyy年MM月dd日").parse(birthdayText);
// 再轉為 "2003-12-23"
final formattedBirthday = DateFormat("yyyy-MM-dd").format(birthdayDate);

final Map<String, String> payload = {
  "user_name": name,
  "user_birthdate": formattedBirthday,
  "user_phone": phone,
};


  // 發送兩個 API
  final responses = await Future.wait([
    http.post(
      Uri.parse("http://163.13.201.85:3000/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    ),
    http.post(
      Uri.parse("http://163.13.201.85:3000/man_users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    ),
  ]);

  // 解析結果
  for (final response in responses) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["matched"] == true) {
        _showDialog("驗證成功", "您的資料已確認，請繼續後續操作");
        return;
      }
    }
  }

  // 都沒成功
  _showDialog("查無資料", "請確認資料是否正確");
}
}
