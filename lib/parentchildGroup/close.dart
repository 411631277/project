//1.親近
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class CloseWidget extends StatefulWidget {
  final String userId;
  const CloseWidget({super.key, required this.userId});

  @override
  State<CloseWidget> createState() => _CloseWidgetState();
}

class _CloseWidgetState extends State<CloseWidget> {
  final List<String> questions = [
    "看到孩子，我就會覺得心情好",
    "我喜歡陪伴著孩子",
    "和孩子在一起是一種享受",
    "我喜歡抱著孩子的感覺",
    "孩子加入我的生活，讓我感到幸福",
    "陪在孩子身邊，讓我感到滿足",
    "我喜歡欣賞孩子的表情或動作",
  ];

  /// 每題對應的選項
  final Map<int, List<String>> questionOptions = {
    0: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    1: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    2: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    3: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    4: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    5: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],
    6: ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"],

  };

  /// 紀錄每題選擇的答案
  final Map<int, String?> close = {};

  /// 檢查是否所有題目都已作答
  bool _isAllQuestionsAnswered() {
    return close.length == questions.length && !close.containsValue(null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth * 0.045; // 自適應字體大小

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Text(
              '1.親近',
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
                  return _buildQuestionRow(index, screenWidth, fontSize);
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
                  onTap: () => Navigator.pop(context),
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
        vertical:   screenHeight * 0.015,
      ),
      backgroundColor: Colors.brown.shade400,
    ),
    onPressed: () async {
      // 1. 計算總分
      int totalScore = _calculateTotalScore();
     final args = {
    'userId': widget.userId,
     'totalScore': totalScore,
     };
      // 2. 儲存到 Firestore
      await _savecloseAndScore(totalScore);

      // 3. 導頁
      if (!context.mounted) return;
      Navigator.pushNamed(
        context,
        '/Closescore',
        arguments: args,
      );
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
    );
  }

  /// 建立單題的選項 UI
  Widget _buildQuestionRow(int questionIndex, double screenWidth, double fontSize) {
    List<String> options =
        questionOptions[questionIndex] ?? ["非常不同意", "不同意", "有點不同意", "有點同意", "同意", "非常同意"];

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
                  groupValue: close[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      close[questionIndex] = value!;
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
 Future<bool> _savecloseAndScore(int totalScore) async {
  try {
    final String documentName = "AttachmentWidget";

    final Map<String, String> formattedclose = close.map(
      (k, v) => MapEntry(k.toString(), v!),
    );

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("questions")
        .doc(documentName);

    // 先取得舊資料
    final docSnapshot = await docRef.get();
    Map<String, dynamic> existingData = {};

    if (docSnapshot.exists) {
      existingData = docSnapshot.data() ?? {};
    }

    // 把新的 close 加進去，不覆蓋其他資料
    existingData['close'] = formattedclose;
    existingData['closeTotalScore'] = totalScore;
    existingData['timestamp'] = Timestamp.now();

    await docRef.set(existingData);

    // 更新 attachmentCompleted
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .update({"attachmentCompleted": true});

    logger.i("✅ close問卷已成功合併並儲存！");
    return true;
  } catch (e) {
    logger.e("❌ 儲存close問卷時發生錯誤：$e");
    return false;
  }
}

/// 1〜6 分對應陣列索引 +1，計算所有題目的總分
int _calculateTotalScore() {
  return close.entries.map((entry) {
    // 找到該題答案在 options 陣列的索引，再＋1 成為分數
    final score = questionOptions[entry.key]!
                    .indexOf(entry.value!) + 1;
    return score;
  }).fold(0, (acc, element) => acc + element);
}

}
