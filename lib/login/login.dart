import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/home/home_screen.dart';
import 'package:doctor_2/login/forget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/home/fa_home_screen.dart';
import '../l10n/generated/l10n.dart';

final Logger logger = Logger();

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = ""; // 🔹 錯誤訊息

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // **帳號標籤**
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.42,
              child: Text(
                AppLocalizations.of(context).get('account'),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // **帳號輸入框**
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.15,
              child: SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.05,
                child: TextField(
                  controller: accountController, // 🔹 綁定帳號控制器
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // **密碼標籤**
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.42,
              child: Text(
                '密碼',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06, // 自適應字體大小
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // **密碼輸入框**
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.15,
              child: SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.05,
                child: TextField(
                  controller: passwordController, // 🔹 綁定密碼控制器
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            // **錯誤訊息**
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.15,
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),

            // **登入按鈕**
            Positioned(
              top: screenHeight * 0.61,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _login(); // 🔹 驗證帳號密碼
                  },
                  child: Text(
                    '登入',
                    style: TextStyle(
                      color: const Color.fromRGBO(147, 129, 108, 1),
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ),
            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.7,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // 返回上一頁
                  },
                  child: Text(
                    '返回',
                    style: TextStyle(
                      color: const Color.fromRGBO(147, 129, 108, 1),
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ),

            // **忘記密碼按鈕**
            Positioned(
              top: screenHeight * 0.78,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // 點擊跳轉到忘記密碼畫面
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgetWidget(),
                      ),
                    );
                  },
                  child: Text(
                    '忘記密碼',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.54),
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **🔹 驗證帳號密碼**
  void _login() async {
    String account = accountController.text.trim();
    String password = passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "帳號或密碼不能為空";
      });
      return;
    }

    try {
      // 先查詢 users 集合
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('帳號', isEqualTo: account)
          .where('密碼', isEqualTo: password)
          .get();

      if (!mounted) return;

      if (userQuery.docs.isNotEmpty) {
        String userId = userQuery.docs.first.id;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenWidget(
              userId: userId,
              isManUser: true,
            ), // 一般使用者頁面
          ),
        );
        return;
      }

      // 如果 users 查不到，再查詢 Man_users 集合
      QuerySnapshot manUserQuery = await FirebaseFirestore.instance
          .collection('Man_users')
          .where('帳號', isEqualTo: account)
          .where('密碼', isEqualTo: password)
          .get();

      if (!mounted) return;

      if (manUserQuery.docs.isNotEmpty) {
        String userId = manUserQuery.docs.first.id;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaHomeScreenWidget(
              userId: userId,
              isManUser: true,
              updateStepCount: (steps) {},
            ), // Man_users 專用頁面
          ),
        );
      } else {
        setState(() {
          errorMessage = "帳號或密碼錯誤";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "登入失敗，請稍後再試";
        });
      }
      logger.e("❌ 登入錯誤: $e");
    }
  }
}
