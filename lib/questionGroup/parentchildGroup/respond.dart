//4.回應信心

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/services/backend3000/backend3000.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class RespondWidget extends StatefulWidget {
  final String userId;
  const RespondWidget({super.key, required this.userId});

  @override
  State<RespondWidget> createState() => _RespondWidgetState();
}

class _RespondWidgetState extends State<RespondWidget> {
  final List<String> questions = [
    "我能察覺孩子「想睡覺」的訊號",
    "我會由孩子的表情或動作，來猜測他的需求",
    "我知道孩子的需求和情緒",
    "我能有效地安撫孩子",
    "我會依照孩子的反應，來調整照顧他的方式",
    "我對照顧孩子的方式有信心",
  ];

  /// 每題對應的選項
  final Map<int, List<String>> questionOptions = {
    0: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    1: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    2: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    3: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    4: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    5: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
  };

  /// 紀錄每題選擇的答案
  final Map<int, String?> respond = {};

  /// 檢查是否所有題目都已作答
  bool _isAllQuestionsAnswered() {
    return respond.length == questions.length && !respond.containsValue(null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth * 0.045; // 自適應字體大小

    return PopScope(
        canPop: false, // ❗這行就是鎖定返回鍵
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(233, 227, 213, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      '回應信心',
                      style: TextStyle(
                        fontSize: fontSize * 1.2,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(147, 129, 108, 1),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    /// 顯示題目列表
                    Expanded(
                      child: ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          return _buildQuestionRow(
                              index, screenWidth, fontSize);
                        },
                      ),
                    ),

                    /// 只有全部題目都回答後才顯示「下一步」按鈕
                    if (_isAllQuestionsAnswered())
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                              vertical: screenHeight * 0.015,
                            ),
                            backgroundColor: Colors.brown.shade400,
                          ),
                          onPressed: () async {
                            // 1. 計算總分
                            int totalScore = _calculateTotalScore();
                            final args = {
                              'userId': widget.userId,
                              'totalScore': totalScore,
                            };
                            bool ok = await _saverespondAndScore(totalScore);
                            if (!ok) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('伺服器錯誤,請稍後再嘗試')),
                              );
                              return;
                            }

                            // 3. 導頁
                            if (!context.mounted) return;
                            Navigator.pushNamed(
                              context,
                              '/Respondscore',
                              arguments: args,
                            );
                          },
                          child: Text(
                            "填答完成",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            )));
  }

  /// 建立單題的選項 UI
  Widget _buildQuestionRow(
      int questionIndex, double screenWidth, double fontSize) {
    List<String> options = questionOptions[questionIndex] ??
        ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${questionIndex + 1}. ${questions[questionIndex]}',
          style: TextStyle(
            fontSize: fontSize,
            color: const Color.fromRGBO(147, 129, 108, 1),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),

        /// 顯示該題的所有選項
        Column(
          children: options.map((option) {
            return Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: respond[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      respond[questionIndex] = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: const Color.fromRGBO(147, 129, 108, 1),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }

  /// 將作答結果儲存到 Firestore，並更新 melancholyCompleted = true
  Future<bool> _saverespondAndScore(int totalScore) async {
    bool sqlOk =
        await sendRespondAnswersToMySQL(widget.userId, respond, totalScore);
    if (!sqlOk) return false;
    try {
      final String documentName = "AttachmentWidget";

      final Map<String, String> formattedrespond = respond.map(
        (k, v) => MapEntry(k.toString(), v!),
      );

      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc(documentName);

      // 先取得舊資料
      final docSnapshot = await docRef.get();
      Map<String, dynamic> existingData = {};

      if (docSnapshot.exists) {
        existingData = docSnapshot.data() ?? {};
      }

      // 把新的 respond 加進去，不會覆蓋掉舊的 close
      existingData['respond'] = formattedrespond;
      existingData['RespondTotalScore'] = totalScore;
      existingData['timestamp'] = Timestamp.now();

      await docRef.set(existingData);

      // 更新 attachmentCompleted
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .update({"attachmentCompleted": true});
      await sendRespondAnswersToMySQL(widget.userId, respond, totalScore);
      logger.i("✅ 問卷已成功合併並儲存！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存問卷時發生錯誤：$e");
      return false;
    }
  }

  /// 1〜6 分對應陣列索引 +1，計算所有題目的總分
  int _calculateTotalScore() {
    return respond.entries.map((entry) {
      // 找到該題答案在 options 陣列的索引，再＋1 成為分數
      final score = questionOptions[entry.key]!.indexOf(entry.value!) + 1;
      return score;
    }).fold(0, (acc, element) => acc + element);
  }

  Future<bool> sendRespondAnswersToMySQL(
      String userId, Map<int, String?> answers, int totalScore) async {
    final payload = {
      'user_id': int.parse(userId),
      'attachment_question_content': 'attachment', // ✅ 固定問卷分類
      'attachment_test_date': DateTime.now().toIso8601String().split('T')[0],
      'attachment_score_d': totalScore, // ✅ Respond 對應 D 分數欄位
    };

    const int baseIndex = 19; // 從 attachment_answer_20 開始
    answers.forEach((index, answerText) {
      if (answerText != null && answerText.isNotEmpty) {
        final options = questionOptions[index] ?? [];
        int optionIndex = options.indexOf(answerText);
        int score = optionIndex >= 0 ? (optionIndex + 1) : 0;
        payload['attachment_answer_${baseIndex + index + 1}'] =
            score.toString();
      }
    });

    logger.i("📦 Respond payload: $payload");

   try {
  final result = await Backend3000.attachmentApi.submitAttachment(payload);
  logger.i("✅ Respond 資料同步成功：${result['message'] ?? ''} (insertId: ${result['insertId'] ?? ''})");
  return true;
} catch (e, stack) {
  logger.e("🔥 發送 Respond 時發生錯誤", error: e, stackTrace: stack);
  return false;
}
  }
}
