import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/forgetpass.dart/suc_repass.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/services/backend3000/backend3000.dart';
class ResetPasswordPage extends StatefulWidget {
  final String userId;
  final bool isManUser; // ✅ 加上這個參數

  const ResetPasswordPage({
    super.key,
    required this.userId,
    required this.isManUser,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final base = MediaQuery.of(context).size.shortestSide;
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
                SizedBox(height: screenHeight * 0.2),
                Text(
                  "請輸入新的密碼：",
                  style: TextStyle(
                    fontSize: base * 0.05,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing),

                // 密碼輸入欄
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "新密碼",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: spacing * 2),

                // 修改密碼按鈕
                SizedBox(
                  width: screenWidth * 0.6,
                  child: _buildCustomButton("修改密碼", onPressed: _handleChangePassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
  final newPassword = _passwordController.text.trim();
  if (newPassword.isEmpty) {
    _showDialog("錯誤", "請輸入新密碼");
    return;
  }

  final String collection = widget.isManUser ? 'Man_users' : 'users';

  try {
    // 更新 Firebase Firestore
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.userId)
        .update({'密碼': newPassword});

    // 更新 SQL 後端（163.13.201.85:3000）
    await Backend3000.userApi.updatePassword(
      isManUser: widget.isManUser,
      userId: widget.userId,
      newPassword: newPassword,
    );

    if (!mounted) return;
    _showDialog("成功", "密碼已更新");
  } catch (e) {
    if (!mounted) return;
    _showDialog("錯誤", "更新失敗，請稍後再試");
  }
}

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("確認"),
            onPressed: () {
              Navigator.pop(context);
              if (title == "成功") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SucPassWidget()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(String text, {required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
