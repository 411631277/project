import 'dart:math' as math;
import 'package:doctor_2/questionGroup/parentchildGroup/parentchild2.dart';
import 'package:flutter/material.dart';

/// 母嬰連結說明頁面
class MaternalConnectionPage extends StatelessWidget {
  final String userId;

  const MaternalConnectionPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final base = math.min(screenWidth, screenHeight);

    final bgColor   = const Color(0xFFE9E3D5);
    final textColor = const Color(0xFF4A4132);

  return PopScope(
    canPop: false, // ❗這行就是鎖定返回鍵
    child: Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.3),
            // 2. 滾動文字區塊
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: base * 0.05,
                  vertical: base * 0.03,
                ),
                child: Text(
                   '''母嬰連結是指母親對於嬰兒的態度、認知、想法以及對嬰兒願意付出的程度，在懷孕時就開始產生母嬰連結，而母嬰連結是好是壞，影響母親及嬰兒的重要關鍵。''',
                  style: TextStyle(
                    color: textColor,
                    fontSize: base * 0.05,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            // 下一步按鈕
            Padding(
              padding: EdgeInsets.only(
                top: base * 0.02,
                bottom: base * 0.04,
              ),
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenHeight * 0.08,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0A28D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(base * 0.06),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // 用 MaterialPageRoute 明確傳 userId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaternalConnectionPage2(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      fontSize: base * 0.05,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
