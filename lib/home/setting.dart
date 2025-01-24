import 'package:doctor_2/home/mate.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'language.dart'; // 導入 LanguageWidget
import 'notify.dart';
import 'deta.dart';
import 'phone.dart';
import 'sign_out.dart';
import 'privacy.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 語言按鈕
            Positioned(
              top: 75,
              left: 180,
              child: GestureDetector(
                onTap: () {
                  // 點擊跳轉到 LanguageWidget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageWidget(),
                    ),
                  );
                },
                child: const Text(
                  '語言',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 36,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 75,
              left: 45,
              child: Container(
                width: 42,
                height: 49,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/language.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            //通知按鈕
            Positioned(
              top: 165,
              left: 180,
              child: GestureDetector(
                onTap: () {
                  // 點擊跳轉到 NotificationWidget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotifyWidget(),
                    ),
                  );
                },
                child: const Text(
                  '通知設定',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: 36,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 165,
              left: 45,
              child: Container(
                width: 42,
                height: 49,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/notify.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            //基本資料修改按鈕
            Positioned(
                top: 255,
                left: 180,
                child: GestureDetector(
                    onTap: () {
                      // 點擊跳轉到 dataWidget
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetaWidget(),
                        ),
                      );
                    },
                    child: Text(
                      '基本資料修改',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ))),
            Positioned(
                top: 255,
                left: 45,
                child: Container(
                    width: 42,
                    height: 49,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/data.png'),
                          fit: BoxFit.fitWidth),
                    ))),
            //院內電話查詢按鈕
            Positioned(
                top: 345,
                left: 180,
                child: GestureDetector(
                    onTap: () {
                      // 點擊跳轉到 phoneWidget
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhoneWidget(),
                        ),
                      );
                    },
                    child: Text(
                      '院內電話查詢',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ))),
            Positioned(
                top: 345,
                left: 45,
                child: Container(
                    width: 42,
                    height: 49,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/phone.png'),
                          fit: BoxFit.fitWidth),
                    ))),
            //配偶分享碼按鈕
            Positioned(
                top: 435,
                left: 180,
                child: GestureDetector(
                    onTap: () {
                      // 點擊跳轉到配偶分享碼畫面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MateWidget(),
                        ),
                      );
                    },
                    child: Text(
                      '配偶分享碼',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ))),
            Positioned(
                top: 385,
                left: 33,
                child: Container(
                    width: 75,
                    height: 147,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/pregnancy.png'),
                          fit: BoxFit.fitWidth),
                    ))),
            //隱私權政策按鈕
            Positioned(
                top: 525,
                left: 180,
                child: GestureDetector(
                    onTap: () {
                      // 點擊跳轉到隱私權畫面
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage(),
                        ),
                      );
                    },
                    child: Text(
                      '隱私權政策',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ))),
            Positioned(
                top: 525,
                left: 45,
                child: Container(
                    width: 42,
                    height: 49,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/privacy.png'),
                          fit: BoxFit.fitWidth),
                    ))),
            //登出按鈕
            Positioned(
                top: 610,
                left: 180,
                child: GestureDetector(
                  onTap: () {
                    // 點擊跳轉到 signoutWidget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignoutWidget(),
                      ),
                    );
                  },
                  child: Text('登出帳號',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Inter',
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1)),
                )),
            Positioned(
                top: 610,
                left: 45,
                child: Container(
                    width: 42,
                    height: 49,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/signout.png'),
                          fit: BoxFit.fitWidth),
                    ))),
            //返回上一頁
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
                    )),
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
