import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/first_question/finish.dart';

final Logger logger = Logger(); // 🔹 Firestore 更新記錄

class FirstBreastfeedingWidget extends StatefulWidget {
  final String userId;
  const FirstBreastfeedingWidget({super.key, required this.userId});

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
                  items: List.generate(13, (index) => index.toString())
                      .map((month) => DropdownMenuItem<String>(
                            value: month,
                            child: Text('$month 個月'),
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
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .update({
                          "預期哺餵時長": "$selectedDuration 個月",
                        });

                        logger.i(
                            "✅ Firestore 更新成功，userId: ${widget.userId}, breastfeedingDuration: $selectedDuration");

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FinishWidget(userId: widget.userId),
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
    );
  }
}
