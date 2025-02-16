import 'package:doctor_2/register/register.dart';
import 'package:flutter/material.dart';

//註解已完成

class IamWidget extends StatelessWidget {
  const IamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          // 標題文字
          Positioned(
            top: screenHeight * 0.23,
            left: screenWidth * 0.33,
            child: const Text(
              '我是...?',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 40,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1,
                decoration: TextDecoration.none, // 明確設定無下劃線
              ),
            ),
          ),

          // 爸爸按鍵
          Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.14,
              child: SizedBox(
                width: screenWidth * 0.32,
                height: screenHeight * 0.08,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(187, 223, 248, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // 點擊跳轉到 RegisterWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    '爸爸',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontFamily: 'Inter',
                      fontSize: 25,
                    ),
                  ),
                ),
              )),

          // 媽媽按鍵
          Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.55,
              child: SizedBox(
                width: screenWidth * 0.32,
                height: screenHeight * 0.08,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(244, 202, 234, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // 點擊跳轉到 RegisterWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    '媽媽',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontFamily: 'Inter',
                      fontSize: 25,
                    ),
                  ),
                ),
              )),
        ]));
  }
}
