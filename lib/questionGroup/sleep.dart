import 'package:flutter/material.dart';

class SleepWidget extends StatefulWidget {
  const SleepWidget({super.key, required String userId});

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
      "options": ["未發生", "約一兩次", "三次以上"],
    },
    {
      "type": "choice", // 選擇題
      "question": " 過去一個月來，您是否曾在用餐、開車或社交場合瞌睡而無法保持清醒，每星期約幾次?",
      "options": ["未發生", "約一兩次", "三次以上"],
    },
    {
      "type": "choice", // 選擇題
      "question": "過去一個月來,您會感到無心完成該做的事",
      "options": ["沒有", "有一點", "的確有", "很嚴重"],
    },
  ];

  final Map<int, String?> answers = {};

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.brown,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.brown.shade400,
                  ),
                  onPressed: () {
                    // 提交邏輯
                  },
                  child: const Text(
                    "下一步",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 填空題 Widget
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

  // 選擇題 Widget
  Widget _buildChoiceQuestion(int index, Map<String, dynamic> question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // 減少題目間距
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
          const SizedBox(height: 2), // 減少題目與選項間距
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: (question['options'] as List<String>)
                .map((option) => Expanded(
                      child: Row(
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
                          Flexible(
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(147, 129, 108, 1),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
