import 'package:doctor_2/login.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ForgetPhoneWidget extends StatelessWidget {
  const ForgetPhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 背景容器
            Positioned(
              top: 257,
              left: 57,
              child: Container(
                width: 276,
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  borderRadius: BorderRadius.circular(8), // 加上圓角
                ),
              ),
            ),

            // 提示文字
            Positioned(
              top: 339,
              left: 85,
              child: Text(
                '已傳送更改密碼的簡訊到\n當初預設的手機號碼請查收',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  letterSpacing: -0.24,
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
              ),
            ),

            // 返回按鈕
            Positioned(
                top: 700,
                left: 45,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWidget(), // 替換為你的目標頁面
                      ),
                    );
                  },
                  child: Transform.rotate(
                    angle: 178.95515417269175 * (math.pi / 180),
                    child: Container(
                      width: 92.64129638671875,
                      height: 80.32401275634766,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.fitWidth,
                      )),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
