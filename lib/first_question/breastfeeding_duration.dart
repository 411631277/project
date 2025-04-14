import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_question/stop.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger(); // ✅ 確保 Logger 存在

class BreastfeedingDurationWidget extends StatefulWidget {
  final String userId; // ✅ 接收 userId
  const BreastfeedingDurationWidget({super.key, required this.userId});

  @override
  State<BreastfeedingDurationWidget> createState() =>
      _BreastfeedingDurationWidgetState();
}

class _BreastfeedingDurationWidgetState
    extends State<BreastfeedingDurationWidget> {
  String? selectedDuration;
  bool isUpdating = false; // 🔹 避免多次點擊

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
              left: screenWidth * 0.25,
              child: Text(
                '前胎哺乳持續時長?',
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
                  value: selectedDuration,
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
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value;
                    });
                  },
                ),
              ),
            ),

            // **「下一步」按鈕**
            Positioned(
              top: screenHeight * 0.7,
              left: screenWidth * 0.3,
              child: SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDuration != null
                        ? Colors.white
                        : Colors.grey.shade400, // 🔹 若未選擇則變灰色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: selectedDuration == null || isUpdating
                      ? null // 🔹 若未選擇時長則禁用按鈕
                      : () async {
                          if (widget.userId.isEmpty) {
                            logger.e("❌ userId 為空，無法更新 Firestore！");
                            return;
                          }

                          setState(() => isUpdating = true); // 🔹 避免多次點擊

                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userId)
                                .update({
                              "前胎哺乳持續時長": "$selectedDuration 個月",
                            });
                            await sendBreastfeedingToMySQL(
                                widget.userId, "$selectedDuration 個月");
                            logger.i(
                                "✅ Firestore 更新成功，userId: ${widget.userId} -> 前胎哺乳時長: $selectedDuration");

                            if (!context.mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StopWidget(userId: widget.userId),
                              ),
                            );
                          } catch (e) {
                            logger.e("❌ Firestore 更新失敗: $e");
                          } finally {
                            setState(() => isUpdating = false);
                          }
                        },
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'Inter',
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

  Future<void> sendBreastfeedingToMySQL(
      String userId, String selectedDuration) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        'previous_breastfeeding_duration_months':  int.parse(selectedDuration.replaceAll('個月', '')),
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 哺乳時長同步到 MySQL 成功");
    } else {
      logger.e("❌ 哺乳時長同步 MySQL 失敗: ${response.body}");
    }
  }
}
