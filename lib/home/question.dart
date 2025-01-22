import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Color.fromRGBO(147, 129, 108, 1)),
        ),
        backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
        iconTheme: const IconThemeData(color: Color.fromRGBO(147, 129, 108, 1)),
        elevation: 0,
      ),
      body: Container(
        width: 412,
        height: 917,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 問卷標題圖標
            Positioned(
              top: 71,
              left: 38,
              child: Container(
                width: 34,
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Question.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 問卷文字標題
            const Positioned(
              top: 79,
              left: 95,
              child: Text(
                '問卷',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 母乳哺餵知識量表
            Positioned(
              top: 163,
              left: 28,
              child: Container(
                width: 262,
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const Positioned(
              top: 170,
              left: 75,
              child: Text(
                '母乳哺餵知識量表',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 產後憂鬱量表
            Positioned(
              top: 251,
              left: 28,
              child: Container(
                width: 262,
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const Positioned(
              top: 258,
              left: 95,
              child: Text(
                '產後憂鬱量表',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 生產支持知覺量表
            Positioned(
              top: 347,
              left: 28,
              child: Container(
                width: 262,
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const Positioned(
              top: 354,
              left: 75,
              child: Text(
                '生產支持知覺量表',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 親子依附量表
            Positioned(
              top: 449,
              left: 28,
              child: Container(
                width: 262,
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const Positioned(
              top: 456,
              left: 100,
              child: Text(
                '親子依附量表',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 親子同室情況
            Positioned(
              top: 545,
              left: 28,
              child: Container(
                width: 262,
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const Positioned(
              top: 552,
              left: 100,
              child: Text(
                '親子同室情況',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 會陰疼痛分數計算
            Positioned(
              top: 630,
              left: 28,
              child: Container(
                width: 262,
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const Positioned(
              top: 639,
              left: 80,
              child: Text(
                '會陰疼痛分數計算',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
