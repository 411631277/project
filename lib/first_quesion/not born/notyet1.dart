import 'package:flutter/material.dart';

class Notyet1Widget extends StatefulWidget {
  const Notyet1Widget({super.key});

  @override
  State<Notyet1Widget> createState() => _Notyet1WidgetState();
}

class _Notyet1WidgetState extends State<Notyet1Widget> {
  String? breastfeedingAnswer; // 存儲親自哺餵母乳的回答
  String? complicationAnswer; // 存儲妊娠合併症的回答
  String? selectedBabyCount; // 存儲肚子裡寶寶的數量

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 檢查是否所有問題都填答
    final isAllAnswered = breastfeedingAnswer != null &&
        complicationAnswer != null &&
        selectedBabyCount != null;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // 第一部分: 肚子裡有幾個寶寶
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.1 + 70,
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
              top: screenHeight * 0.2,
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
            // 第二部分: 是否發生過妊娠合併症
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.1 + 40,
              child: Text(
                '是否發生過妊娠合併症?',
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
              left: screenWidth * 0.1 + 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 是選項
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '是',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color.fromRGBO(147, 129, 108, 1),
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
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '否',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color.fromRGBO(147, 129, 108, 1),
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
            // 第三部分: 新生兒誕生後是否願意親自哺餵母乳?
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.1 + 40,
              child: Text(
                '新生兒誕生後是否願意\n親自哺餵母乳?',
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
              top: screenHeight * 0.65,
              left: screenWidth * 0.1 + 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 是選項
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '是',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color.fromRGBO(147, 129, 108, 1),
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
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '否',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: const Color.fromRGBO(147, 129, 108, 1),
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
            // 下一步按鍵
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
                    onPressed: () {
                      if (breastfeedingAnswer == 'yes') {
                        Navigator.pushNamed(context, '/FrequencyWidget');
                      } else if (breastfeedingAnswer == 'no') {
                        Navigator.pushNamed(context, '/FirsttimeWidget');
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
