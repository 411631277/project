import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/first_quesion/not%20born/frequency.dart';
import 'package:doctor_2/first_quesion/not%20born/firsttime.dart';

final Logger logger = Logger(); // 🔹 確保 Logger 存在

class Notyet1Widget extends StatefulWidget {
  final String userId; // 🔹 接收 userId
  const Notyet1Widget({super.key, required this.userId});

  @override
  State<Notyet1Widget> createState() => _Notyet1WidgetState();
}

class _Notyet1WidgetState extends State<Notyet1Widget> {
  String? breastfeedingAnswer; // 存儲親自哺乳的回答
  String? complicationAnswer; // 存儲妊娠合併症的回答
  String? selectedBabyCount; // 存儲肚子裡寶寶的數量

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isAllAnswered = breastfeedingAnswer != null &&
        complicationAnswer != null &&
        selectedBabyCount != null;

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
                '肚子裡有幾個寶寶?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
                child: DropdownButtonFormField<String>(
                  value: selectedBabyCount,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: const Text(
                    '選擇數量',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((count) => DropdownMenuItem<String>(
                            value: count,
                            child: Text(
                              count,
                              textAlign: TextAlign.center,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBabyCount = value;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.15,
              child: Text(
                '是否發生過妊娠合併症?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.5,
              left: screenWidth * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: const Text('是'),
                      value: 'yes',
                      groupValue: complicationAnswer,
                      onChanged: (value) {
                        setState(() {
                          complicationAnswer = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: const Text('否'),
                      value: 'no',
                      groupValue: complicationAnswer,
                      onChanged: (value) {
                        setState(() {
                          complicationAnswer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.6,
              left: screenWidth * 0.15,
              child: Text(
                '新生兒誕生後是否願意\n親自哺餵母乳?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.7,
              left: screenWidth * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
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
                    width: screenWidth * 0.3,
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
                top: screenHeight * 0.85,
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
                          "肚子有幾個寶寶": selectedBabyCount,
                          "是否發生過妊娠合併症?": complicationAnswer,
                          "是否願意親自哺餵母乳": breastfeedingAnswer,
                        });

                        logger.i("✅ Firestore 更新成功，userId: ${widget.userId}");

                        if (breastfeedingAnswer == 'yes') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FrequencyWidget(userId: widget.userId),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FirsttimeWidget(userId: widget.userId),
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
