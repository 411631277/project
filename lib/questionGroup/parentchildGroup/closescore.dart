import 'dart:math' as math;
import 'package:doctor_2/questionGroup/parentchildGroup/adapt.dart';
import 'package:flutter/material.dart';

class Closescore extends StatelessWidget {
  final String userId;
  final int totalScore;

  const Closescore({
    super.key,
    required this.userId,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    // 取得螢幕尺寸
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final base = math.min(screenW, screenH);

    // 根據分數挑文字
    final message = totalScore < 34
      ? '媽媽最近和孩子相處有遇到什麼問題嗎？\n\n如果有需求可以使用app的AI問答功能，或是撥打以下電話諮詢喔！'
      : '和寶寶的關係不錯呢，繼續保持溫暖的互動吧！';

    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: base * 0.06,
            vertical: base * 0.04,
          ),
          child: Column(
            children: [
              Spacer(flex: 2),

              Text(
                '你的總分：$totalScore',
                style: TextStyle(
                  fontSize: base * 0.08,
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: base * 0.06),

              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: base * 0.06,
                  height: 1.4,
                  color: const Color.fromRGBO(165, 146, 125, 1),
                ),
              ),

              Spacer(flex: 3),

              // 按鈕往下一點點
              SizedBox(height: base * 0.05),

              SizedBox(
                width: screenW * 0.7,
                height: screenH * 0.1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0A28D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(base * 0.04),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenH * 0.02,
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdaptWidget(
        userId: userId, // 這邊傳遞 id
      ),
    ),
  );
},
child: Text(
  '繼續填答',
  style: TextStyle(
    fontSize: base * 0.06,
    color: Colors.white,
    fontWeight: FontWeight.w600,
                    ),
                    ),
                    ),
                  ),
                   Spacer(flex: 1),
              ]  ),
              ),

          
  
          ),);
        
  }
}
