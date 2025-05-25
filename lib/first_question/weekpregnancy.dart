import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger();

class WeekPregnancy extends StatefulWidget {
  final String userId;
  final bool isNewMom ;
  const WeekPregnancy({super.key, required this.userId, required this.isNewMom});

  @override
  WeekPregnancyState createState() => WeekPregnancyState();
}

class WeekPregnancyState extends State<WeekPregnancy> {
  final List<int> weeks = List.generate(40, (index) => index + 1);
  final List<int> days = List.generate(7, (index) => index + 1);

  int? selectedWeek;
  int? selectedDay;
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  bool get isFormComplete =>
      selectedWeek != null &&
      selectedDay != null &&
      yearController.text.isNotEmpty &&
      monthController.text.isNotEmpty &&
      dayController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFECE2C6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('目前的懷孕週數',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.brown)),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    hint: const Text('週'),
                    value: selectedWeek,
                    items: weeks.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value 週'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedWeek = newValue;
                      });
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  DropdownButton<int>(
                    hint: const Text('天'),
                    value: selectedDay,
                    items: days.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value 天'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDay = newValue;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Text('當下預產期',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.brown)),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberField(yearController, '年', screenWidth, 3),
                  _buildNumberField(monthController, '月', screenWidth, 2),
                  _buildNumberField(dayController, '日', screenWidth, 2),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              if (isFormComplete)
                ElevatedButton(
                  onPressed: () async {
                    await _sendWeekDataToFirebase();
                    await _sendWeekDataToMySQL();
                    if (!context.mounted) return;
                    Navigator.pushNamed(
  context,
  '/Notyet1Widget',
   arguments: {
    'userId': widget.userId,
    'isNewMom': widget.isNewMom,
  },
);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: Text('下一步',
                      style: TextStyle(
                          fontSize: screenWidth * 0.045, color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String hint,
      double screenWidth, int maxLength) {
    return Container(
      width: screenWidth * 0.20,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ],
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Text(hint, style: TextStyle(color: Colors.brown, fontSize: 22)),
        ],
      ),
    );
  }

  Future<void> _sendWeekDataToFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        "懷孕週數": "$selectedWeek 週 $selectedDay 天",
        "預產期":
            "${yearController.text}年${monthController.text}月${dayController.text}日",
      }, SetOptions(merge: true));
      logger.i("✅ Firebase 懷孕週數更新成功");
    } catch (e) {
      logger.e("❌ Firebase 更新失敗: $e");
    }
  }

  Future<void> _sendWeekDataToMySQL() async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');
    logger.i("📡 正在傳送 MySQL 資料到 $url");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(widget.userId),
        'pregnancy_week': "$selectedWeek 週 $selectedDay 天",
        'due_date':
            "${yearController.text}-${monthController.text}-${dayController.text}",
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 懷孕週數同步 MySQL 成功");
    } else {
      logger.e("❌ 懷孕週數同步 MySQL 失敗: ${response.statusCode} - ${response.body}");
    }
  }
}
