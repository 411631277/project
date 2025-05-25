import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/first_question/first_breastfeeding.dart';
import 'package:doctor_2/first_question/notfirst.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger(); // 🔹 記錄 Firestore 變更

class NmFrequencyWidget extends StatefulWidget {
  final String userId;
  const NmFrequencyWidget({super.key, required this.userId});

  @override
  State<NmFrequencyWidget> createState() => _NmFrequencyWidgetState();
}

class _NmFrequencyWidgetState extends State<NmFrequencyWidget> {
  String? breastfeedingAnswer; // 存儲親自哺乳的回答
  String? pregnancyCount; // 懷孕次數


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isAllAnswered = pregnancyCount != null &&    
        breastfeedingAnswer != null;

    return PopScope(
    canPop: false,
    child: Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.33 + 5,
              child: const Text(
                '懷孕次數',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.40,
              left: screenWidth * 0.28,
              child: SizedBox(
                width: screenWidth * 0.4,
                child: DropdownButtonFormField<String>(
                  value: pregnancyCount,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: const Text('次數', style: TextStyle(color: Colors.grey)),
                  items: ['0', '1', '2', '3', '4']
                      .map((pregnantcount) => DropdownMenuItem<String>(
                            value: pregnantcount,
                            child: Text(pregnantcount),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      pregnancyCount = value;
                    });
                  },
                ),
              ),
            ),
        
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.25 + 5,
              child: const Text(
                '是否為首次哺乳?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.60,
              left: screenWidth * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.35,
                    child: RadioListTile<String>(
                      title: const Text('是'),
                      value: 'yes',
                      groupValue: breastfeedingAnswer,
                      onChanged: (value) {
                        setState(() {
                          breastfeedingAnswer = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.35,
                    child: RadioListTile<String>(
                      title: const Text('否'),
                      value: 'no',
                      groupValue: breastfeedingAnswer,
                      onChanged: (value) {
                        setState(() {
                          breastfeedingAnswer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isAllAnswered)
              Positioned(
                top: screenHeight * 0.8,
                left: screenWidth * 0.3,
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () async {
                      if (widget.userId.isEmpty) {
                        logger.e("❌ userId 為空，無法更新 Firestore！");
                        return;
                      }

                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .update({
                          "懷孕次數": pregnancyCount,
                          "首次哺乳": breastfeedingAnswer,
                        });
                        await sendFrequencyToMySQL(
                          widget.userId,
                          pregnancyCount!,
                          breastfeedingAnswer!,
                        );
                        logger.i("✅ Firestore 更新成功，userId: ${widget.userId}");

                        if (!context.mounted) return;
                        if (breastfeedingAnswer == 'yes') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstBreastfeedingWidget(
                                  userId: widget.userId),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NotfirstWidget(userId: widget.userId),
                            ),
                          );
                        }
                      } catch (e) {
                        logger.e("❌ Firestore 更新失敗: $e");
                      }
                    },
                    child: const Text("下一步"),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  Future<void> sendFrequencyToMySQL(String userId, String pregnancy,
       String breastfeeding) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        'pregnancy_count': pregnancy,
        'first_time_breastfeeding': breastfeeding == 'yes' ? '是' : '否',
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 懷孕、生產、首次哺乳資料同步 MySQL 成功");
    } else {
      logger.e("❌ 同步 MySQL 失敗: ${response.body}");
    }
  }
}
