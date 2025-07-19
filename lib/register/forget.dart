import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;

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
        _selectedDate = picked;
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
                      decoration: InputDecoration(
                        labelText: "生日",
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                        hintText: _selectedDate == null
                            ? "點選選擇生日"
                            : DateFormat("yyyy年MM月dd日")
                                .format(_selectedDate!),
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
                ),
                SizedBox(height: spacing * 2),

                // ✅ 按鈕：作為 ScrollView 內容的一部分
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomButton("返回", onPressed: () {
                      Navigator.pop(context);
                    }, width: screenWidth * 0.35),
                    _buildCustomButton("確認資料", onPressed: () {
                      // TODO: 資料確認
                    }, width: screenWidth * 0.35),
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
}
