import 'package:doctor_2/login/forget_phone.dart';
import 'package:doctor_2/login/forget_email.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ForgetWidget extends StatelessWidget {
  const ForgetWidget({super.key});

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
            // **提示文字**
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Text(
                '請問要使用 e-mail 還是電話傳送更改密碼連結?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(0, 0, 0, 1),
                  fontSize: screenWidth * 0.05, // 自適應字體大小
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // **e-mail驗證按鈕**
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetEmailWidget()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'e-mail驗證',
                      style: TextStyle(
                        color: const Color.fromRGBO(0, 0, 0, 0.54),
                        fontSize: screenWidth * 0.05, // 自適應字體大小
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // **電話驗證按鈕**
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.2,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPhoneWidget()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '電話驗證',
                      style: TextStyle(
                        color: const Color.fromRGBO(0, 0, 0, 0.54),
                        fontSize: screenWidth * 0.05, // 自適應字體大小
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
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
