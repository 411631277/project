import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class RoommateWidget extends StatefulWidget {
  final String userId; // 傳入的 userId
  const RoommateWidget({super.key, required this.userId});

  @override
  State<RoommateWidget> createState() => _RoommateWidgetState();
}

class _RoommateWidgetState extends State<RoommateWidget> {
  bool? isRoomingIn24Hours; // 24小時同室 (null = 未選擇, true = 是, false = 否)
  bool? isLivingInPostpartumCenter; // 住月子中心 (null = 未選擇, true = 是, false = 否)

  bool get _isAllAnswered =>
      isRoomingIn24Hours != null && isLivingInPostpartumCenter != null;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            _buildQuestion("截至目前為止是否有24小時同室", isRoomingIn24Hours, (value) {
              setState(() {
                isRoomingIn24Hours = value;
              });
            }, screenHeight * 0.1, screenWidth * 0.03, screenWidth * 0.2),

            SizedBox(height: screenHeight * 0.05),

            // **住月子中心選項**
            _buildQuestion("產後是否有住在月子中心", isLivingInPostpartumCenter, (value) {
              setState(() {
                isLivingInPostpartumCenter = value;
              });
            }, screenHeight * 0.05, screenWidth * 0.03, screenWidth * 0.2),

            const Spacer(),

            // **返回按鈕**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                          vertical: screenHeight * 0.015),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: () async {
                      await _saveAnswersToFirebase();
                      if (!context.mounted) return;
                      Navigator.pushNamed(
                        context,
                        '/FinishWidget',
                        arguments: widget.userId,
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

  // **建立問題的 Checkbox 選項（手動調整位置 & 自適應畫面）**
  Widget _buildQuestion(
    String questionText,
    bool? selectedValue,
    Function(bool) onChanged,
    double textTopPadding, // 🔹 調整文字垂直間距
    double checkboxLeftSpacing, // 🔹 調整勾選盒與「是」的間距
    double checkboxRightSpacing, // 🔹 調整勾選盒與「否」的間距
  ) {
    return Column(
      children: [
        // **問題標題（可調整上方間距）**
        Padding(
          padding: EdgeInsets.only(top: textTopPadding), // 🔹 文字間距
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
          padding: const EdgeInsets.only(top: 10), // 🔹 調整勾選框與標題的間距
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // **選項區塊置中**
            children: [
              // ✅ 選項 1: 是
              Row(
                children: [
                  SizedBox(width: checkboxLeftSpacing), // 🔹 調整「是」的勾選盒位置
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

              // ✅ 選項 2: 否
              Row(
                children: [
                  SizedBox(width: checkboxRightSpacing), // 🔹 調整「否」的勾選盒位置
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

  // **儲存回答到 Firebase**
  Future<void> _saveAnswersToFirebase() async {
    try {
      final CollectionReference userResponses = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection("questions");

      await userResponses.doc('roommate').set({
        '截至目前為止是否有24小時同室': isRoomingIn24Hours,
        '產後是否有住在月子中心': isLivingInPostpartumCenter,
        'timestamp': FieldValue.serverTimestamp(),
      });

      logger.i("✅ Roommate 問卷已成功儲存！");
    } catch (e) {
      logger.e("❌ 儲存 Roommate 問卷時發生錯誤：$e");
    }
  }
}
