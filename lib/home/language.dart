import 'package:doctor_2/main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

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
            // 地球圖標
            Positioned(
              top: screenHeight * 0.16,
              left: screenWidth * 0.35,
              child: Container(
                width: screenWidth * 0.25,
                height: screenHeight * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/language.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // 繁體中文按鈕
            Positioned(
              top: screenHeight * 0.32,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(185, 156, 107, 1),
                  ),
                  onPressed: () {
                    _setLocale(context, const Locale('zh', 'TW'));
                  },
                  child: Text(
                    '繁體中文',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ),
            ),
            // English 按鈕
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(185, 156, 107, 1),
                  ),
                  onPressed: () {
                    _setLocale(context, const Locale('en', 'US'));
                  },
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ),
            ),
            // 返回箭頭按鈕
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

  void _setLocale(BuildContext context, Locale locale) {
    // 更新語言
    MyApp.setLocale(context, locale);
    // 返回上一頁
    Navigator.pop(context);
  }
}
