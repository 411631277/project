import 'package:flutter/material.dart';
import 'dart:math' as math;

class NotifyWidget extends StatefulWidget {
  const NotifyWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotifyWidgetState createState() => _NotifyWidgetState();
}

class _NotifyWidgetState extends State<NotifyWidget> {
  bool isBodyDataReminderOn = false; // 運動提醒的開關狀態
 

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
        child: Stack(
          children: <Widget>[
            // 圖標
            Positioned(
              top: screenHeight * 0.22,
              left: screenWidth * 0.42,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.07,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/notify.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // 身體數據量測提醒
            Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.1,
              child: Text(
                '運動提醒',
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
              top: screenHeight * 0.36,
              left: screenWidth * 0.7,
              child: Switch(
                value: isBodyDataReminderOn,
                onChanged: (bool newValue) {
                  setState(() {
                    isBodyDataReminderOn = newValue;
                  });
                },
              ),
            ),
           
            // 返回按鈕
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.contain,
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
