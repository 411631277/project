import 'package:doctor_2/first_question/finish.dart';
import 'package:doctor_2/first_question/nowfeeding.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger();

class YesyetWidget extends StatefulWidget {
  final String userId;
  const YesyetWidget({super.key, required this.userId});

  @override
  State<YesyetWidget> createState() => _YesyetWidgetState();
}

class _YesyetWidgetState extends State<YesyetWidget> {
  String? babyCount;
  String? pregnancyCount;
  String? deliveryCount;
  String? complicationAnswer;
  String? breastfeedingAnswer;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 檢查是否所有問題都填答
    final isAllAnswered = babyCount != null &&
        pregnancyCount != null &&
        deliveryCount != null &&
        complicationAnswer != null &&
        breastfeedingAnswer != null;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // **第一部分: 肚子裡有幾個寶寶**
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.3 - 2,
              child: Text(
                '肚子裡有幾個寶寶',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
                child: DropdownButtonFormField<String>(
                  value: babyCount,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: Text(
                    '選擇數量',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045, color: Colors.grey),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((countbaby) => DropdownMenuItem<String>(
                            value: countbaby,
                            child: Text(countbaby),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      babyCount = value;
                    });
                  },
                ),
              ),
            ),

            // **第二部分: 懷孕次數**
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.35 + 5,
              child: Text(
                '懷孕次數',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
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
                  value: pregnancyCount,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: Text(
                    '次數',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045, color: Colors.grey),
                  ),
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

            // **第三部分: 生產次數**
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.35 + 5,
              child: Text(
                '生產次數',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
                child: DropdownButtonFormField<String>(
                  value: deliveryCount,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: Text(
                    '次數',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045, color: Colors.grey),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((productioncount) => DropdownMenuItem<String>(
                            value: productioncount,
                            child: Text(productioncount),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      deliveryCount = value;
                    });
                  },
                ),
              ),
            ),
// 第四部分: 是否發生過妊娠合併症
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.25,
              child: Text(
                '是否發生過妊娠合併症?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.58,
              left: screenWidth * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 是選項
                  SizedBox(
                    width: 120,
                    child: RadioListTile<String>(
                      title: const Text(
                        '是',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'yes',
                      groupValue: complicationAnswer,
                      onChanged: (value) {
                        setState(() {
                          complicationAnswer = value;
                        });
                      },
                    ),
                  ),
                  // 否選項
                  SizedBox(
                    width: 120,
                    child: RadioListTile<String>(
                      title: const Text(
                        '否',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
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
            // 第五部分: 目前是否為有哺餵新生兒母乳??
            Positioned(
              top: screenHeight * 0.67,
              left: screenWidth * 0.17,
              child: Text(
                '目前是否為有哺餵新生兒母乳?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.70,
              left: screenWidth * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 是選項
                  SizedBox(
                    width: 120,
                    child: RadioListTile<String>(
                      title: const Text(
                        '是',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'yes',
                      groupValue: breastfeedingAnswer,
                      onChanged: (value) {
                        setState(() {
                          breastfeedingAnswer = value;
                        });
                      },
                    ),
                  ),
                  // 否選項
                  SizedBox(
                    width: 120,
                    child: RadioListTile<String>(
                      title: const Text(
                        '否',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
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
            // **「下一步」按鈕**
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
                            .set(
                                {
                              "肚子寶寶數量": babyCount,
                              "懷孕次數": pregnancyCount,
                              "生產次數": deliveryCount,
                              "是否有妊娠合併症": complicationAnswer,
                              "是否有餵哺新生兒母乳": breastfeedingAnswer,
                            },
                                SetOptions(
                                    merge:
                                        true)); // 🔹 使用 `merge: true` 避免覆蓋原有資料
                        await sendYesYetDataToMySQL(
                          widget.userId,
                          babyCount!,
                          pregnancyCount!,
                          deliveryCount!,
                          complicationAnswer!,
                          breastfeedingAnswer!,
                        );
                        logger.i("✅ Firestore 更新成功，userId: ${widget.userId}");

                        if (!context.mounted) return;

                        // 🔹 使用 `Navigator.pushReplacement` 來避免返回上一頁
                        if (breastfeedingAnswer == 'yes') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Nowfeeding(userId: widget.userId),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
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

  Future<void> sendYesYetDataToMySQL(
      String userId,
      String babyCount,
      String pregnancyCount,
      String deliveryCount,
      String complicationAnswer,
      String breastfeedingAnswer ) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        'pregnancy_babies_count': babyCount,
        'pregnancy_count': pregnancyCount,
        'delivery_count': deliveryCount,
        'pregnancy_complications': complicationAnswer  == '是' ? '是' : '否',
        'currently_breastfeeding': breastfeedingAnswer == '是' ? '是' : '否',
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ yesyet 資料同步 MySQL 成功");
    } else {
      logger.e("❌ 同步 MySQL 失敗: ${response.body}");
    }
  }
}
