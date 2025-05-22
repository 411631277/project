import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/first_question/finish.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger(); // 🔹 Firestore 更新記錄

class FirstBreastfeedingWidget extends StatefulWidget {
  final String userId;
  const FirstBreastfeedingWidget({super.key, required this.userId, });

  @override
  State<FirstBreastfeedingWidget> createState() =>
      _FirstBreastfeedingWidgetState();
}

class _FirstBreastfeedingWidgetState extends State<FirstBreastfeedingWidget> {
  String? selectedDuration; // 存儲選擇的哺乳時長

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
    canPop: false,
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
              top: screenHeight * 0.3,
              left: screenWidth * 0.20,
              child: const Text(
                '目前預期純哺乳哺餵時長為\n幾個月?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
                child: DropdownButtonFormField<String>(
                   isExpanded: true,
                  value: selectedDuration,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint:
                      const Text('選擇月份', style: TextStyle(color: Colors.grey)),
                  items: [
  DropdownMenuItem<String>(
    
    value: '未考慮',
    child: Text('目前還未考慮過'),
  ),
  DropdownMenuItem<String>(
    value: '純母乳',
    child: Text('前六個月純母乳哺餵'),
  ),
  DropdownMenuItem<String>(
    value: '混合哺餵',
    child: Text('前六個月配合使用配方奶'),
  ),
  DropdownMenuItem<String>(
    value: '不哺餵',
    child: Text('目前不打算餵母乳'),
  ),
  ...List.generate(25, (index) => index.toString())
      .map((month) => DropdownMenuItem<String>(
            value: month,
            child: Text('$month 個月'),
          ))  
],
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value;
                    });
                  },
                ),
              ),
            ),
            if (selectedDuration != null)
              Positioned(
                top: screenHeight * 0.75,
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

                      try {
                        String saveValue;
if (selectedDuration == '未考慮') {
  saveValue = '未考慮';
} else if (selectedDuration == '純母乳') {
  saveValue = '前六個月純母乳哺餵';
} else if (selectedDuration == '混合哺餵') {
  saveValue = '前六個月配合使用配方奶';
} else if (selectedDuration == '不哺餵') {
  saveValue = '目前不打算餵母乳';
} else {
  saveValue = "$selectedDuration 個月";
}

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .update({
                          "預期哺餵時長": saveValue,
                        });
                        await sendFirstBreastfeedingToMySQL(
                            widget.userId, saveValue);
                        logger.i(
                            "✅ Firestore 更新成功，userId: ${widget.userId}, breastfeedingDuration: $saveValue");

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FinishWidget(userId: widget.userId, isManUser: false,),
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

  Future<void> sendFirstBreastfeedingToMySQL(
      String userId, String duration) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');
     
    dynamic convertedValue;
  if (duration == '未考慮') {
    convertedValue = '目前還未考慮過';
  } else if (duration == '前六個月純母乳哺餵') {
    convertedValue = '前六個月純母乳哺餵';
  } else if (duration == '前六個月配合使用配方奶') {
    convertedValue = '前六個月配合使用配方奶';
  } else if (duration == '目前不打算餵母乳') {
    convertedValue = '目前不打算餵母乳';
  } else {
    convertedValue = int.parse(duration.replaceAll('個月', ''));
  }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        "expected_breastfeeding_months":
        convertedValue ,
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 預期哺乳時長同步 MySQL 成功");
    } else {
      logger.e("❌ 預期哺乳時長同步 MySQL 失敗: ${response.body}");
    }
  }
}
