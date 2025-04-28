import 'dart:math' as math;
import 'package:doctor_2/questionGroup/melancholyGroup/dour_introduce2.dart';
import 'package:flutter/material.dart';

/// 憂鬱量表說明頁面
class DourIntroduce1Page extends StatelessWidget {
  final String userId;

  const DourIntroduce1Page({super.key, required this.userId});

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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: base * 0.05,
                  vertical:   base * 0.03,
                ),
                child: Text(
                  '''由於懷孕時荷爾蒙的變化，會影響腦內神經傳導物質的變化，可能會產生焦慮跟憂鬱的狀況。

產後憂鬱量表是一種用於評估產後婦女憂鬱症狀的工具，由產後婦女依照過去七天的狀況憑感覺回答十個簡短的陳述句，幫助產後婦女及醫護人員早期發現產後憂鬱症。''',
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
                        builder: (context) => DourIntroduce2Page(
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