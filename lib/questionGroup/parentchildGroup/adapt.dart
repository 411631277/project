//2..親職適應
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class AdaptWidget extends StatefulWidget {
  final String userId;
  const AdaptWidget({super.key, required this.userId});

  @override
  State<AdaptWidget> createState() => _AdaptWidgetState();
}

class _AdaptWidgetState extends State<AdaptWidget> {
  final List<String> questions = [
    "我在照顧孩子的時候，會感到不耐煩",
    "時時要滿足孩子的需求，讓我感到沮喪",
    "如果孩子干擾到我的休息，我會感到討厭",
    "我覺得自己像是個照顧孩子的機器",
    "照顧孩子讓我感到筋疲力盡",
    "我會對孩子生氣",
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
  final Map<int, String?> adapt = {};

  /// 檢查是否所有題目都已作答
  bool _isAllQuestionsAnswered() {
    return adapt.length == questions.length && !adapt.containsValue(null);
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
                      '親職適應',
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
                            int totalScore = _calculateTotalScore();
                            // 1. 傳 SQL
                            bool sqlOk = await sendAdaptAnswersToMySQL(
                                widget.userId, adapt, totalScore);
                            if (!sqlOk) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('伺服器錯誤,請稍後再嘗試')),
                              );
                              return;
                            }
                            // 2. 傳 Firebase
                            bool fbOk = await _saveadaptAndScore(totalScore);
                            if (!fbOk) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('伺服器錯誤,請稍後再嘗試')),
                              );
                              return;
                            }
                            // 3. 導頁
                            if (!context.mounted) return;
                            Navigator.pushNamed(
                              context,
                              '/Adaptscore',
                              arguments: {
                                'userId': widget.userId,
                                'totalScore': totalScore
                              },
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
                  groupValue: adapt[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      adapt[questionIndex] = value!;
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
  Future<bool> _saveadaptAndScore(int totalScore) async {
    try {
      final String documentName = "AttachmentWidget";

      final Map<String, String> formattedadapt = adapt.map(
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

      // 把新的 adapt 加進去，不會覆蓋掉舊的 close
      existingData['adapt'] = formattedadapt;
      existingData['AdaptTotalScore'] = totalScore;
      existingData['timestamp'] = Timestamp.now();

      await docRef.set(existingData);

      // 更新 attachmentCompleted
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .update({"attachmentCompleted": true});
      logger.i("✅ 問卷已成功合併並儲存！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存問卷時發生錯誤：$e");
      return false;
    }
  }

  /// 1〜6 分對應陣列索引 +1，計算所有題目的總分
  int _calculateTotalScore() {
    return adapt.entries.map((entry) {
      final index = questionOptions[entry.key]!.indexOf(entry.value!);
      // 使用 6 - index 來反轉分數
      final score = 6 - index;
      return score;
    }).fold(0, (acc, element) => acc + element);
  }

  Future<bool> sendAdaptAnswersToMySQL(
      String userId, Map<int, String?> answers, int totalScore) async {
    final url = Uri.parse('http://163.13.201.85:3000/attachment');

    final payload = {
      'user_id': int.parse(userId),
      'attachment_question_content': 'attachment',
      'attachment_test_date': DateTime.now().toIso8601String().split('T')[0],
      'attachment_score_b': totalScore,
    };

    // ✅ 只傳有填的題目
    int baseIndex = 7; // Close 用了 1~7，Adapt 從第8題開始
    answers.forEach((index, answerText) {
      if (answerText != null && answerText.isNotEmpty) {
        final options = questionOptions[index] ?? [];
        int optionIndex = options.indexOf(answerText);
        int score = optionIndex >= 0 ? (6 - optionIndex) : 0;
        payload['attachment_answer_${baseIndex + index + 1}'] =
            score.toString();
      }
    });

    logger.i("📦 Adapt payload: $payload");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final result = jsonDecode(response.body);
        logger.i(
            "✅ Adapt 資料同步成功：${result['message']} (insertId: ${result['insertId']})");
        return true;
      } else {
        logger.e("❌ Adapt 資料同步失敗: ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("🔥 發送 Adapt 時錯誤: $e");
      return false;
    }
  }
}
