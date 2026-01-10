import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/services/backend3000/backend3000.dart';

final Logger logger = Logger();

class PregnancyDate extends StatefulWidget {
  final String userId;
  const PregnancyDate({super.key, required this.userId});

  @override
  PregnancyDateState createState() => PregnancyDateState();
}

class PregnancyDateState extends State<PregnancyDate> {
  TextEditingController newYearController = TextEditingController();
  TextEditingController newMonthController = TextEditingController();
  TextEditingController newDayController = TextEditingController();

  TextEditingController originalYearController = TextEditingController();
  TextEditingController originalMonthController = TextEditingController();
  TextEditingController originalDayController = TextEditingController();

  bool get isFormComplete =>
      newYearController.text.isNotEmpty &&
      newMonthController.text.isNotEmpty &&
      newDayController.text.isNotEmpty &&
      originalYearController.text.isNotEmpty &&
      originalMonthController.text.isNotEmpty &&
      originalDayController.text.isNotEmpty;

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
              Text('新增生產日期',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.brown)),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberField(newYearController, '年', screenWidth, 3),
                  _buildNumberField(newMonthController, '月', screenWidth, 2),
                  _buildNumberField(newDayController, '日', screenWidth, 2),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Text('原本預產期',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.brown)),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberField(
                      originalYearController, '年', screenWidth, 3),
                  _buildNumberField(
                      originalMonthController, '月', screenWidth, 2),
                  _buildNumberField(originalDayController, '日', screenWidth, 2),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              if (isFormComplete)
                ElevatedButton(
                  onPressed: () async {
                    await _sendWeekDataToFirebase();
                    await _sendWeekDataToMySQL();
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/YesyetWidget' ,arguments: widget.userId,);
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
        "新增生產日期":
            "${newYearController.text}年${newMonthController.text}月${newDayController.text}日",
        "原本預產期":
            "${originalYearController.text}年${originalMonthController.text}月${originalDayController.text}日",
      }, SetOptions(merge: true));
      logger.i("✅ Firebase 懷孕資料更新成功");
    } catch (e) {
      logger.e("❌ Firebase 更新失敗: $e");
    }
  }

  Future<void> _sendWeekDataToMySQL() async {
  try {
    await Backend3000.userQuestionApi.updateUserQuestion(
      userId: int.parse(widget.userId),
      fields: {
        // ⚠️ 日期格式完全沿用你原本組字串方式
        'production_date':
            "${newYearController.text}-${newMonthController.text}-${newDayController.text}",
        'original_due_date':
            "${originalYearController.text}-${originalMonthController.text}-${originalDayController.text}",
      },
    );

    logger.i("✅ 懷孕資料同步 MySQL 成功");
  } catch (e, stack) {
    logger.e("❌ 懷孕資料同步 MySQL 失敗", error: e, stackTrace: stack);
  }
}

}
