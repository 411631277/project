import 'package:doctor_2/register/register.dart';
import 'package:flutter/material.dart';

class IamWidget extends StatelessWidget {
  const IamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator IamWidget - FRAME
    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 354,
              left: 226,
              child: Container(
                  width: 132,
                  height: 69,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 202, 234, 1),
                  ))),
          Positioned(
              top: 354,
              left: 57,
              child: Container(
                  width: 132,
                  height: 69,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(187, 223, 248, 1),
                  ))),
          Positioned(
              top: 216,
              left: 141,
              child: Text(
                '我是...?',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 40,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 365,
              left: 83,
              child: Text(
                '爸爸',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 40,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 365,
              left: 252,
              child: GestureDetector(
                onTap: () {
                  // 點擊跳轉到  IamWidget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterWidget(),
                    ),
                  );
                },
                child: Text('媽媽',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(147, 129, 108, 1),
                        fontFamily: 'Inter',
                        fontSize: 40,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1)),
              )),
        ]));
  }
}
