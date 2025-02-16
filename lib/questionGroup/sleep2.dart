import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

//註解已完成

final Logger logger = Logger();

class Sleep2Widget extends StatefulWidget {
  final String userId; //接收 userId
  const Sleep2Widget({super.key, required this.userId});

  @override
  State<Sleep2Widget> createState() => _Sleep2Widget();
}

class _Sleep2Widget extends State<Sleep2Widget> {
  final List<String> questions = [
    "無法在 30 分鐘內入睡",
    "半夜或凌晨便清醒",
    "必須起來上廁所",
    "覺得呼吸不順暢",
    "大聲打鼾或咳嗽",
    "會覺得冷",
    "覺得躁熱",
    "睡覺時常會做惡夢",
    "身上有疼痛",
  ];

  final Map<int, String?> answers = {};
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            color: const Color.fromRGBO(233, 227, 213, 1),
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "睡眠評估問卷\n\n以下問題選擇一個適當的答案打勾,請全部作答",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
              const SizedBox(height: 20),

              // 問卷表格
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    border: TableBorder.symmetric(
                      inside:
                          BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(233, 227, 213, 1),
                        ),
                        children: [
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.topCenter, // 文字置中靠上
                                child: const Text(
                                  "題目",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("從未發生",
                                    style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("約一兩次",
                                    style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("三次或以上",
                                    style: TextStyle(fontSize: 12))),
                          ),
                        ],
                      ),
                      for (int i = 0; i < questions.length; i++)
                        TableRow(
                          children: [
                            Text("${i + 1}. ${questions[i]}",
                                style: const TextStyle(fontSize: 14)),
                            Center(
                              child: Radio<String>(
                                value: "從未發生",
                                groupValue: answers[i],
                                onChanged: (value) {
                                  setState(() {
                                    answers[i] = value;
                                  });
                                },
                              ),
                            ),
                            Center(
                              child: Radio<String>(
                                value: "約一兩次",
                                groupValue: answers[i],
                                onChanged: (value) {
                                  setState(() {
                                    answers[i] = value;
                                  });
                                },
                              ),
                            ),
                            Center(
                              child: Radio<String>(
                                value: "三次或以上",
                                groupValue: answers[i],
                                onChanged: (value) {
                                  setState(() {
                                    answers[i] = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 按鈕區域
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // 返回按鈕
                  },
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Image.asset(
                      'assets/images/back.png',
                      width: screenWidth * 0.15,
                    ),
                  ),
                ),
                // 下一步按鈕（所有問題都回答後才會顯示）
                if (answers.length == questions.length)
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
                        '/FinishWidget', //跳轉結束畫面
                        arguments: widget.userId,
                      );
                    },
                    child: const Text(
                      "下一步",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
              ]),
            ])));
  }

  //儲存firebase的方法
  Future<bool> _saveAnswersToFirebase() async {
    try {
      final Map<String, String?> formattedAnswers = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      final DocumentReference docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc("SleepWidget");

      // 覆蓋舊資料，指定 key
      await docRef.set({
        "answers": {
          "Sleep2Widget": {
            "data": formattedAnswers,
            "timestamp": Timestamp.now(),
          }
        }
      }, SetOptions(merge: true));

      logger.i("✅ Sleep2Widget 資料已成功儲存並覆蓋舊檔案！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存 Sleep2Widget 資料時發生錯誤：$e");
      return false;
    }
  }
}
