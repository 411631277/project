//憂鬱量表
import 'dart:convert';
import 'dart:math' as math;
import 'package:doctor_2/home/fa_question.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MelancholyWidget extends StatefulWidget {
  final String userId;
  final bool isManUser;
  const MelancholyWidget(
      {super.key, required this.userId, required this.isManUser});

  @override
  State<MelancholyWidget> createState() => _MelancholyWidgetState();
}

class _MelancholyWidgetState extends State<MelancholyWidget> {
  final List<String> questions = [
    '我能開懷的笑並看到事物有趣的一面',
    '我能夠以快樂的心情來期待事情',
    '當事情不順利時，我會不必要的責備自己',
    '我會無緣無故感到焦慮和擔心',
    '我會無緣無故感到害怕和驚慌',
    '事情壓得我喘不過氣',
    '我很不開心以致失眠',
    '我感到悲傷和難過',
    '我的不快樂導致我哭泣',
    '我會有傷害自己的想法',
  ];

  /// 每題對應的選項
  final Map<int, List<String>> questionOptions = {
    0: ["同以前一樣", "沒有以前那麼多", "肯定比以前少", "完全不能"],
    1: ["同以前一樣", "沒有以前那麼多", "肯定比以前少", "完全不能"],
    2: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
    3: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
    4: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
    5: ["大多數時候我都不能應付", "有時候我不能像平常時那樣應付得好", "大部分時候我都能像平時那樣應付得好", "我一直都能應付得好"],
    6: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
    7: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
    8: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
    9: ["相當多時候這樣", "有時候這樣", "很少這樣", "沒有這樣"],
  };

  /// 紀錄每題選擇的答案
  final Map<int, String?> answers = {};

  /// 檢查是否所有題目都已作答
  bool _isAllQuestionsAnswered() {
    return answers.length == questions.length && !answers.containsValue(null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth * 0.045; // 自適應字體大小

    return PopScope(
        canPop: false,
        // ignore: deprecated_member_use
        onPopInvoked: (didPop) {
          if (widget.isManUser) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FaQuestionWidget(
                  userId: widget.userId,
                  isManUser: true,
                ),
              ),
            );
          } else {
            Navigator.pushReplacementNamed(
              context,
              '/QuestionWidget',
              arguments: {
                'userId': widget.userId,
                'isManUser': false,
              },
            );
          }
        },
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
                      '憂鬱量表',
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
                    SizedBox(height: screenHeight * 0.02),

                    /// 按鈕區
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// 返回按鈕
                        GestureDetector(
                          onTap: () {
                            if (widget.isManUser) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FaQuestionWidget(
                                    userId: widget.userId,
                                    isManUser: true,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                '/QuestionWidget',
                                arguments: {
                                  'userId': widget.userId,
                                  'isManUser': false,
                                },
                              );
                            }
                          },
                          child: Transform.rotate(
                            angle: math.pi,
                            child: Image.asset(
                              'assets/images/back.png',
                              width: screenWidth * 0.12,
                            ),
                          ),
                        ),

                        /// 只有全部題目都回答後才顯示「下一步」按鈕
                        if (_isAllQuestionsAnswered())
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.08,
                                vertical: screenHeight * 0.015,
                              ),
                              backgroundColor: Colors.brown.shade400,
                            ),
                            onPressed: () async {
                              final success = await _saveAnswersToFirebase();
                              if (!context.mounted) return;

                              if (success) {
                                int totalScore = _calculateTotalScore();
                                Navigator.pushNamed(
                                  context,
                                  '/Melancholyscore',
                                  arguments: {
                                    'userId': widget.userId,
                                    'answers': answers,
                                    'totalScore': totalScore,
                                    'isManUser': widget.isManUser,
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('伺服器發生問題，請稍後再嘗試')),
                                );
                              }
                            },
                            child: Text(
                              "填答完成",
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
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
    List<String> options =
        questionOptions[questionIndex] ?? ["可以", "還行", "不行", "沒辦法"];

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
                  groupValue: answers[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      answers[questionIndex] = value!;
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
  Future<bool> _saveAnswersToFirebase() async {
    final collectionName = widget.isManUser ? "Man_users" : "users";
    try {
      // 1. 整理使用者的作答
      final Map<String, String?> formattedAnswers = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      // 2. 計算總分
      final int totalScore = _calculateTotalScore();

      // ⭐ 先送 SQL
      final bool sqlOK = await sendMelancholyAnswersToMySQL(
          widget.userId, answers, totalScore);
      if (!sqlOK) {
        throw Exception("SQL 同步失敗");
      }

      // 3. 儲存到 Firestore
      final CollectionReference userResponses = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(widget.userId)
          .collection("questions");

      await userResponses.doc('melancholy').set({
        'answers': formattedAnswers,
        'totalScore': totalScore,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 4. 更新「melancholyCompleted = true」讓主問卷列表顯示已完成
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(widget.userId)
          .update({"melancholyCompleted": true});

      logger.i("✅ 憂鬱量表問卷已成功儲存，並更新 melancholyCompleted！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存憂鬱量表問卷時發生錯誤：$e");
      return false;
    }
  }

  Future<bool> sendMelancholyAnswersToMySQL(
      String userId, Map<int, String?> answers, int totalScore) async {
    final url = Uri.parse('http://163.13.201.85:3000/dour');

    // 取得今天日期（格式：2025-04-19）
    final now = DateTime.now();
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final String idKey = widget.isManUser ? 'man_user_id' : 'user_id';

    final Map<String, dynamic> payload = {
      idKey: int.parse(userId),
      "dour_question_content": "憂鬱量表",
      'dour_test_date': formattedDate,
      'dour_score': totalScore, // 🔥 新增總分
    };

    for (int i = 0; i < 10; i++) {
      final selectedText = answers[i];
      final answerScore = getScore(i, selectedText!);
      payload['dour_answer_${i + 1}'] = answerScore.toString();
    }

    logger.i("📦 準備送出憂鬱量表資料 payload：$payload");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final result = jsonDecode(response.body);
        logger.i(
            "✅ 憂鬱問卷同步成功：${result['message']} (insertId: ${result['insertId']})");
        return true;
      } else {
        logger.e("❌ 憂鬱問卷同步失敗：${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("❌ 發送憂鬱問卷到MySQL時出錯：$e");
      return false;
    }
  }

  int getScore(int questionIndex, String answerText) {
    if (questionIndex >= 0 && questionIndex <= 2) {
      final Map<String, int> scoreMap = {
        '同以前一樣': 0,
        '沒有以前那麼多': 1,
        '肯定比以前少': 2,
        '完全不能': 3,
      };
      return scoreMap[answerText] ?? 0;
    } else {
      final Map<String, int> scoreMap = {
        '沒有這樣': 0,
        '很少這樣': 1,
        '有時候這樣': 2,
        '相當多時候這樣': 3,
        '大部分時候我都不能應付': 3,
        '有時候不能像平常時候應付得好': 2,
        '大部分時候我都能像平常時候應付得好': 1,
        '我一直都能應付得好': 0,
      };
      return scoreMap[answerText] ?? 0;
    }
  }

  int _calculateTotalScore() {
    int totalScore = 0;

    answers.forEach((index, answer) {
      final options = questionOptions[index];
      if (options != null && answer != null) {
        int optionIndex = options.indexOf(answer);

        if (optionIndex != -1) {
          if (index == 0 || index == 1) {
            // 第1、2題是正向計分 (0,1,2,3)
            totalScore += optionIndex;
          } else {
            // 第3～10題是反向計分 (3,2,1,0)
            totalScore += (3 - optionIndex);
          }
        }
      }
    });

    return totalScore;
  }
}
