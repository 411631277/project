import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_quesion/not%20born/notyet.dart';
import 'package:doctor_2/first_quesion/yes%20born/yesyet.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(); // 🔹 確保 Logger 存在

class BornWidget extends StatelessWidget {
  final String userId; // 🔹 接收 userId

  const BornWidget({super.key, required this.userId});

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
              left: screenWidth * 0.15,
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
                          .doc(userId) // ✅ 使用 userId 更新 Firestore
                          .update({"寶寶出生": false});

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

                      logger.i(
                          "✅ Firestore 更新成功，userId: $userId -> babyBorn: 出生了");

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
    );
  }
}
