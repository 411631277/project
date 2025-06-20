import 'dart:math' as math;
import 'package:doctor_2/first_question/finish.dart';
import 'package:flutter/material.dart';

class Respondscore extends StatelessWidget {
  final String userId;
  final int totalScore;

  const Respondscore({
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
    final message = totalScore < 22
      ? '量表結果顯示，在覺察與回應孩子需求方面，您可能正在經歷一些挑戰。這很常見，也反映出育兒過程中可能的疲憊與壓力。可試著從觀察孩子的表情、動作或情緒變化開始，給予簡單的回應，例如一個擁抱、說一句『我在這裡』。每天一點點的關注與回應，就能幫助孩子感受到被理解與接納。可以善用AI協助，培養更好的應對技巧。一點一滴的努力，孩子都感受得到。您不是一個人，也不需要完美，只要願意學習與靠近，關係就會慢慢變得更親密。'
      : '您的回應性表現非常良好，能細膩地覺察孩子的情緒與需求，並適時地給予回應與支持。這樣的互動，有助於建立孩子的安全感與信任感。一點一滴的努力，孩子都感受得到。';

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
      builder: (context) => FinishWidget(
        userId: userId, isManUser: false, // 這邊傳遞 id
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
      ) );
        
  }
}
