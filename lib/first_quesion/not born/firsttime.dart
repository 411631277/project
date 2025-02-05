import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_quesion/finish.dart';
import 'package:doctor_2/first_quesion/not%20born/breastfeeding_duration.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(); // ✅ 確保 Logger 存在

class FirsttimeWidget extends StatelessWidget {
  final String userId; // ✅ 接收 userId
  const FirsttimeWidget({super.key, required this.userId});

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
                '是否為第一次生產?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _handleSelection(context, 'yes');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        '是',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: const Color.fromRGBO(147, 129, 108, 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // 增加間距
                    ElevatedButton(
                      onPressed: () async {
                        await _handleSelection(context, 'no');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        '否',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: const Color.fromRGBO(147, 129, 108, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **處理按鈕點擊 (Firestore 更新 + 頁面跳轉)**
  Future<void> _handleSelection(BuildContext context, String answer) async {
    if (userId.isEmpty) {
      logger.e("❌ userId 為空，無法更新 Firestore！");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        "是否為第一次生產": answer,
      });

      logger.i("✅ Firestore 更新成功，userId: $userId -> 是否第一次生產: $answer");

      if (context.mounted) {
        if (answer == 'yes') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinishWidget(userId: userId),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BreastfeedingDurationWidget(userId: userId),
            ),
          );
        }
      }
    } catch (e) {
      logger.e("❌ Firestore 更新失敗: $e");
    }
  }
}
