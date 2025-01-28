import 'package:flutter/material.dart';

class FirstBreastfeedingWidget extends StatefulWidget {
  const FirstBreastfeedingWidget({super.key});

  @override
  State<FirstBreastfeedingWidget> createState() =>
      _FirstBreastfeedingWidgetState();
}

class _FirstBreastfeedingWidgetState extends State<FirstBreastfeedingWidget> {
  String? selectedDuration; // 存儲選擇的哺乳時長

  @override
  Widget build(BuildContext context) {
    // 獲取螢幕寬度和高度
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
            // 標題: 問題文字
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.15 - 5,
              child: Text(
                '目前預期純哺乳哺餵時長為\n幾個月?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06, // 動態調整字體大小
                  fontWeight: FontWeight.normal,
                  height: 1.5, // 調整行距
                ),
              ),
            ),
            // 下拉框: 哺乳時長選項
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
                  hint: Text(
                    '選擇月份',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
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
            // 下一步按鈕
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
                    onPressed: () {
                      // 下一步邏輯，跳轉到目標頁面
                      Navigator.pushNamed(context, '/FinishWidget');
                    },
                    child: Text(
                      '下一步',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: screenWidth * 0.05,
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
