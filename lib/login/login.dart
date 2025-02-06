import 'package:doctor_2/home/home_screen.dart';
import 'package:doctor_2/login/forget.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
                '帳號',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06, // 自適應字體大小
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
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // **下一步按鈕**
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
                    // 點擊跳轉到主畫面
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreenWidget(
                          userId: '',
                        ),
                      ),
                    );
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
}
