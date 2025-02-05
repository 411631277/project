import 'package:doctor_2/first_quesion/first_breastfeeding.dart';
import 'package:doctor_2/first_quesion/notfirst.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Logger logger = Logger();

class Nowfeeding extends StatefulWidget {
  final String userId;
  const Nowfeeding({super.key, required this.userId});

  @override
  State<Nowfeeding> createState() => _Nowfeeding();
}

class _Nowfeeding extends State<Nowfeeding> {
  String? purebreastmilk;
  String? firstime;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 檢查是否所有問題都填答
    final isAllAnswered = purebreastmilk != null && firstime != null;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // **第一部分: 新生兒哺乳是否為純母乳?**
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.2,
              child: Text(
                '新生兒哺乳是否為純母乳??',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // **是選項**
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '是',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'yes',
                      groupValue: purebreastmilk,
                      onChanged: (value) {
                        setState(() {
                          purebreastmilk = value;
                        });
                      },
                    ),
                  ),
                  // **否選項**
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '否',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'no',
                      groupValue: purebreastmilk,
                      onChanged: (value) {
                        setState(() {
                          purebreastmilk = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // **第二部分: 是否為首次哺乳?**
            Positioned(
              top: screenHeight * 0.5,
              left: screenWidth * 0.25 + 10,
              child: Text(
                '是否為首次哺乳?',
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
              top: screenHeight * 0.55,
              left: screenWidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // **是選項**
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '是',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'yes',
                      groupValue: firstime,
                      onChanged: (value) {
                        setState(() {
                          firstime = value;
                        });
                      },
                    ),
                  ),
                  // **否選項**
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '否',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'no',
                      groupValue: firstime,
                      onChanged: (value) {
                        setState(() {
                          firstime = value;
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
                            .set({
                          "是否為純母乳": purebreastmilk,
                          "是否首次哺乳": firstime,
                        }, SetOptions(merge: true)); // 🔹 避免覆蓋原有資料

                        logger.i("✅ Firestore 更新成功，userId: ${widget.userId}");

                        if (!context.mounted) return;

                        // 🔹 使用 `Navigator.pushReplacement` 避免返回上一頁
                        if (firstime == 'yes') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstBreastfeedingWidget(
                                  userId: widget.userId),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
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
}
