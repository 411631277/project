import 'package:doctor_2/main.screen.dart';
import 'package:flutter/material.dart';

class SignoutWidget extends StatelessWidget {
  const SignoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator SignoutWidget - FRAME
    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 272,
              left: 47,
              child: Container(
                  width: 318,
                  height: 283,
                  decoration: BoxDecoration(),
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 52,
                        left: 30,
                        child: Container(
                            width: 255,
                            height: 205,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(147, 129, 108, 1),
                            ))),
                    Positioned(
                        top: 111,
                        left: 72,
                        child: Text(
                          '確認要登出帳號嗎?',
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
                        top: 180,
                        left: 72,
                        child: Container(
                            width: 58,
                            height: 27,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                  255, 255, 255, 0.6000000238418579),
                            ))),
                    Positioned(
                        top: 180,
                        left: 185,
                        child: Container(
                            width: 58,
                            height: 27,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(
                                  255, 255, 255, 0.6000000238418579),
                            ))),
                    Positioned(
                        top: 182,
                        left: 91,
                        child: GestureDetector(
                            onTap: () {
                              // 點擊跳轉到 LanguageWidget
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Main_screenWidget(),
                                ),
                              );
                            },
                            child: Text(
                              '是',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.36000001430511475),
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ))),
                    Positioned(
                        top: 182,
                        left: 204,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // 返回上一頁
                            },
                            child: Text(
                              '否',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.36000001430511475),
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ))),
                  ]))),
        ]));
  }
}
