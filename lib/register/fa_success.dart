import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

//註解已完成

final Logger logger = Logger();

class FaSuccessWidget extends StatelessWidget {
  final String userId; //帶入ID
  const FaSuccessWidget(
      {super.key, required this.userId, required bool isManUser});

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
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.05,
              child: SizedBox(
                width: screenWidth * 0.9,
                child: const Text(
                  '帳號創建成功!!!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            //下一步按鈕
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
                height: screenHeight * 0.08,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(147, 129, 108, 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    logger.i(
                        "🟢 Fa_FaSuccessWidget 正在導航到 FaHomeScreenWidget，userId: $userId");
                    Navigator.pushNamed(
                      context,
                      '/FaHomeScreenWidget', // ✅ 改用 routes 導航
                      arguments: {'userId': userId}, // ✅ 傳遞 userId
                    );
                  },
                  child: const Text(
                    '下一步',
                    style: TextStyle(
                      color: Color.fromRGBO(11, 10, 10, 1),
                      fontFamily: 'Inter',
                      fontSize: 24,
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
