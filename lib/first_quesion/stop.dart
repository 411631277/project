import 'package:flutter/material.dart';

// ignore: camel_case_types
class StopWidget extends StatefulWidget {
  const StopWidget({super.key});

  @override
  State<StopWidget> createState() => _BreastfeedingReasonWidgetState();
}

class _BreastfeedingReasonWidgetState extends State<StopWidget> {
  String? breastfeedingReason; // 存儲輸入的停止哺乳原因

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 標題: 問題文字
            const Positioned(
              top: 315,
              left: 80,
              child: Text(
                '停止哺餵母乳的原因',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 文本框: 輸入停止原因
            Positioned(
              top: 400,
              left: 80,
              right: 80,
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
              ),
            ),
            // 下一步按鈕
            Positioned(
              top: 687,
              left: 129,
              child: SizedBox(
                width: 154,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  onPressed: () {
                    // 下一步邏輯，跳轉到目標頁面
                    Navigator.pushNamed(context, '/FinishWidget');
                  },
                  child: const Text(
                    '下一步',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 25,
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
