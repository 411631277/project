import 'package:flutter/material.dart';
import 'dart:math' as math;

// ignore: use_key_in_widget_constructors
class PhoneWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator PhoneWidget - FRAME
    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 103,
              left: 132,
              child: Text(
                '院內電話查詢',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 30,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 163,
              left: 65,
              child: Container(
                  width: 247,
                  height: 513,
                  decoration: BoxDecoration(),
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 25,
                        left: 57,
                        child: Text(
                          '民診處辦公室',
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
                        top: 335,
                        left: 55,
                        child: Text(
                          '語音預約掛號',
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
                        top: 417,
                        left: 55,
                        child: Text(
                          '人工預約掛號',
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
                        top: 86,
                        left: 67,
                        child: Text(
                          '稽核作業組',
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
                        top: 146,
                        left: 67,
                        child: Text(
                          '營運成本組',
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
                        top: 206,
                        left: 67,
                        child: Text(
                          '保險作業組',
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
                        top: 56,
                        left: 20,
                        child: Text(
                          '(02)87923311#88006 ',
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
                        top: 116,
                        left: 20,
                        child: Text(
                          '(02)87923311#88207',
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
                        top: 176,
                        left: 20,
                        child: Text(
                          '(02)87923311#88006 ',
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
                        top: 236,
                        left: 19,
                        child: Text(
                          ' (02)87923311#88172 ',
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
                        top: 376,
                        left: 51,
                        child: Text(
                          '(02)87927111',
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
                        top: 458,
                        left: 51,
                        child: Text(
                          '(02)87927222',
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
                  ]))),
          Positioned(
              top: 97,
              left: 49,
              child: Container(
                  width: 42,
                  height: 48,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/3.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 733,
              left: 109,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                    angle: -178.41630656524814 * (math.pi / 180),
                    child: Container(
                      width: 58.7400016784668,
                      height: 62.838134765625,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/7.png'),
                              fit: BoxFit.fitWidth)),
                    )),
              )),
        ]));
  }
}
