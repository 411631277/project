import 'package:doctor_2/iam.dart';
import 'package:doctor_2/login.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Main_screenWidget extends StatelessWidget {
  const Main_screenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator Main_screenWidget - FRAME
    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: 662.7606811523438,
              left: 92.96410369873047,
              child: Container(
                  width: 226.07179260253906,
                  height: 88.00592041015625,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    color: Color.fromRGBO(165, 146, 125, 1),
                  ))),
          Positioned(
              top: 680.14453125,
              left: 163.74359130859375,
              child: GestureDetector(
                  onTap: () {
                    // 點擊跳轉到  IamWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IamWidget(),
                      ),
                    );
                  },
                  child: Text(
                    '註冊',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Inter',
                        fontSize: 40,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ))),
          Positioned(
              top: 496.5272521972656,
              left: 92.96410369873047,
              child: Container(
                  width: 226.07179260253906,
                  height: 88.00592041015625,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    color: Color.fromRGBO(165, 146, 125, 1),
                  ))),
          Positioned(
              top: 513.9111328125,
              left: 163.74359130859375,
              child: GestureDetector(
                  onTap: () {
                    // 點擊跳轉到  LoginWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWidget(),
                      ),
                    );
                  },
                  child: Text(
                    '登入',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Inter',
                        fontSize: 40,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ))),
          Positioned(
              top: -7,
              left: 0,
              child: Container(
                  width: 412,
                  height: 395,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Main.png'),
                        fit: BoxFit.fitWidth),
                  ))),
        ]));
  }
}
