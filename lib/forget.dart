import 'package:doctor_2/forget_phone.dart';
import 'package:doctor_2/success.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ForgetWidget extends StatelessWidget {
  const ForgetWidget({super.key});

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
            // e-mail驗證按鈕
            Positioned(
              top: 419,
              left: 88,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SuccessWidget()),
                  );
                },
                child: Container(
                  width: 235,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'e-mail驗證',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.54),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 電話驗證按鈕
            Positioned(
              top: 512,
              left: 88,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgetPhoneWidget()),
                  );
                },
                child: Container(
                  width: 235,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '電話驗證',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.54),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 提示文字
            Positioned(
              top: 234,
              left: 20,
              child: Text(
                '請問要使用e-mail還是電話傳送更改密碼連結?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // 返回按鈕
            Positioned(
              top: 700,
              left: 45,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
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
                        )))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
