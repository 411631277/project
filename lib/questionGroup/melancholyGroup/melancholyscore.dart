import 'dart:math' as math;
import 'package:doctor_2/first_question/finish.dart';
import 'package:flutter/material.dart';

class Melancholyscore extends StatelessWidget {
  final String userId;
  final int totalScore;
  final bool isManUser;
  final Map<int, String> answers;
  const Melancholyscore({
    super.key,
    required this.userId,
    required this.totalScore,
    required this.answers,
    required this.isManUser
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
  // ✅ 檢查第 10 題是否是 "沒有這樣"
  if (answers[9] != "沒有這樣") {
    message = '您的情緒可能正處於較大的壓力或憂鬱狀態，建議主動尋求專業協助，也可善用AI機器人尋求幫助';
  } else {
    message = '您的心理狀態相當健康且穩定，請持續保持正面心態，並多參與讓您感到愉悅的活動';
  }
} else if (totalScore >= 10 && totalScore <= 12) {
  if (answers[9] != "沒有這樣") {
    message = '您的情緒可能正處於較大的壓力或憂鬱狀態，建議主動尋求專業協助，也可善用AI機器人尋求幫助';
  } else {
    message = '您的情緒略為低落，建議您可多與朋友或家人談心，也可透過喜歡的活動來放鬆心情';
  }
} else {
  message = '您的情緒可能正處於較大的壓力或憂鬱狀態，建議主動尋求專業協助，也可善用AI機器人尋求幫助';
}

    return PopScope(
    canPop: false, // ❗這行就是鎖定返回鍵
    child: Scaffold(
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
        userId: userId, 
        isManUser: isManUser , 
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
         ));
        
  }
}
