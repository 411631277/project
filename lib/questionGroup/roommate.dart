//親子同室情況
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Logger logger = Logger();

class RoommateWidget extends StatefulWidget {
  final String userId; // 傳入的 userId
  const RoommateWidget({super.key, required this.userId});

  @override
  State<RoommateWidget> createState() => _RoommateWidgetState();
}

class _RoommateWidgetState extends State<RoommateWidget> {
  bool? isRoomingIn24Hours;         // 24小時同室 (null=未選, true=是, false=否)
  bool? isLivingInPostpartumCenter; // 住月子中心 (null=未選, true=是, false=否)

  bool get _isAllAnswered =>
      isRoomingIn24Hours != null && isLivingInPostpartumCenter != null;

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenWidth * 0.045; // 自適應字體大小

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.08),
            Text(
              "親子同室情況",
              style: TextStyle(
                fontSize: fontSize * 1.2,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),

            // **24 小時同室選項**
            _buildQuestion(
              "截至目前為止是否有24小時同室",
              isRoomingIn24Hours,
              (value) {
                setState(() {
                  isRoomingIn24Hours = value;
                });
              },
              screenHeight * 0.1,
              screenWidth * 0.03,
              screenWidth * 0.2,
            ),
            SizedBox(height: screenHeight * 0.05),

            // **住月子中心選項**
            _buildQuestion(
              "產後是否有住在月子中心",
              isLivingInPostpartumCenter,
              (value) {
                setState(() {
                  isLivingInPostpartumCenter = value;
                });
              },
              screenHeight * 0.05,
              screenWidth * 0.03,
              screenWidth * 0.2,
            ),
            const Spacer(),

            // **按鈕區域**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // **返回按鈕**
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Image.asset(
                      'assets/images/back.png',
                      width: screenWidth * 0.15,
                    ),
                  ),
                ),

                // **填答完成按鈕 (所有問題填完才顯示)**
                if (_isAllAnswered)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical:   screenHeight * 0.015,
                      ),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: () async {
                      final success = await _saveAnswersToFirebase();
                      if (!context.mounted || !success) return;

                      // 跳轉到 FinishWidget，可自行更改
                     Navigator.pushNamed(
                    context,
                    '/FinishWidget',
                      arguments: {
                    'userId': widget.userId,
                    'isManUser': false, } 
                      );
                    },
                    child: Text(
                      "填答完成",
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  /// 建立問題的選項 (「是 / 否」)
  Widget _buildQuestion(
    String questionText,
    bool? selectedValue,
    Function(bool) onChanged,
    double textTopPadding,
    double checkboxLeftSpacing,
    double checkboxRightSpacing,
  ) {
    return Column(
      children: [
        // **問題標題**
        Padding(
          padding: EdgeInsets.only(top: textTopPadding),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ),
        ),
        // **選項區域**
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 「是」
              Row(
                children: [
                  SizedBox(width: checkboxLeftSpacing),
                  Checkbox(
                    value: selectedValue == true,
                    onChanged: (value) => onChanged(true),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "是",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(147, 129, 108, 1),
                    ),
                  ),
                ],
              ),
              // 「否」
              Row(
                children: [
                  SizedBox(width: checkboxRightSpacing),
                  Checkbox(
                    value: selectedValue == false,
                    onChanged: (value) => onChanged(false),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "否",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(147, 129, 108, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 儲存回答到 Firestore，並更新 roommateCompleted = true
  Future<bool> _saveAnswersToFirebase() async {
    try {
      // 1. 儲存問卷到子集合
      final CollectionReference userResponses = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection("questions");

      await userResponses.doc('roommate').set({
        '截至目前為止是否有24小時同室': isRoomingIn24Hours,
        '產後是否有住在月子中心': isLivingInPostpartumCenter,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. 更新 roommateCompleted = true
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({"roommateCompleted": true});

      logger.i("✅ Roommate 問卷已成功儲存，並更新 roommateCompleted！");
      await sendRoommateAnswersToMySQL(widget.userId);

      return true;
    } catch (e) {
      logger.e("❌ 儲存 Roommate 問卷時發生錯誤：$e");
      return false;
    }
  }
 Future<void> sendRoommateAnswersToMySQL(String userId) async {
  final url = Uri.parse('http://163.13.201.85:3000/roommate');

  final now = DateTime.now();
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': int.parse(userId),
      'roommate_question_content': "親子同室問卷",
      'roommate_test_date': formattedDate,
      'roommate_answer_1': isRoomingIn24Hours == true ? '是' : '否',
      'roommate_answer_2': isLivingInPostpartumCenter == true ? '是' : '否',
    }),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    logger.i("✅ 親子同室問卷已同步到 MySQL！");
  } else {
    logger.e("❌ 同步 MySQL 失敗: ${response.body}");
  }
}
}
