import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_question/finish.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger(); // ✅ 確保 Logger 存在

class StopWidget extends StatefulWidget {
  final String userId; // ✅ 接收 userId
  const StopWidget({super.key, required this.userId});

  @override
  State<StopWidget> createState() => _StopWidgetState();
}

class _StopWidgetState extends State<StopWidget> {
  late TextEditingController reasonController;

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.20,
              child: Text(
                '停止哺餵母乳的原因',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: '請輸入原因',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),
            Positioned(
              top: screenHeight * 0.7,
              left: screenWidth * 0.3,
              child: SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (widget.userId.isEmpty) {
                      logger.e("❌ userId 為空，無法更新 Firestore！");
                      return;
                    }

                    final reason = reasonController.text.trim();
                    if (reason.isEmpty) {
                      logger.e("❌ 停止哺乳原因為空，請輸入後再繼續！");
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userId)
                          .update({
                        "停止哺乳原因": reason,
                      });

                      await sendStopReasonToMySQL(widget.userId, reason);
                      logger.i(
                          "✅ Firestore 更新成功，userId: ${widget.userId} -> 停止哺乳原因: $reason");

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FinishWidget(userId: widget.userId),
                          ),
                        );
                      }
                    } catch (e) {
                      logger.e("❌ Firestore 更新失敗: $e");
                    }
                  },
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendStopReasonToMySQL(String userId, String reason) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        'breastfeeding_stop_reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 停止哺乳原因同步 MySQL 成功");
    } else {
      logger.e("❌ 停止哺乳原因同步失敗: ${response.body}");
    }
  }
}
