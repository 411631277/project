import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class NotifyWidget extends StatefulWidget {
  final String userId;
  final bool isManUser;
  const NotifyWidget({super.key, required this.userId , required this.isManUser});

  @override
  NotifyWidgetState createState() => NotifyWidgetState();
}

class NotifyWidgetState extends State<NotifyWidget> {
  bool isBodyDataReminderOn = true;

  @override
  void initState() {
    super.initState();
    _loadSwitchState(); 
  }

   Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    // 依據 isManUser 產生不同 key
    final typeKey = widget.isManUser ? 'man' : 'woman';
    final key = 'exerciseReminder_${typeKey}_${widget.userId}';

    bool storedValue = prefs.getBool(key) ?? true;
    setState(() {
      isBodyDataReminderOn = storedValue;
    });
  }

   Future<void> _saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final typeKey = widget.isManUser ? 'man' : 'woman';
    final key = 'exerciseReminder_${typeKey}_${widget.userId}';

    await prefs.setBool(key, value);
  }

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
            // 運動提醒
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
                  _saveSwitchState(newValue); // 同步儲存到 SharedPreferences
                },
              ),
            ),

            // 返回按鈕
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
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
