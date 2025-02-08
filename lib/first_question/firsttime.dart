import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_question/breastfeeding_duration.dart';
import 'package:doctor_2/first_question/finish.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class FirsttimeWidget extends StatefulWidget {
  final String userId;
  const FirsttimeWidget({super.key, required this.userId});

  @override
  State<FirsttimeWidget> createState() => _FirsttimeWidgetState();
}

class _FirsttimeWidgetState extends State<FirsttimeWidget> {
  String? firstTimeAnswer; // 存儲選擇的值

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // **問題標題**
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.3,
              child: Text(
                '是否為第一次生產',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // **選擇按鈕**
            Positioned(
              top: screenHeight * 0.33,
              left: screenWidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // **選擇「是」**
                  Checkbox(
                    value: firstTimeAnswer == 'yes',
                    onChanged: (bool? value) {
                      setState(() {
                        firstTimeAnswer = value! ? 'yes' : null;
                      });
                    },
                  ),
                  const Text(
                    '是',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.2), // 增加間距

                  // **選擇「否」**
                  Checkbox(
                    value: firstTimeAnswer == 'no',
                    onChanged: (bool? value) {
                      setState(() {
                        firstTimeAnswer = value! ? 'no' : null;
                      });
                    },
                  ),
                  const Text(
                    '否',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // **「下一步」按鈕**
            if (firstTimeAnswer != null)
              Positioned(
                top: screenHeight * 0.6,
                left: screenWidth * 0.3,
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await _handleSelection(context, firstTimeAnswer!);
                    },
                    child: const Text(
                      '下一步',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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

  /// **Firestore 更新 + 頁面跳轉**
  Future<void> _handleSelection(BuildContext context, String answer) async {
    if (widget.userId.isEmpty) {
      logger.e("❌ userId 為空，無法更新 Firestore！");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        "是否為第一次生產": answer,
      }, SetOptions(merge: true)); // 🔹 避免覆蓋舊資料

      logger.i("✅ Firestore 更新成功，userId: ${widget.userId} -> 是否第一次生產: $answer");

      if (!context.mounted) return;

      // **根據選擇進行跳轉**
      if (answer == 'yes') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinishWidget(userId: widget.userId),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BreastfeedingDurationWidget(userId: widget.userId),
          ),
        );
      }
    } catch (e) {
      logger.e("❌ Firestore 更新失敗: $e");
    }
  }
}
