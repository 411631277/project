//母乳哺餵知識量表
import 'dart:convert';
import 'package:doctor_2/questionGroup/knowledgeGroup/knowledge_score.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger(); 

class KnowledgeWidget extends StatefulWidget {
  final String userId; // ✅ 接收 userId
  final bool isManUser;
  const KnowledgeWidget({super.key, required this.userId , required this.isManUser});

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

    return PopScope(
    canPop: false, // ❗這行就是鎖定返回鍵
    child: Scaffold(
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
                              ? const Color.fromRGBO(233, 227, 213, 1) // 已回答時
                              : const Color.fromARGB(255, 226, 249, 254), // 未回答時
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
  final int totalScore = _calculateTotalScore();
  final success = await _saveAnswersToFirebase(totalScore);
  if (!context.mounted) return;

  if (success) {
    // 收集錯誤的題目
    List<Map<String, dynamic>> wrongAnswers = [];

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] != correctAnswers[i]) {
        wrongAnswers.add({
          'question': questions[i],
          'userAnswer': answers[i],
          'correctAnswer': correctAnswers[i],
        });
      }
    }

    // 導向新頁面並傳遞所有參數
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KnowledgeScore(
          wrongAnswers: wrongAnswers,
          userId: widget.userId,
          isManUser: widget.isManUser,
          totalScore: totalScore,
        ),
      ),
    );
  }else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('伺服器發生問題，請稍後再嘗試')),
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
    ));
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

// 正確答案表
final Map<int, String> correctAnswers = {
  0: "正確",
  1: "錯誤",
  2: "正確",
  3: "錯誤",
  4: "正確",
  5: "錯誤",
  6: "正確",
  7: "正確",
  8: "正確",
  9: "正確",
  10: "錯誤",
  11: "正確",
  12: "錯誤",
  13: "錯誤",
  14: "正確",
  15: "正確",
  16: "錯誤",
  17: "正確",
  18: "正確",
  19: "正確",
  20: "正確",
  21: "正確",
  22: "錯誤",
  23: "正確",
  24: "正確",
};


  /// 儲存問卷答案，並將 knowledgeCompleted 設為 true
 Future<bool> _saveAnswersToFirebase(int totalScore) async {
  final collectionName = widget.isManUser ? "Man_users" : "users";
  final String documentName = "KnowledgeWidget";

  try {
    // ⭐ 先送 MySQL
    final bool sqlOK = await sendKnowledgeAnswersToMySQL(widget.userId, answers, totalScore);
    if (!sqlOK) throw Exception('MySQL 同步失敗');

    // ⭐ 再寫 Firebase
    final Map<String, String?> formattedAnswers = answers.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId)
        .collection("questions")
        .doc(documentName)
        .set({
      "answers": formattedAnswers,
      "totalScore": totalScore,
      "timestamp": Timestamp.now(),
    });

    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId)
        .update({"knowledgeCompleted": true});

    logger.i("✅ 知識問卷已成功儲存，總分: $totalScore");
    return true;
  } catch (e) {
    logger.e("❌ 儲存問卷時發生錯誤：$e");
    return false;
  }
}



 Future<bool> sendKnowledgeAnswersToMySQL(String userId, Map<int, String?> answers, int totalScore) async {
  final url = Uri.parse('http://163.13.201.85:3000/knowledge');

  final answerMap = {
    "正確": 1,
    "錯誤": 0,
    "不知道": 2,
  };

  final String idKey = widget.isManUser ? 'man_user_id' : 'user_id';

  final Map<String, dynamic> payload = {
    idKey: int.parse(userId),
    "knowledge_question_content": "知識量表",
    "knowledge_test_date": DateTime.now().toIso8601String().split('T')[0],
    "knowledge_score": totalScore,
  };

  for (int i = 0; i < 25; i++) {
    final selected = answers[i];
    final mapped = answerMap[selected] ?? "no";
    payload["knowledge_answer_${i + 1}"] = mapped;
  }

  logger.i("📦 知識問卷送出 payload: $payload");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final result = jsonDecode(response.body);
      logger.i("✅ 知識問卷同步成功：${result['message']} (insertId: ${result['insertId']})");
      return true;  // ⭐️ 成功回傳 true
    } else {
      logger.e("❌ 知識問卷同步失敗：${response.body}");
      return false; // ⭐️ 失敗回傳 false
    }
  } catch (e) {
    logger.e("❌ 知識問卷發生例外錯誤：$e");
    return false; // ⭐️ 發生錯誤也回傳 false
  }
}



 int _calculateTotalScore() {
  int totalScore = 0;

  answers.forEach((index, userAnswer) {
    if (userAnswer != null && userAnswer != "不知道") { // 只要不是不知道才檢查
      // 該題是「正確」答案的話
      if (correctAnswers[index] == "正確" && userAnswer == "正確") {
        totalScore += 4;
      }
      // 該題是「錯誤」答案的話
      else if (!correctAnswers.containsKey(index) && userAnswer == "錯誤") {
        totalScore += 4;
      }
    }
  });

  return totalScore.clamp(0, 100);
}

}
