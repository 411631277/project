import 'dart:math' as math;
import 'package:doctor_2/questionGroup/melancholyGroup/melancholy.dart';
import 'package:flutter/material.dart';

class DourIntroduce2Page extends StatelessWidget {
   final String userId;
  const DourIntroduce2Page({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // 1. 取得螢幕尺寸與 base
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final base = math.min(screenWidth, screenHeight);

    // 配色
    final bgColor = const Color(0xFFE9E3D5);
    final textColor = const Color(0xFF4A4132);
    final buttonColor = const Color(0xFFB0A28D);

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
                  '請依據過去七天內自己的情緒狀態憑感覺選擇最符合自己感受的答案',
                  style: TextStyle(
                    color: textColor,
                    fontSize: base * 0.05,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            // 4. 下一步按鈕
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
                    backgroundColor: buttonColor,
                    minimumSize: Size(screenWidth * 0.8, base * 0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(base * 0.06),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MelancholyWidget(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '開始作答',
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
