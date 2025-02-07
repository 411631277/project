import 'package:flutter/material.dart';
import 'dart:math' as math;

class MateWidget extends StatelessWidget {
  const MateWidget({super.key});

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
            // 圖示
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.25,
                height: screenHeight * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pregnancy.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 標題文字
            Positioned(
              top: screenHeight * 0.13,
              left: screenWidth * 0.38,
              child: Text(
                '配偶分享碼',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 配偶分享碼文字
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.1,
              child: Text(
                '配偶分享碼',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 分享碼背景框
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.42,
              child: Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.03,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
            // 分享碼文字
            Positioned(
              top: screenHeight * 0.352,
              left: screenWidth * 0.55,
              child: Text(
                '758902',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 返回按鈕
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.fitWidth,
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
