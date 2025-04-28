//生產支持知識量表(已移除)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

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

  // 紀錄每題的作答結果
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
                  columnWidths: const {
                    0: FlexColumnWidth(3),
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
                        color: Color.fromRGBO(240, 240, 240, 1),
                      ),
                      children: [
                        SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "問題",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        _buildHeaderCell("完全可以"),
                        _buildHeaderCell("偶爾可以"),
                        _buildHeaderCell("需要協助"),
                      ],
                    ),
                    // 題目列
                    for (int i = 0; i < questions.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: answers[i] != null
                              ? const Color.fromARGB(255, 241, 215, 237)
                              : const Color.fromRGBO(233, 227, 213, 1),
                        ),
                        children: [
                          Text(
                            "${i + 1}. ${questions[i]}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          _buildRadio(i, "完全可以"),
                          _buildRadio(i, "偶爾可以"),
                          _buildRadio(i, "需要協助"),
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
                    angle: math.pi, // 旋轉 180 度 (弧度制，180 度 = π 弧度)
                    child: Image.asset(
                      'assets/images/back.png',
                      width: screenWidth * 0.15,
                    ),
                  ),
                ),

                // 下一步按鈕（所有題目都回答後才顯示）
                if (answers.length == questions.length)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: () async {
                      final success = await _saveAnswersToFirebase();
                      if (!context.mounted || !success) return;

                      // 完成後跳轉 (可自行修改)
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

  /// 表頭的小工具
  Widget _buildHeaderCell(String label) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  /// 建立單題的選項 UI
  Widget _buildRadio(int index, String value) {
    return Center(
      child: Radio<String>(
        value: value,
        groupValue: answers[index],
        onChanged: (val) {
          setState(() {
            answers[index] = val;
          });
        },
      ),
    );
  }

  /// 儲存問卷並更新 produtionCompleted = true
  Future<bool> _saveAnswersToFirebase() async {
    try {
      // 在 QuestionWidget 中對應的 key 是 'produtionCompleted'
      final String documentName = "ProductionWidget";

      // 整理答案
      final Map<String, String?> formattedAnswers = answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      // 1. 儲存問卷到子集合
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc(documentName)
          .set({
        "answers": formattedAnswers,
        "timestamp": Timestamp.now(),
      });

      // 2. 更新 produtionCompleted = true
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .update({"produtionCompleted": true});

      logger.i("✅ 生產支持知覺量表問卷已成功儲存，並更新 produtionCompleted！");
     await sendProductionAnswersToMySQL(widget.userId, answers);

      return true;
    } catch (e) {
      logger.e("❌ 儲存問卷時發生錯誤：$e");
      return false;
    }
  }
 Future<void> sendProductionAnswersToMySQL(String userId, Map<int, String?> answers) async {
  final url = Uri.parse('http://163.13.201.85:3000/assessment'); // ✅ 你的 MySQL API 路徑

  // 當日日期格式
  final now = DateTime.now();
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  // 組裝傳送資料
  final Map<String, dynamic> payload = {
    'user_id': int.parse(userId),
    'assessment_question_content': '生產支持知覺量表',
    'assessment_test_date': formattedDate,
  };

  // 把 answers 依序加入 payload
  for (int i = 0; i < 19; i++) {
    final answer = answers[i] ?? '未填答';
    payload['assessment_answer_${i + 1}'] = answer;
  }

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

 if (response.statusCode >= 200 && response.statusCode < 300) {
  final result = jsonDecode(response.body);
  logger.i("✅ 生產支持問卷同步成功：${result['message']} (insertId: ${result['insertId']})");
} else {
  throw Exception("❌ 生產支持問卷同步失敗：${response.body}");
}

}


}
