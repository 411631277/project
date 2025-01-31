import 'package:doctor_2/login/login.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ForgetEmailWidget extends StatelessWidget {
  const ForgetEmailWidget({super.key});

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
            // **背景容器**
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.15,
              child: Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  borderRadius: BorderRadius.circular(10), // 圓角
                ),
              ),
            ),

            // **提示文字**
            Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.15,
              right: screenWidth * 0.15,
              child: Text(
                '已傳送更改密碼的簡訊到\n當初預設的 email 信箱，請查收',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.045, // 自適應字體大小
                  letterSpacing: -0.24,
                  fontWeight: FontWeight.normal,
                  height: 1.3,
                ),
              ),
            ),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWidget(), // 返回登入頁
                    ),
                  );
                },
                child: Transform.rotate(
                  angle: 180 * (math.pi / 180), // 旋轉 180 度
                  child: Container(
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.08,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.contain,
                      ),
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
