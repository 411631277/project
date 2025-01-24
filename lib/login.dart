import 'package:doctor_2/forget.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
            // 帳號標籤
            const Positioned(
              top: 205,
              left: 178,
              child: Text(
                '帳號',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 帳號輸入框
            Positioned(
              top: 260,
              left: 54,
              child: SizedBox(
                width: 303,
                height: 36,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // 密碼標籤
            const Positioned(
              top: 370,
              left: 178,
              child: Text(
                '密碼',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 密碼輸入框
            Positioned(
              top: 425,
              left: 54,
              child: SizedBox(
                width: 303,
                height: 36,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            // 下一步按鈕
            Positioned(
              top: 559,
              left: 86,
              child: SizedBox(
                width: 240,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // 下一步按鈕功能
                  },
                  child: const Text(
                    '下一步',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            // 返回按鈕
            Positioned(
              top: 645,
              left: 86,
              child: SizedBox(
                width: 240,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // 返回上一頁
                  },
                  child: const Text(
                    '返回',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            // 忘記密碼按鈕
            Positioned(
              top: 720,
              left: 86,
              child: SizedBox(
                width: 232,
                height: 38,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // 忘記密碼功能
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetWidget(),
                        ),
                      );
                    },
                    child: const Text('忘記密碼',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.54),
                          fontSize: 24,
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
