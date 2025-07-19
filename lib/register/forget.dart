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
    final startHeight = screenHeight * 0.2;
    final spacing = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE4),
      body: Stack(
        children: [
          // 內容區
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              base * 0.08,
              startHeight,
              base * 0.08,
              screenHeight * 0.2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "請輸入以下資料以重設密碼：",
                  style: TextStyle(
                    fontSize: base * 0.045,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing),

                // 姓名欄位
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

                // 生日欄位
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
                            : DateFormat("yyyy年MM月dd日").format(_selectedDate!),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing),

                // 電話欄位
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
              ],
            ),
          ),

          // 固定下方按鈕
          Positioned(
            left: base * 0.05,
            bottom: base * 0.05,
            child: _buildCustomButton("返回", onPressed: () {
              Navigator.pop(context);
            }, width: screenWidth * 0.35),
          ),
          Positioned(
            right: base * 0.05,
            bottom: base * 0.05,
            child: _buildCustomButton("確認資料", onPressed: () {
              // TODO: 確認邏輯
            }, width: screenWidth * 0.35),
          ),
        ],
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
