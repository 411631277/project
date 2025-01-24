import 'package:flutter/material.dart';
import 'dart:math' as math;

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 地球圖標
            Positioned(
              top: 150,
              left: 156,
              child: Container(
                width: 101,
                height: 98,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/language.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 繁體中文按鈕
            Positioned(
              top: 300,
              left: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromRGBO(185, 156, 107, 1), // 背景顏色
                  fixedSize: const Size(200, 50), // 固定大小
                ),
                onPressed: () {},
                child: const Text(
                  '繁體中文',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            // English 按鈕
            Positioned(
              top: 380,
              left: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromRGBO(185, 156, 107, 1), // 背景顏色
                  fixedSize: const Size(200, 50), // 固定大小
                ),
                onPressed: () {},
                child: const Text(
                  'English',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            // 返回箭頭按鈕
            Positioned(
              top: 650,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: 179.24092303969866 * (math.pi / 180),
                  child: Container(
                    width: 60,
                    height: 50,
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
