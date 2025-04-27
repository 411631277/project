import 'dart:math' as math;
import 'package:doctor_2/first_question/finish.dart';
import 'package:flutter/material.dart';

class Melancholyscore extends StatelessWidget {
  final String userId;
  final int totalScore;

  const Melancholyscore({
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
    final String message;
  if (totalScore <= 9) {
  message = '您的身心狀況不錯，請繼續維持';
} else if (totalScore >= 10 && totalScore <= 12) {
  message = '請注意~您目前狀況可能有情緒困擾，讓您與身旁的人多聊聊，給心情一個出口，必要時可尋求專業人員協助';
} else {
  message = '您的身心健康狀況可能需要醫療專業的協助，請找專業醫師協助處理';
}

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
                '你的憂鬱總分：$totalScore',
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
                height: screenH * 0.08,
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
      builder: (context) => FinishWidget(
        userId: userId, // 這邊傳遞 id
      ),
    ),
  );
},
child: Text(
  '結束問卷',
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

          
         ),
         );
        
  }
}
