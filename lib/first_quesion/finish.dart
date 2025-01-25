import 'package:flutter/material.dart';

class FinishWidget extends StatelessWidget {
  const FinishWidget({super.key});

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
            // 問卷結束背景框
            Positioned(
              top: 305,
              left: 71,
              child: Container(
                width: 270,
                height: 220,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            // 問卷結束文字
            const Positioned(
              top: 369,
              left: 104,
              child: Text(
                '問卷結束!謝謝填答',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            // 下一步按鈕
            Positioned(
              top: 438,
              left: 143,
              child: SizedBox(
                width: 125,
                height: 47,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
                  ),
                  onPressed: () {
                    // 跳轉到下一頁，請根據實際需要修改頁面
                    Navigator.pushNamed(context, '/Home_screenWidget');
                  },
                  child: const Text(
                    '下一步',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.36),
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      height: 1,
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
