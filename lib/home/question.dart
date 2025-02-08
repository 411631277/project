import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

class QuestionWidget extends StatelessWidget {
  final String userId; // 接收 userId 資訊

  const QuestionWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger(); // 初始化 Logger
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
            // **問卷選項按鈕**
            _buildSurveyButton(context, screenWidth, screenHeight, 0.18,
                '母乳哺餵知識量表', '/KnowledgeWidget', logger),
            _buildSurveyButton(context, screenWidth, screenHeight, 0.28,
                '產後憂鬱量表', '/home2', logger),
            _buildSurveyButton(context, screenWidth, screenHeight, 0.38,
                '生產支持知覺量表', '/home3', logger),
            _buildSurveyButton(context, screenWidth, screenHeight, 0.48,
                '親子依附量表', '/home4', logger),
            _buildSurveyButton(context, screenWidth, screenHeight, 0.58,
                '親子同室情況', '/home5', logger),
            _buildSurveyButton(context, screenWidth, screenHeight, 0.68,
                '會陰疼痛分數計算', '/home6', logger),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
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
  Widget _buildSurveyButton(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      double topPosition,
      String text,
      String routeName,
      Logger logger) {
    return Positioned(
      top: screenHeight * topPosition,
      left: screenWidth * 0.1,
      child: SizedBox(
        width: screenWidth * 0.7,
        height: screenHeight * 0.05,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(147, 129, 108, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: () async {
            logger.i("🟢 正在導航到 $routeName，userId: $userId");
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(), // Loading 效果
                );
              },
            );

            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            Navigator.pop(context); // 關閉 Dialog
            Navigator.pushNamed(
              context,
              routeName,
              arguments: userId,
            );
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
