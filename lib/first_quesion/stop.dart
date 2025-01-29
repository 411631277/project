import 'package:flutter/material.dart';

class StopWidget extends StatefulWidget {
  const StopWidget({super.key});

  @override
  State<StopWidget> createState() => _StopWidgetState();
}

class _StopWidgetState extends State<StopWidget> {
  String? breastfeedingReason; // 存儲輸入的停止哺乳原因

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // **標題: 停止哺乳的原因**
            Positioned(
              top: screenHeight * 0.35, // 佔螢幕 35% 的高度
              left: screenWidth * 0.2, // 讓標題置中
              child: Text(
                '停止哺餵母乳的原因',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06, // 自適應字體大小
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // **輸入框: 讓使用者輸入停止哺乳的原因**
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    breastfeedingReason = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: '請輸入原因',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                style: TextStyle(fontSize: screenWidth * 0.05), // 讓文字大小隨螢幕變化
              ),
            ),
            // **下一步按鈕**
            Positioned(
              top: screenHeight * 0.75, // 佔螢幕 75% 的高度
              left: screenWidth * 0.3,
              child: SizedBox(
                width: screenWidth * 0.4, // 按鈕寬度佔螢幕 40%
                height: screenHeight * 0.07, // 按鈕高度佔螢幕 7%
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // **跳轉到 FinishWidget 頁面**
                    Navigator.pushNamed(context, '/FinishWidget');
                  },
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.06, // 自適應字體大小
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
