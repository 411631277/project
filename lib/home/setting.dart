import 'package:doctor_2/extensions.dart';
import 'package:doctor_2/home/mate.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'language.dart';
import 'notify.dart';
import 'deta.dart';
import 'phone.dart';
import 'sign_out.dart';
import 'privacy.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({super.key});

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
            // 語言按鈕
            Positioned(
              top: screenHeight * 0.08,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageWidget(),
                    ),
                  );
                },
                child: Text(
                  context.t('language'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.08,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/language.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 通知按鈕
            Positioned(
              top: screenHeight * 0.18,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotifyWidget(),
                    ),
                  );
                },
                child: Text(
                  context.t('notification'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.18,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/notify.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 基本資料修改按鈕
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetaWidget(),
                    ),
                  );
                },
                child: Text(
                  context.t('data'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/data.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 院內電話查詢按鈕
            Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhoneWidget(),
                    ),
                  );
                },
                child: Text(
                  context.t('phone'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/phone.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 配偶分享碼按鈕
            Positioned(
              top: screenHeight * 0.48,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MateWidget(),
                    ),
                  );
                },
                child: Text(
                  context.t('share'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.43,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.12,
                height: screenHeight * 0.15,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pregnancy.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 隱私權政策按鈕
            Positioned(
              top: screenHeight * 0.58,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
                child: Text(
                  context.t('privacy'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.58,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/privacy.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 登出按鈕
            Positioned(
              top: screenHeight * 0.68,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignoutWidget(),
                    ),
                  );
                },
                child: Text(
                  context.t('signout'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.68,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.1,
                height: screenHeight * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/signout.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
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
                        fit: BoxFit.fitWidth,
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
