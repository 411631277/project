import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class ReviseWidget extends StatelessWidget {
  final String userId; // ✅ 接收 userId
  final bool isManUser;
  const ReviseWidget(
      {super.key, required this.userId, required this.isManUser});

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
            // **背景框**
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.2,
              child: Container(
                width: screenWidth * 0.6,
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // **成功訊息**
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.28,
              child: Text(
                '資料修改成功!!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // **返回按鈕**
            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.37,
              child: SizedBox(
                width: screenWidth * 0.26,
                height: screenHeight * 0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.white.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context,
                        isManUser ? '/HomeScreenWidget' : '/FaHomeScreenWidget',
                        arguments: {
                          'userId': userId,
                          'isManUser': isManUser,
                        }); // 替換成你的頁面路徑
                  },
                  child: Text(
                    '返回',
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.6),
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'Inter',
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
