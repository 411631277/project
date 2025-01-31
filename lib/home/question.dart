import 'package:flutter/material.dart';
import 'dart:math' as math;

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key});

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
            // **問卷標題圖標**
            Positioned(
              top: screenHeight * 0.08,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.08,
                height: screenHeight * 0.05,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Question.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // **問卷文字標題**
            Positioned(
              top: screenHeight * 0.085,
              left: screenWidth * 0.25,
              child: Text(
                '問卷',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // **問卷選項**
            _buildSurveyButton(screenWidth, screenHeight, 0.18, '母乳哺餵知識量表'),
            _buildSurveyButton(screenWidth, screenHeight, 0.28, '產後憂鬱量表'),
            _buildSurveyButton(screenWidth, screenHeight, 0.38, '生產支持知覺量表'),
            _buildSurveyButton(screenWidth, screenHeight, 0.48, '親子依附量表'),
            _buildSurveyButton(screenWidth, screenHeight, 0.58, '親子同室情況'),
            _buildSurveyButton(screenWidth, screenHeight, 0.68, '會陰疼痛分數計算'),

            // **返回按鈕（獨立出來）**
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // **這裡不會報錯**
                },
                child: Transform.rotate(
                  angle: 180 * (math.pi / 180), // 旋轉 180 度
                  child: Container(
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.08,
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

  // **建構問卷按鈕**
  Widget _buildSurveyButton(double screenWidth, double screenHeight,
      double topPosition, String text) {
    return Stack(
      children: [
        Positioned(
          top: screenHeight * topPosition,
          left: screenWidth * 0.1,
          child: Container(
            width: screenWidth * 0.7,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
        ),
        Positioned(
          top: screenHeight * topPosition + screenHeight * 0.01,
          left: screenWidth * 0.22,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontFamily: 'Inter',
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
