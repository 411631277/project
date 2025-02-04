import 'package:flutter/material.dart';

class FirsttimeWidget extends StatefulWidget {
  const FirsttimeWidget({super.key, required String userId});

  @override
  State<FirsttimeWidget> createState() => _FirsttimeWidgetState();
}

class _FirsttimeWidgetState extends State<FirsttimeWidget> {
  String? answer; // 儲存「是」或「否」的回答

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // **問題文字**
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.2),
              child: Text(
                '是否為第一次生產?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.07, // 自適應字體大小
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // **選項 (讓 "是" 和 "否" 在同行)**
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                children: [
                  SizedBox(
                    width: screenWidth * 0.3, // 固定寬度，避免擠壓換行
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
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.3, // 固定寬度
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
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // **下一步按鈕**
            if (answer != null)
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.1),
                child: SizedBox(
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () {
                      if (answer == 'yes') {
                        Navigator.pushNamed(context, '/FinishWidget');
                      } else {
                        Navigator.pushNamed(
                            context, '/BreastfeedingDurationWidget');
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
