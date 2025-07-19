import 'dart:math' as math;
import 'package:doctor_2/function/main.screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class SucPassWidget extends StatelessWidget {
  const SucPassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 獲取螢幕寬度和高度
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final base = math.min(screenWidth, screenHeight);
   return PopScope(
    canPop: false, // ❗這行就是鎖定返回鍵
    child: Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 問卷結束背景框
            Positioned(
              top: screenHeight * 0.33,
              left: screenWidth * 0.15,
              child: Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            // 問卷結束文字
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                child: const Text(
                  '密碼已更改，請重新登入',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            // 下一步按鈕
            Positioned(
              top: screenHeight * 0.48,
              left: screenWidth * 0.30,
              child: SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                  ),
                  onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const MainScreenWidget()),
    (route) => false, // 清除所有舊頁面
  );
},
                  child: Text(
                    '回到主畫面',
                    style: TextStyle(
                      color: const Color.fromRGBO(147, 129, 108, 1),
                      fontFamily: 'Inter',
                      fontSize: base*0.04
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}