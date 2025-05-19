import 'dart:math' as math;
import 'package:doctor_2/questionGroup/knowledgeGroup/knowledge_wrong.dart';
import 'package:flutter/material.dart';

class KnowledgeScore extends StatelessWidget {
  final List<Map<String, dynamic>> wrongAnswers;
  final String userId;
  final bool isManUser; 
  final int totalScore;

  const KnowledgeScore({
    super.key,
    required this.wrongAnswers,
    required this.userId,
    required this.totalScore,
    required this.isManUser
  });

  @override
  Widget build(BuildContext context) {
    // 取得螢幕尺寸
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final base = math.min(screenW, screenH);

    // 根據分數挑文字
    final message = totalScore < 60
      ? '對於母乳哺餵知識還有些欠缺喔\n\n如果有需求可以使用app的AI問答功能，或是撥打以下電話諮詢喔！'
      : '你知道得真多呢!!';

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
                '你的哺乳知識總分：$totalScore',
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
      builder: (context) => WrongAnswersPage(
        userId: userId, // 這邊傳遞 id
        isManUser: isManUser,
        wrongAnswers: wrongAnswers,
      ),
    ),
  );
},
child: Text(
  '下一步',
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