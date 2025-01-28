import 'package:flutter/material.dart';
import 'dart:math' as math;

class PhoneWidget extends StatelessWidget {
  const PhoneWidget({super.key});

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
            // 標題 "院內電話查詢"
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.32,
              child: Text(
                '院內電話查詢',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // "語音預約掛號"
            Positioned(
              top: screenHeight * 0.22,
              left: screenWidth * 0.35,
              child: Text(
                '語音預約掛號',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.34,
              child: Text(
                '(02)87927111',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // "人工預約掛號"
            Positioned(
              top: screenHeight * 0.36,
              left: screenWidth * 0.35,
              child: Text(
                '人工預約掛號',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.41,
              left: screenWidth * 0.34,
              child: Text(
                '(02)87927222',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // "三總產後病房電話"
            Positioned(
              top: screenHeight * 0.5,
              left: screenWidth * 0.3,
              child: Text(
                '三總產後病房電話',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.25,
              child: Text(
                '(02)8792-3100#55000',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 圖示 (電話圖案)
            Positioned(
              top: screenHeight * 0.09,
              left: screenWidth * 0.12,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.08,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/phone.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 返回按鈕
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.28,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: -math.pi,
                  child: Container(
                    width: screenWidth * 0.14,
                    height: screenHeight * 0.07,
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
