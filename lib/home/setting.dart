import 'package:doctor_2/function/extensions.dart';
import 'package:doctor_2/home/mate.dart';
import 'package:doctor_2/home/profile.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'fa_home_screen.dart';
import 'home_screen.dart';
import 'language.dart';
import 'notify.dart';
import 'phone.dart';
import 'sign_out.dart';
import 'privacy.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class SettingWidget extends StatefulWidget {
  final String userId; // 🔹 從登入或註冊時傳入的 userId
  final bool isManUser;
  final int stepCount;
  final Function(int) updateStepCount;
  const SettingWidget({
    super.key,
    required this.userId,
    required this.isManUser,
    required this.stepCount,
    required this.updateStepCount,
  });

  @override
  SettingWidgetState createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
     final base = math.min(screenWidth, screenHeight); // ✅
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
                    fontSize: (base * 0.06).clamp(16.0, 24.0),
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
                      builder: (context) => NotifyWidget(userId: widget.userId, isManUser: widget.isManUser,),
                    ),
                  );
                },
                child: Text(
                  context.t('notification'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                   fontSize: (base * 0.06).clamp(16.0, 24.0),
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
            // 個人基本資料按鈕
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userId: widget.userId,
                        isManUser: widget.isManUser,
                      ),
                    ),
                  );
                },
                child: Text(
                  context.t('data'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: (base * 0.06).clamp(16.0, 24.0),
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
                   fontSize: (base * 0.06).clamp(16.0, 24.0),
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
                      builder: (context) => MateWidget(userId: widget.userId, isManUser: widget.isManUser,),
                    ),
                  );
                },
                child: Text(
                  context.t('share'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                   fontSize: (base * 0.06).clamp(16.0, 24.0),
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
                    fontSize: (base * 0.06).clamp(16.0, 24.0),
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
                      builder: (context) => SignoutWidget(
                        userId: widget.userId,
                        stepCount: widget.stepCount,
                        updateStepCount: widget.updateStepCount,
                      ),
                    ),
                  );
                },
                child: Text(
                  context.t('signout'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(147, 129, 108, 1),
                    fontFamily: 'Inter',
                    fontSize: (base * 0.06).clamp(16.0, 24.0),
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => widget.isManUser
                            ? FaHomeScreenWidget(
                                userId: widget.userId,
                                isManUser: true, // ⭐ 傳遞身份
                                updateStepCount: (steps) {},
                              )
                            : HomeScreenWidget(
                                userId: widget.userId,
                                isManUser: false, // ⭐ 傳遞身份
                              ),
                      ));
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
