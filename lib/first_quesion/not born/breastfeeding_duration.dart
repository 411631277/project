import 'package:flutter/material.dart';

// ignore: camel_case_types
class Breastfeeding_durationWidget extends StatefulWidget {
  const Breastfeeding_durationWidget({super.key});

  @override
  State<Breastfeeding_durationWidget> createState() =>
      _FirstBreastfeedingWidgetState();
}

class _FirstBreastfeedingWidgetState
    extends State<Breastfeeding_durationWidget> {
  String? selectedDuration; // 存儲選擇的哺乳時長

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
              left: 56,
              child: Text(
                '前胎哺乳持續大概幾個月?',
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
            // 下拉框: 哺乳時長選項
            Positioned(
              top: 419,
              left: 118,
              child: SizedBox(
                width: 176,
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
                  hint: const Text(
                    '選擇月份',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      Navigator.pushNamed(context, '/StopWidget');
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
