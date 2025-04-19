//母乳哺餵知識量表
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger(); 

class KnowledgeWidget extends StatefulWidget {
  final String userId; // ✅ 接收 userId
  const KnowledgeWidget({super.key, required this.userId});

  @override
  State<KnowledgeWidget> createState() => _KnowledgeWidgetState();
}

class _KnowledgeWidgetState extends State<KnowledgeWidget> {
  final List<String> questions = [
    "產後所分泌的初乳，無論量多量少都能增加嬰兒的免疫力",
    "母親乳房的大小會影響乳汁分泌的多寡",
    "母親過度疲倦、緊張、心情不好會使乳汁分泌減少",
    "母親的水分攝取不足會使乳汁減少，只要飲用大量的水就能使乳汁分泌持續增加",
    "產後初期母親應該訂定餵奶時間表，幫助嬰兒於固定的時間吸奶",
    "為促進乳汁的分泌，每次餵奶前都要做乳房的熱敷與按摩",
    "哺餵母乳時當嬰兒只含住乳頭，母親需重新調整姿勢，盡量讓嬰兒含住全部或部分乳暈",
    "為了幫助嬰兒成功含乳，母親可以手掌支托乳房，支托乳房的手指應遠離乳暈",
    "餵奶前後，母親不須用肥皂以及清水清洗乳頭",
    "即使母親的乳頭是平的或凹陷的，嬰兒還是可以吃到足夠的母乳",
    "產後初期當母親乳汁還沒來之前，嬰兒還是可以吃到足夠的母乳",
    "當母親感到乳頭有受傷或輕微破皮時，可以在哺餵完母乳後擠一些乳汁塗抹乳頭",
    "哺餵母乳時嬰兒嗜睡或哭鬧是母親乳汁不夠的徵象",
    "為避免嬰兒呼吸不順暢，哺餵母乳時母親需要用手指壓住嬰兒鼻子附近的乳房部位",
    "乳汁的分泌量主要是受到嬰兒的吸吮次數與吸吮時間所影響，當嬰兒吸吮次數越多、吸吮時間越久，母親的乳汁分泌量也會越多",
    "當母親感覺脹奶時，多讓嬰兒吸吮乳房是最佳的處理方式",
    "嬰兒生病的時候，為了讓嬰兒獲得適當的休息，母親應該暫停哺餵母乳",
    "當嬰兒體力較差或吸吮力弱，母親可以在嬰兒吸吮時同時用支托乳房的手擠乳協助",
    "產後初期混合哺餵配方奶，母親的乳汁分泌量會受到影響",
    "產後初期混合哺餵配方奶，會讓嬰兒在學習直接吸吮母親乳房時，需要花長一點的時間適應",
    "當哺餵母乳時嬰兒嗜睡，母親可以試著鬆開包巾或輕搓嬰兒四肢或耳朵",
    "沒有到病嬰室(嬰兒隔離病房)親餵嬰兒時，母親也需要規律地擠出乳汁",
    "擠乳時母親的手放在乳暈的位置，往乳頭方向來回擠壓",
    "嬰兒已經吃過的那瓶奶水，應該於當餐吃完，沒有吃完的話就需要丟掉",
    "產後初期乳汁未大量分泌前，母親應進行親自哺餵或擠奶，一天至少每三小時一次，每次至少十五分鐘",
  ];

  // 紀錄每題的作答
  final Map<int, String?> answers = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1), //頁面背景顏色
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "母乳哺餵知識量表",
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
                        _buildHeaderCell("正確"),
                        _buildHeaderCell("錯誤"),
                        _buildHeaderCell("不知道"),
                      ],
                    ),
                    // 題目列
                    for (int i = 0; i < questions.length; i++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: answers[i] != null
                              ? const Color.fromARGB(255, 241, 215, 237) // 已回答時
                              : const Color.fromRGBO(233, 227, 213, 1), // 未回答時
                        ),
                        children: [
                          Text(
                            "${i + 1}. ${questions[i]}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          _buildRadio(i, "正確"),
                          _buildRadio(i, "錯誤"),
                          _buildRadio(i, "不知道"),
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
                // 下一步按鈕（所有問題都回答後才會顯示）
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
                      if (!context.mounted) return;

                      if (success) {
                        // 成功後跳轉到 /FinishWidget，或可改成 pop 回到上一頁
                        Navigator.pushNamed(
                          context,
                          '/FinishWidget',
                          arguments: widget.userId,
                        );
                      }
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

  Widget _buildHeaderCell(String label) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

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

  /// 儲存問卷答案，並將 knowledgeCompleted 設為 true
  Future<bool> _saveAnswersToFirebase() async {
    try {
      final String documentName = "KnowledgeWidget";

      // 先整理答案，key 用題號，value 用選項
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

      // 2. 將 knowledgeCompleted 設為 true，讓主頁能亮燈
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .update({"knowledgeCompleted": true});

      logger.i("✅ 問卷已成功儲存，並更新 knowledgeCompleted！");
   await sendKnowledgeAnswersToMySQL(widget.userId, answers);
      return true;
    } catch (e) {
      logger.e("❌ 儲存問卷時發生錯誤：$e");
      return false;
    }
  }

 Future<void> sendKnowledgeAnswersToMySQL(String userId, Map<int, String?> answers) async {
  final url = Uri.parse('http://163.13.201.85:3000/knowledge');

  final answerMap = {
    "正確": "true",
    "錯誤": "false",
    "不知道": "none",
  };

  final Map<String, dynamic> payload = {
    "user_id": int.parse(userId),
    "knowledge_question_content": "哺乳衛教問卷",
    "knowledge_test_date": DateTime.now().toIso8601String().split('T')[0],

  };

  // 把回答依序對應到欄位 knowledge_answer_1 ~ _25
  for (int i = 0; i < 25; i++) {
  final selected = answers[i]; // 取出使用者回答
  final mapped = answerMap[selected] ?? "none"; // 對應成 "true" / "false" / "none"
  payload["knowledge_answer_${i + 1}"] = mapped;
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
