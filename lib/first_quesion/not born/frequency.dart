import 'package:flutter/material.dart';

class FrequencyWidget extends StatefulWidget {
  const FrequencyWidget({super.key});

  @override
  State<FrequencyWidget> createState() => _FrequencyWidgetState();
}

class _FrequencyWidgetState extends State<FrequencyWidget> {
  String? breastfeedingAnswer; // 存儲親自哺乳的回答
  String? pregnancyCount; // 懷孕次數
  String? deliveryCount; // 生產次數

  @override
  Widget build(BuildContext context) {
    // 獲取螢幕寬高比例
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // 第一部分: 懷孕次數
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.33 + 15,
              child: Text(
                '懷孕次數',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.33,
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
                  hint: Text(
                    '次數',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.grey,
                    ),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((count) => DropdownMenuItem<String>(
                            value: count,
                            child: Text(count),
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
            // 第二部分: 生產次數
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.33 + 15,
              child: Text(
                '生產次數',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.33,
              child: SizedBox(
                width: screenWidth * 0.4,
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
                      fontSize: screenWidth * 0.045,
                      color: Colors.grey,
                    ),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((count) => DropdownMenuItem<String>(
                            value: count,
                            child: Text(count),
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
            // 第三部分: 新生兒誕生後是否願意親自哺餵母乳?
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.25 + 15,
              child: Text(
                '是否為首次哺乳?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.60,
              left: screenWidth * 0.20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.35,
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
                  SizedBox(
                    width: screenWidth * 0.35,
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
            // 下一步按鈕
            if (pregnancyCount != null &&
                deliveryCount != null &&
                breastfeedingAnswer != null)
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
                        Navigator.pushNamed(
                            context, '/FirstBreastfeedingWidget');
                      } else if (breastfeedingAnswer == 'no') {
                        Navigator.pushNamed(context, '/SuccessWidget');
                      }
                    },
                    child: Text(
                      '下一步',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: screenWidth * 0.06,
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
