import 'package:doctor_2/home/question.dart';
import 'package:doctor_2/home/setting.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ignore: camel_case_types
class Home_screenWidget extends StatefulWidget {
  const Home_screenWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Home_screenWidgetState createState() => _Home_screenWidgetState();
}

// ignore: camel_case_types
class _Home_screenWidgetState extends State<Home_screenWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator Home_screenWidget - FRAME

    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 229,
              left: 27,
              child: Text(
                '今天心情還好嗎?一切都會越來越好喔!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 66,
              left: 131,
              child: Text(
                '陳XX',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 42,
              left: 316,
              child: GestureDetector(
                  onTap: () {
                    // 點擊跳轉到 NotificationWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingWidget(),
                      ),
                    );
                  },
                  child: Container(
                    width: 77.4339599609375,
                    height: 72,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/Setting.png'),
                            fit: BoxFit.fitWidth)),
                  ))),
          Positioned(
              top: 310,
              left: 42,
              child: Text(
                '要來測一下今日的身體指數嗎?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 728,
              left: 316,
              child: Container(
                  width: 74,
                  height: 86,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Robot.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 343,
              left: 42,
              child: Divider(
                  color: Color.fromRGBO(165, 146, 125, 1), thickness: 1)),
          Positioned(
              top: 630,
              left: 104,
              child: Text(
                '小寶',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 697,
              left: 172.65106201171875,
              child: Transform.rotate(
                angle: -5.560523526370695 * (math.pi / 180),
                child: Container(
                    width: 157,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(165, 146, 125, 1),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(157, 48)),
                    )),
              )),
          Positioned(
              top: 713,
              left: 191.99993896484375,
              child: Text(
                '需要協助嗎?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 38,
              left: 239,
              child: GestureDetector(
                  onTap: () {
                    // 點擊跳轉到 LanguageWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionWidget(),
                      ),
                    );
                  },
                  child: Container(
                      width: 61.20000076293945,
                      height: 72,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/Question.png'),
                            fit: BoxFit.fitWidth),
                      )))),
          Positioned(
              top: 609,
              left: 30,
              child: Container(
                  width: 54,
                  height: 66,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Baby.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 423,
              left: 27,
              child: Text(
                '今日步數',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 492,
              left: 42,
              child: Text(
                '步數未達標!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 421,
              left: 204,
              child: Text(
                '昨日步數',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 451,
              left: 116,
              child: Transform.rotate(
                angle: -2.3883131783569826e-8 * (math.pi / 180),
                child: Divider(
                    color: Color.fromRGBO(147, 129, 108, 1), thickness: 1),
              )),
          Positioned(
              top: 451,
              left: 297,
              child: Transform.rotate(
                angle: -2.3883131783569826e-8 * (math.pi / 180),
                child: Divider(
                    color: Color.fromRGBO(147, 129, 108, 1), thickness: 1),
              )),
          Positioned(
              top: 419,
              left: 133,
              child: Text(
                '8623',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 416,
              left: 313,
              child: Text(
                '8380',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 30,
              left: 27,
              child: Container(
                  width: 79.23213958740234,
                  height: 87,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Picture.png'),
                        fit: BoxFit.fitWidth),
                  ))),
        ]));
  }
}
