import 'package:flutter/material.dart';

class FinishWidget extends StatelessWidget {
  const FinishWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 獲取螢幕寬度和高度
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
                  '問卷結束!謝謝填答',
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
              left: screenWidth * 0.35,
              child: SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                  ),
                  onPressed: () {
                    // 跳轉到下一頁，請根據實際需要修改頁面
                    Navigator.pushNamed(context, '/Home_screenWidget');
                  },
                  child: Text(
                    '下一步',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.36),
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.normal,
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
