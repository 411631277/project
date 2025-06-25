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
    message = '您的情緒可能正處於較大的壓力或憂鬱狀態，目前情緒困擾可能較為明顯，照顧孩子的同時，別忘了自己的情緒也需要被好好照顧。建議您儘早尋求社區心理諮詢或相關資源協助，例如心理師諮詢、親職支持團體等，也可善用AI機器人尋求幫助。照顧好自己，才能更有力量陪伴孩子。';
  } else {
    message = '您的心理狀態良好，具備穩定的情緒調節與應對能力。這樣的狀態有助於與孩子建立正向互動。';
  }
} else if (totalScore >= 10 && totalScore <= 12) {
  if (answers[9] != "沒有這樣") {
    message = '您的情緒可能正處於較大的壓力或憂鬱狀態，目前情緒困擾可能較為明顯，照顧孩子的同時，別忘了自己的情緒也需要被好好照顧。建議您儘早尋求社區心理諮詢或相關資源協助，例如心理師諮詢、親職支持團體等，也可善用AI機器人尋求幫助。照顧好自己，才能更有力量陪伴孩子。';
  } else {
    message = '您的量表分數顯示情緒上可能正承受些許壓力，育兒過程中的疲憊與挑戰都是真實存在的，辛苦您了。建議可尋找信任的人傾訴心情，或安排簡單的自我照顧活動，如短暫散步、寫下每日小感謝。若情緒持續感到低落，也可以考慮尋求專業支持。';
  }
} else {
  message = '您的情緒可能正處於較大的壓力或憂鬱狀態，目前情緒困擾可能較為明顯，照顧孩子的同時，別忘了自己的情緒也需要被好好照顧。\n\n建議您儘早尋求社區心理諮詢或相關資源協助，例如心理師諮詢、親職支持團體等，也可善用AI機器人尋求幫助。照顧好自己，才能更有力量陪伴孩子。';
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

   if (answers[9] == "沒有這樣")
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
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: base * 0.055,
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
