import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_question/nmfrequency.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:doctor_2/first_question/frequency.dart';
import 'package:doctor_2/first_question/firsttime.dart';
import 'package:doctor_2/services/backend3000/backend3000.dart';

final Logger logger = Logger();

class Notyet1Widget extends StatefulWidget {
  final String userId;
  final bool isNewMom;
  const Notyet1Widget({super.key, required this.userId, required this.isNewMom});

  @override
  State<Notyet1Widget> createState() => _Notyet1WidgetState();
}

class _Notyet1WidgetState extends State<Notyet1Widget> {
  String? breastfeedingAnswer;
  String? complicationAnswer;
  String? selectedBabyCount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isAllAnswered = breastfeedingAnswer != null &&
        complicationAnswer != null &&
        selectedBabyCount != null;

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
              top: screenHeight * 0.20,
              left: screenWidth * 0.25,
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
                      .map((babyCountOption) => DropdownMenuItem<String>(
                            value: babyCountOption,
                            child: Text(
                              babyCountOption,
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
              left: screenWidth * 0.25,
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
              left: screenWidth * 0.20,
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
              left: screenWidth * 0.25,
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
              left: screenWidth * 0.20,
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
                          "寶寶數量": selectedBabyCount,
                          "妊娠合併症": complicationAnswer,
                          "親自哺餵母乳": breastfeedingAnswer,
                        });
                        await sendNotYetDataToMySQL(
                          widget.userId,
                          selectedBabyCount!,
                          complicationAnswer!,
                          breastfeedingAnswer!,
                        );
                        logger.i("✅ Firestore 更新成功，userId: ${widget.userId}");

                        if (!mounted) return;

                       setState(() {
  if (breastfeedingAnswer == 'yes') {
    if (widget.isNewMom) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NmFrequencyWidget(userId: widget.userId),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FrequencyWidget(userId: widget.userId),
        ),
      );
    }
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirsttimeWidget(userId: widget.userId),
      ),
    );
  }
});
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

  Future<void> sendNotYetDataToMySQL(
  String userId,
  String babyCount,
  String complication,
  String breastfeeding,
) async {
  try {
    await Backend3000.userQuestionApi.updateUserQuestion(
      userId: int.parse(userId),
      fields: {
        'pregnancy_babies_count': babyCount,
        'pregnancy_complications': complication == 'yes' ? '是' : '否',
        'willing_to_breastfeed': breastfeeding == 'yes' ? '是' : '否',
      },
    );

    logger.i("✅ notyet 資料同步 MySQL 成功");
  } catch (e, stack) {
    logger.e("❌ 同步 MySQL 失敗", error: e, stackTrace: stack);
  }
}

}
