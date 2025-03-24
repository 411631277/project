import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger =
    Logger(); //, required String userId, required String userId ✅ 確保 Logger 存在

class AttachmentWidget extends StatefulWidget {
  final String userId; // ✅ 接收 userId
  const AttachmentWidget({super.key, required this.userId});

  @override
  State<AttachmentWidget> createState() => _AttachmentWidget();
}

class _AttachmentWidget extends State<AttachmentWidget> {
  final List<String> questions = [
    "看到孩子，我就會覺得心情好",
    "我喜歡陪伴著孩子",
    "和孩子在一起是一種享受",
    "我喜歡抱著孩子的感覺",
    "孩子加入我的生活，讓我感到幸福",
    "陪在孩子身邊，讓我感到滿足",
    "我喜歡欣賞孩子的表情或動作",
    "我在照顧孩子的時候，會感到不耐煩",
    "時時要滿足孩子的需求，讓我感到沮喪",
    "如果孩子干擾到我的休息，我會感到討厭",
    "我覺得自己像是個照顧孩子的機器",
    "照顧孩子讓我感到筋疲力盡",
    "我會對孩子生氣",
    "我要保留自己的最佳精力給孩子",
    "我看重孩子的需求甚過自己的",
    "如果孩子受苦，我願意替他承受",
    "即使我有其他重要事情，我還是以照顧孩子爲第一",
    "我願意因爲孩子而減少自己的自由",
    "對我而言，孩子是世界上最重要的",
    "我能察覺孩子「想睡覺」的訊號",
    "我會由孩子的表情或動作，來猜測他的需求",
    "我知道孩子的需求和情緒",
    "我能有效地安撫孩子",
    "我會依照孩子的反應，來調整照顧他的方式",
    "我對照顧孩子的方式有信心",
  ];

  final Map<int, String?> answers = {};
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            color: const Color.fromRGBO(233, 227, 213, 1),
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                "親子依附量表",
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
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    border: TableBorder.symmetric(
                      inside:
                          BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(240, 240, 240, 1),
                        ),
                        children: [
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.topCenter, // 文字置中靠上
                                child: const Text(
                                  "問題",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("非常認同",
                                    style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child:
                                    Text("認同", style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("不認同",
                                    style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("很不認同",
                                    style: TextStyle(fontSize: 12))),
                          ),
                        ],
                      ),
                      for (int i = 0; i < questions.length; i++)
                        TableRow(
                          decoration: BoxDecoration(
      color: answers[i] != null
          ? const Color.fromARGB(255, 241, 215, 237) // 已回答時
          :  Color.fromRGBO(233, 227, 213, 1)  ,          // 未回答時
    ),
                          children: [
                            Text("${i + 1}. ${questions[i]}",
                                style: const TextStyle(fontSize: 14)),
                            Center(
                              child: Radio<String>(
                                value: "非常認同",
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
                                value: "認同",
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
                                value: "不認同",
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
                                value: "很不認同",
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
                // 返回按鈕
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.rotate(
                    angle: math.pi, // 旋轉 180 度 (弧度制，180 度 = π 弧度)
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
                        '/FinishWidget',
                        arguments: widget.userId,
                      );
                    },
                    child: const Text(
                      "填答完成",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
              ]),
            ])));
  }


  Future<bool> _saveAnswersToFirebase() async {
  try {
    final String documentName = "AttachmentWidget";

    final Map<String, String?> formattedAnswers = answers.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    // 1. 儲存問卷答案到 users/{userId}/questions/{documentName}
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("questions")
        .doc(documentName)
        .set({
      "answers": formattedAnswers,
      "timestamp": Timestamp.now(),
    });

    // 2. 在同一個 function 中，更新 attachmentCompleted = true
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .update({"attachmentCompleted": true});

    logger.i("✅ 問卷已成功儲存，並更新 attachmentCompleted！");

    return true;
  } catch (e) {
    logger.e("❌ 儲存問卷時發生錯誤：$e");
    return false;
  }
}
}
