import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_question/notyet.dart';
import 'package:doctor_2/first_question/yesyet.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger();

class BornWidget extends StatelessWidget {
  final String userId;

  const BornWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
    canPop: false, // ❗這行就是鎖定返回鍵
    child: Scaffold(
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
              left: screenWidth * 0.18,
              child: Text(
                '請問寶寶出生了嗎?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.27,
              child: SizedBox(
                width: screenWidth * 0.45,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () async {
                    if (userId.isEmpty) {
                      logger.e("❌ userId 為空，無法更新 Firestore！");
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({"寶寶出生": false});
                      await sendBabyBornToMySQL(userId, false);
                      if (!context.mounted) return;
                      logger.i(
                          "✅ Firestore 更新成功，userId: $userId -> babyBorn: 還沒");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notyet1Widget(userId: userId),
                        ),
                      );
                    } catch (e) {
                      logger.e("❌ Firestore 更新失敗: $e");
                    }
                  },
                  child: const Text("還沒"),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.5 + 15,
              left: screenWidth * 0.27,
              child: SizedBox(
                width: screenWidth * 0.45,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () async {
                    if (userId.isEmpty) {
                      logger.e("❌ userId 為空，無法更新 Firestore！");
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({"寶寶出生": true});
                      await sendBabyBornToMySQL(userId, true);
                      logger.i(
                          "✅ Firestore 更新成功，userId: $userId -> babyBorn: 出生了");

                      if (!context.mounted) return; // 🔹 確保 context 仍然有效

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YesyetWidget(userId: userId),
                        ),
                      );
                    } catch (e) {
                      logger.e("❌ Firestore 更新失敗: $e");
                    }
                  },
                  child: const Text("出生了"),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> sendBabyBornToMySQL(String userId, bool babyBorn) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        'baby_born': babyBorn ? '是' : '否',
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 寶寶出生狀態同步到 MySQL 成功");
    } else {
      logger.e("❌ 同步寶寶出生到 MySQL 失敗: ${response.body}");
    }
  }
}
