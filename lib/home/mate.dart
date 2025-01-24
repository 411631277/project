import 'package:flutter/material.dart';
import 'dart:math' as math;

class MateWidget extends StatelessWidget {
  const MateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator MateWidget - FRAME
    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 64,
              left: 41,
              child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/pregnancy.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 92,
              left: 156,
              child: Text(
                '配偶分享碼',
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
              top: 733,
              left: 109,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                    angle: -179.93464394637994 * (math.pi / 180),
                    child: Container(
                        width: 57.0217399597168,
                        height: 61,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/Back.png'),
                              fit: BoxFit.fitWidth),
                        ))),
              )),
          Positioned(
              top: 214,
              left: 37,
              child: Text(
                '配偶分享碼',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 219,
              left: 174,
              child: Container(
                  width: 154,
                  height: 19,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ))),
          Positioned(
              top: 217,
              left: 223,
              child: Text(
                '758902',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
        ]));
  }
}
