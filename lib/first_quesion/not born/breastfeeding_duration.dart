import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_quesion/stop.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(); // ✅ 確保 Logger 存在

class BreastfeedingDurationWidget extends StatelessWidget {
  final String userId; // ✅ 接收 userId
  const BreastfeedingDurationWidget({super.key, required this.userId});

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
              left: screenWidth * 0.1,
              child: Text(
                '前胎哺乳持續大概幾個月?',
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
              left: screenWidth * 0.2,
              child: SizedBox(
                width: screenWidth * 0.6,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: Text(
                    '選擇月份',
                    style: TextStyle(
                        fontSize: screenWidth * 0.04, color: Colors.grey),
                  ),
                  items: List.generate(13, (index) => index.toString())
                      .map((month) => DropdownMenuItem<String>(
                            value: month,
                            child: Text('$month 個月',
                                style: TextStyle(fontSize: screenWidth * 0.04)),
                          ))
                      .toList(),
                  onChanged: (value) async {
                    if (userId.isEmpty) {
                      logger.e("❌ userId 為空，無法更新 Firestore！");
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({
                        "前胎哺乳時長": value,
                      });

                      logger.i(
                          "✅ Firestore 更新成功，userId: $userId -> 前胎哺乳時長: $value");

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StopWidget(userId: userId),
                          ),
                        );
                      }
                    } catch (e) {
                      logger.e("❌ Firestore 更新失敗: $e");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
