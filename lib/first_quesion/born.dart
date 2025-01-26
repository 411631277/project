import 'package:doctor_2/first_quesion/not%20born/notyet1.dart';
import 'package:doctor_2/first_quesion/yes%20born/yesyet.dart';
import 'package:flutter/material.dart';

class BornWidget extends StatelessWidget {
  const BornWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 螢幕寬高自適應
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
            // 問題文字
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.15,
              child: Text(
                '請問寶寶出生了嗎?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.08, // 根據螢幕寬度調整字體大小
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 還沒按鈕
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.27,
              child: SizedBox(
                width: screenWidth * 0.45,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notyet1Widget(),
                      ),
                    );
                  },
                  child: Text(
                    '還沒',
                    style: TextStyle(
                      color: const Color.fromRGBO(147, 129, 108, 1),
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ),
            // 出生了按鈕
            Positioned(
              top: screenHeight * 0.5 + 15, // 向下移動 15 的距離
              left: screenWidth * 0.27,
              child: SizedBox(
                width: screenWidth * 0.45,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YesyetWidget(),
                      ),
                    );
                  },
                  child: Text(
                    '出生了',
                    style: TextStyle(
                      color: const Color.fromRGBO(147, 129, 108, 1),
                      fontSize: screenWidth * 0.05,
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
