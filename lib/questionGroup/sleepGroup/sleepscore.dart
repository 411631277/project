import 'dart:math' as math;
import 'package:doctor_2/questionGroup/parentchildGroup/promise.dart';
import 'package:flutter/material.dart';

class Sleepscore extends StatelessWidget {
  final String userId;
  final int totalScore;
  final Map<String, int> scoreMap;

  const Sleepscore({
    super.key,
    required this.userId,
    required this.totalScore,
    required this.scoreMap,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    final base = math.min(screenW, screenH);

    final message = totalScore < 18
        ? '媽媽在照顧寶寶上是不是會覺得有些負擔呢？\n\n可以利用APP的AI問答或是或是撥打以下電話諮詢喔！'
        : '看來媽媽在新的身分上有取得平衡點呢！';

    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
          body: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: base * 0.06,
              vertical: base * 0.04,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔽 分數列表顯示，包含評語
                  for (var entry in scoreMap.entries)
                    Padding(
                      padding: EdgeInsets.only(bottom: base * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 分數顯示
                          Text(
                            '${entry.key}：${entry.value}',
                            style: TextStyle(
                              fontSize: base * 0.06,
                              color: const Color.fromRGBO(110, 97, 78, 1),
                            ),
                          ),
                          SizedBox(height: base * 0.02),
                          // 評語顯示（置中）
                          Center(
                            child: Text(
                              _getScoreDescription(entry.key, entry.value),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: base * 0.045,
                                color: const Color.fromRGBO(147, 129, 108, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ✅ 顯示總分（只顯示一次）
                  Text(
                    '你的總分：$totalScore',
                    style: TextStyle(
                      fontSize: base * 0.08,
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: base * 0.04),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: base * 0.06,
                      height: 1.4,
                      color: const Color.fromRGBO(165, 146, 125, 1),
                    ),
                  ),

                  // ✅ 繼續填答按鈕
                  SizedBox(height: base * 0.06),
                  SizedBox(
                    width: screenW * 0.7,
                    height: screenH * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB0A28D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(base * 0.04),
                        ),
                        padding: EdgeInsets.symmetric(vertical: screenH * 0.02),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromiseWidget(userId: userId),
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
                  SizedBox(height: base * 0.06),
                ],
              ),
            ),
          ))),
    );
  }

  String _getScoreDescription(String category, int score) {
    switch (category) {
      case '主觀睡眠品質分數':
        return score == 0
            ? '非常好'
            : score == 1
                ? '普通'
                : score == 2
                    ? '較差'
                    : '非常差';
      case '入睡困難分數':
        return score == 0
            ? '沒有困難'
            : score == 1
                ? '偶爾困難'
                : score == 2
                    ? '經常困難'
                    : '幾乎無法入睡';
      case '睡眠持續時間分數':
        return score == 0
            ? '充足'
            : score == 1
                ? '稍微不足'
                : score == 2
                    ? '不足'
                    : '非常不足';
      case '睡眠效率分數':
        return score == 0
            ? '效率很好'
            : score == 1
                ? '效率普通'
                : score == 2
                    ? '效率差'
                    : '效率極差';
      case '睡眠干擾分數':
        return score == 0
            ? '幾乎不受干擾'
            : score == 1
                ? '有些干擾'
                : score == 2
                    ? '干擾明顯'
                    : '嚴重干擾';
      case '藥物使用分數':
        return score == 0
            ? '從未使用'
            : score == 1
                ? '偶爾使用'
                : score == 2
                    ? '經常使用'
                    : '每天都使用';
      case '日間功能分數':
        return score == 0
            ? '功能良好'
            : score == 1
                ? '輕微影響'
                : score == 2
                    ? '明顯影響'
                    : '無法正常生活';
      default:
        return '';
    }
  }
}
