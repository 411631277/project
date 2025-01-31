import 'package:flutter/material.dart';

class BreastfeedingDurationWidget extends StatefulWidget {
  const BreastfeedingDurationWidget({super.key});

  @override
  State<BreastfeedingDurationWidget> createState() =>
      _BreastfeedingDurationWidgetState();
}

class _BreastfeedingDurationWidgetState
    extends State<BreastfeedingDurationWidget> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // **標題: 問題文字**
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Text(
                '前胎哺乳持續大概幾個月?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06, // 字體大小自適應
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // **下拉框: 哺乳時長選項**
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.05),
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
                  hint: Text(
                    '選擇月份',
                    style: TextStyle(
                        fontSize: screenWidth * 0.04, color: Colors.grey),
                  ),
                  items: List.generate(13, (index) => index.toString())
                      .map((month) => DropdownMenuItem<String>(
                            value: month,
                            child: Text('$month 個月',
                                style: TextStyle(fontSize: screenWidth * 0.04)),
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

            // **下一步按鈕 (當選擇數值後才出現)**
            if (selectedDuration != null)
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
                      Navigator.pushNamed(context, '/StopWidget');
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
