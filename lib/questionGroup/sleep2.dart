//睡眠評估2
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math' as math;

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

  // 紀錄使用者的回答 (key: 題目索引, value: 選擇的答案)
  final Map<int, String?> answers = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  border: const TableBorder.symmetric(
                    inside: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  children: [
                    // 表頭
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(233, 227, 213, 1),
                      ),
                      children: [
                        SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "題目",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        _buildHeaderCell("從未發生"),
                        _buildHeaderCell("約一兩次"),
                        _buildHeaderCell("三次或以上"),
                      ],
                    ),
                    // 題目列
                    for (int i = 0; i < questions.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: answers[i] != null
                              ? const Color.fromARGB(255, 241, 215, 237) // 已回答時
                              : const Color.fromRGBO(233, 227, 213, 1),       // 未回答時
                        ),
                        children: [
                          Text("${i + 1}. ${questions[i]}",
                              style: const TextStyle(fontSize: 14)),
                          _buildRadioCell(i, "從未發生"),
                          _buildRadioCell(i, "約一兩次"),
                          _buildRadioCell(i, "三次或以上"),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 按鈕區域
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 返回按鈕
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Image.asset(
                      'assets/images/back.png',
                      width: screenWidth * 0.15,
                    ),
                  ),
                ),

                // 下一步按鈕（所有題目都回答後才會顯示）
                if (answers.length == questions.length)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: () async {
                      final success = await _saveAnswersToFirebase();
                      if (!context.mounted || !success) return;

                      // 跳轉到結束頁面 (或自行改為 pop 回到上一頁)
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 建立表頭的儲存格
  Widget _buildHeaderCell(String label) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  // 建立單題的選項儲存格
  Widget _buildRadioCell(int index, String value) {
    return Center(
      child: Radio<String>(
        value: value,
        groupValue: answers[index],
        onChanged: (selectedValue) {
          setState(() {
            answers[index] = selectedValue;
          });
        },
      ),
    );
  }

  /// 儲存使用者作答到 Firebase，並更新 sleepCompleted = true
  Future<bool> _saveAnswersToFirebase() async {
    try {
      final Map<String, String?> formattedAnswers = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      // 1. 將新答案合併到同一份 SleepWidget 文件下
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc("SleepWidget");

      // 2. 合併寫入 "Sleep2Widget" 的資料
      await docRef.set({
        "answers": {
          "Sleep2Widget": {
            "data": formattedAnswers,
            "timestamp": Timestamp.now(),
          }
        }
      }, SetOptions(merge: true));

      // 3. 更新 sleepCompleted = true，讓主問卷列表顯示已完成
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .update({"sleepCompleted": true});

      logger.i("✅ Sleep2Widget 資料已成功儲存並更新 sleepCompleted！");
      await sendSleep2AnswersToMySQL(widget.userId, answers);

      return true;
    } catch (e) {
      logger.e("❌ 儲存 Sleep2Widget 資料時發生錯誤：$e");
      return false;
    }
  }
 Future<void> sendSleep2AnswersToMySQL(String userId, Map<int, String?> answers) async {
  final url = Uri.parse('http://163.13.201.85:3000/sleep2');

  // 先宣告 payload（給整個 function 都能使用）
  Map<String, dynamic> payload = {};

  try {
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    payload = {
      'user_id': int.parse(userId),
      'sleep_question_content': "睡眠品質量表",
      'sleep_test_date': formattedDate,
    };

    for (int i = 0; i < 19; i++) {
      final answer = answers[i] ?? 'none';
      payload['sleep_answer_${i + 1}'] = answer;
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      logger.i("✅ Sleep2 資料同步成功：${result['message']} (insertId: ${result['insertId']})");
    } else {
      throw Exception("❌ Sleep2 資料同步失敗：${response.body}");
    }

  } catch (e) {
    logger.e("❌ 發送 Sleep2 資料到 MySQL 時錯誤：$e");
    logger.i("🟨 payload：$payload"); // ✅ 這裡就可以用了
  }
}


}

