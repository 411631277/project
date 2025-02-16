import 'package:doctor_2/main.screen.dart';
import 'package:flutter/material.dart';

class SignoutWidget extends StatelessWidget {
  const SignoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 獲取螢幕尺寸
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
            // 登出提示框背景
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            // 提示文字
            Positioned(
              top: screenHeight * 0.37,
              left: screenWidth * 0.28,
              child: Text(
                '確認要登出帳號嗎?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // "是" 按鈕
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.22,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreenWidget(),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.05,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '是',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.36),
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            // "否" 按鈕
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.58,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.05,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '否',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.36),
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.045,
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
