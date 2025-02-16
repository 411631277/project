import 'package:doctor_2/agree.dart';
import 'package:doctor_2/login/login.dart';
import 'package:flutter/material.dart';

//註解已完成

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({super.key});

  // 使用 MediaQuery 提供自適應螢幕的比例
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
        child: Stack(children: <Widget>[
          //按鍵位置
          Positioned(
            top: screenHeight * 0.68,
            left: screenWidth * 0.22,
            child: SizedBox(
              width: screenWidth * 0.55,
              height: screenHeight * 0.09,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(165, 146, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    // 點擊跳轉到同意書頁面
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
          // 按鍵位置
          Positioned(
            top: screenHeight * 0.5,
            left: screenWidth * 0.22,
            child: SizedBox(
              width: screenWidth * 0.55,
              height: screenHeight * 0.09,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(165, 146, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWidget(), // 點擊跳轉到登入頁面
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
          // 圖片設定
          Positioned(
            top: screenHeight * -0.01,
            left: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.4,
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
