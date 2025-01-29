import 'package:doctor_2/agree.dart';
import 'package:doctor_2/login/login.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Main_screenWidget extends StatelessWidget {
  const Main_screenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 MediaQuery 提供自適應螢幕的比例
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
            top: screenHeight * 0.68, // 調整按鍵位置向上
            left: screenWidth * 0.22,
            child: SizedBox(
              width: screenWidth * 0.55,
              height: screenHeight * 0.09, // 縮小按鍵高度
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(165, 146, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                onPressed: () {
                  // 點擊跳轉到 agreeWidget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResearchAgreementWidget(),
                    ),
                  );
                },
                child: const Text(
                  '註冊',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.5, // 調整按鍵位置向上
            left: screenWidth * 0.22,
            child: SizedBox(
              width: screenWidth * 0.55,
              height: screenHeight * 0.09, // 縮小按鍵高度
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(165, 146, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                onPressed: () {
                  // 點擊跳轉到 LoginWidget
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWidget(),
                    ),
                  );
                },
                child: const Text(
                  '登入',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * -0.01,
            left: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.4, // 縮小圖片高度
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Main.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
