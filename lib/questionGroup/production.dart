import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger =
    Logger(); //, required String userId, required String userId ✅ 確保 Logger 存在

class ProdutionWidget extends StatefulWidget {
  final String userId; // ✅ 接收 userId
  const ProdutionWidget({super.key, required this.userId});

  @override
  State<ProdutionWidget> createState() => _ProdutionWidget();
}

class _ProdutionWidget extends State<ProdutionWidget> {
  final List<String> questions = [
    "我不用自己獨自一個人照顧孩子",
    "我哄孩子的時候可以得到直接的幫助",
    "我有幫我做家務的人",
    "我在給孩子更換衣物的時候可以得到直接的幫助",
    "我給孩子洗澡的時候可以得到直接的幫助",
    "我可以在哺乳孩子的時候得到直接的幫助",
    "我可以獲得關於產後調理的相關信息（比如身體的管理）",
    "我可以獲得有關育兒的一致信息",
    "我可以獲得有關嬰兒沐浴的相關信息",
    "我可以獲得哺乳的相關信息",
    "我可以獲得哄孩子的相關信息",
    "我可以獲得給孩子更換衣服的相關信息",
    "有人向我表達謝意",
    "我有可以傾訴情緒/感受的人",
    "我身邊的人都能理解我需要幫助是理所當然的",
    "我有照顧和安慰我的人",
    "我需要建議的時候，有可以給我提供幫助的人",
    "即使我做的不好也有可以依賴的人",
    "我有可以與之交談和分享經驗的人",
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
                "生產支持知覺量表",
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
                                child: Text("完全可以",
                                    style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("偶爾可以",
                                    style: TextStyle(fontSize: 12))),
                          ),
                          SizedBox(
                            height: 40, // 確保高度一致
                            child: const Center(
                                child: Text("需要協助",
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
                                value: "完全可以",
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
                                value: "偶爾可以",
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
                                value: "需要協助",
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
                      "下一步",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
              ]),
            ])));
  }

  Future<bool> _saveAnswersToFirebase() async {
    try {
      final String documentName = "ProductionWidget";

      final Map<String, String?> formattedAnswers = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc(documentName)
          .set({
        "answers": formattedAnswers,
        "timestamp": Timestamp.now(),
      });

      logger.i("✅ 問卷已成功儲存！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存問卷時發生錯誤：$e");
      return false;
    }
  }
}
