import 'package:flutter/material.dart';
import 'dart:math' as math;

class NotifyWidget extends StatefulWidget {
  const NotifyWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotifyWidgetState createState() => _NotifyWidgetState();
}

class _NotifyWidgetState extends State<NotifyWidget> {
  bool isBodyDataReminderOn = false; // 身體數據量測提醒的開關狀態
  bool isExerciseReminderOn = false; // 運動提醒的開關狀態

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
            Positioned(
              top: 199,
              left: 174,
              child: Container(
                width: 42,
                height: 49,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/notify.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 身體數據量測提醒
            Positioned(
              top: 335,
              left: 40,
              child: const Text(
                '身體數據量測提醒',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: 335,
              left: 282,
              child: Switch(
                value: isBodyDataReminderOn,
                onChanged: (bool newValue) {
                  setState(() {
                    isBodyDataReminderOn = newValue;
                  });
                },
              ),
            ),
            // 運動提醒
            Positioned(
              top: 398,
              left: 40,
              child: const Text(
                '運動提醒',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: 398,
              left: 282,
              child: Switch(
                value: isExerciseReminderOn,
                onChanged: (bool newValue) {
                  setState(() {
                    isExerciseReminderOn = newValue;
                  });
                },
              ),
            ),
            // 返回按鈕
            Positioned(
              top: 720,
              left: 215.0640106201172,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: 179.80448080946567 * (math.pi / 180),
                  child: Container(
                    width: 70.06442260742188,
                    height: 64.76126861572266,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.fitWidth,
                      ),
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
