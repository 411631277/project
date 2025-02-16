import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

//註解已完成

final Logger logger = Logger();

class SleepWidget extends StatefulWidget {
  final String userId; // 接收 userId
  const SleepWidget({super.key, required this.userId});

  @override
  State<SleepWidget> createState() => _SleepWidgetState();
}

class _SleepWidgetState extends State<SleepWidget> {
  // 填空題的控制器
  final Map<int, TextEditingController> hourControllers = {
    for (int i = 0; i < 5; i++) i: TextEditingController(),
  };
  final Map<int, TextEditingController> minuteControllers = {
    for (int i = 0; i < 5; i++) i: TextEditingController(),
  };

  // 問題與選項的資料結構
  final List<Map<String, dynamic>> questions = [
    {
      "type": "fill", // 填空題
      "question": "過去一個月來，您通常何時上床？",
      "index": 0,
      "hasHour": true,
      "hasMinute": true,
    },
    {
      "type": "fill", // 填空題
      "question": "過去一個月來，您通常多久才能入睡？",
      "index": 1,
      "hasHour": false,
      "hasMinute": true,
    },
    {
      "type": "fill", // 填空題
      "question": "過去一個月來，您早上通常何時起床？",
      "index": 2,
      "hasHour": true,
      "hasMinute": true,
    },
    {
      "type": "fill", // 填空題
      "question": "過去一個月來，您通常實際睡眠可以入睡幾小時？",
      "index": 3,
      "hasHour": true,
      "hasMinute": false,
    },
    {
      "type": "fill", // 填空題
      "question": "過去一個月來，您平均而看您一天睡幾小時？",
      "index": 4,
      "hasHour": true,
      "hasMinute": false,
    },
    {
      "type": "choice", // 選擇題
      "question": "您覺得睡眠品質好嗎?",
      "options": ["很好", "好", "不好", "很不好"],
    },
    {
      "type": "choice", // 選擇題
      "question": "過去一個月來，整體而言，您覺得自己的睡眠品質如何？",
      "options": ["很好", "好", "不好", "很不好"],
    },
    {
      "type": "choice", // 選擇題
      "question": "過去一個月來，您通常一星期幾個晚上需要使用藥物幫忙睡眠？",
      "options": ["未發生", "約一兩次", "三次或以上"],
    },
    {
      "type": "choice", // 選擇題
      "question": "過去一個月來，您是否曾在用餐、開車或社交場合瞌睡而無法保持清醒，每星期約幾次?",
      "options": ["未發生", "約一兩次", "三次或以上"],
    },
    {
      "type": "choice", // 選擇題
      "question": "過去一個月來，您會感到無心完成該做的事",
      "options": ["沒有", "有一點", "的確有", "很嚴重"],
    },
  ];

  final Map<int, String?> answers = {};

  // 檢查是否所有題目都填寫完成
  bool _isAllQuestionsAnswered() {
    // 檢查填空題是否填寫完成
    for (int i = 0; i < 5; i++) {
      if (questions[i]['hasHour'] && hourControllers[i]!.text.trim().isEmpty) {
        return false;
      }
      if (questions[i]['hasMinute'] &&
          minuteControllers[i]!.text.trim().isEmpty) {
        return false;
      }
    }

    // 檢查選擇題是否填寫完成
    for (int i = 5; i < questions.length; i++) {
      if (answers[i] == null || answers[i]!.isEmpty) {
        return false;
      }
    }

    // 如果所有檢查都通過，返回 true
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "睡眠評估問卷",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  if (question["type"] == "fill") {
                    // 填空題處理
                    return _buildFillQuestion(question);
                  } else if (question["type"] == "choice") {
                    // 選擇題處理
                    return _buildChoiceQuestion(index, question);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); //回去上一頁
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Image.asset(
                    'assets/images/back.png',
                    width: screenWidth * 0.15,
                  ),
                ),
              ),

              // 顯示下一步按鈕僅在所有問題都填寫完整時
              if (_isAllQuestionsAnswered())
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.brown.shade400,
                  ),
                  onPressed: () async {
                    await _saveAnswersToFirebase();
                    if (!context.mounted) return;
                    Navigator.pushNamed(
                      context,
                      '/Sleep2Widget',
                      arguments: widget.userId,
                    );
                  },
                  child: const Text(
                    "下一步",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFillQuestion(Map<String, dynamic> question) {
    final int index = question["index"];
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "${index + 1}. ${question['question']}",
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ),
          if (question["hasHour"]) ...[
            Expanded(
              flex: 1,
              child: TextField(
                controller: hourControllers[index],
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 12),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (_) => setState(() {}), // 輸入時更新
              ),
            ),
            const Text(
              "時",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ],
          if (question["hasMinute"]) ...[
            Expanded(
              flex: 1,
              child: TextField(
                controller: minuteControllers[index],
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 12),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const Text(
              "分",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChoiceQuestion(int index, Map<String, dynamic> question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${index + 1}. ${question['question']}",
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
          const SizedBox(height: 5),
          Column(
            children: (question['options'] as List<String>)
                .map((option) => Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: answers[index],
                          onChanged: (value) {
                            setState(() {
                              answers[index] = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(147, 129, 108, 1),
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<bool> _saveAnswersToFirebase() async {
    try {
      final Map<String, String?> formattedAnswers = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      for (int i = 0; i < 5; i++) {
        String hour = hourControllers[i]!.text.trim();
        String minute = minuteControllers[i]!.text.trim();

        if (hour.isNotEmpty || minute.isNotEmpty) {
          formattedAnswers["填空題 ${i + 1}"] =
              "${hour.isNotEmpty ? "$hour時" : ""} ${minute.isNotEmpty ? "$minute分" : ""}"
                  .trim();
        }
      }

      final DocumentReference docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc("SleepWidget");

      // 覆蓋舊資料，指定 key
      await docRef.set({
        "answers": {
          "SleepWidget": {
            "data": formattedAnswers,
            "timestamp": Timestamp.now(),
          }
        }
      }, SetOptions(merge: true));

      logger.i("✅ SleepWidget 資料已成功儲存並覆蓋舊檔案！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存 SleepWidget 資料時發生錯誤：$e");
      return false;
    }
  }
}
