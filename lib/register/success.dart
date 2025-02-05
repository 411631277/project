import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class SuccessWidget extends StatelessWidget {
  final String userId;
  const SuccessWidget({super.key, required this.userId});

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
                  '帳號創建成功!!!\n為了理解使用者目前狀況\n請填寫以下問卷',
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
                    logger
                        .i("🟢 SuccessWidget 正在導航到 BornWidget，userId: $userId");
                    Navigator.pushNamed(
                      context,
                      '/BornWidget', // ✅ 改用 routes 導航
                      arguments: userId, // ✅ 傳遞 userId
                    );
                  },
                  child: const Text(
                    '下一步',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
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
