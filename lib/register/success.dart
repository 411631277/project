import 'package:doctor_2/first_quesion/born.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key});

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
            // 標題文字
            const Positioned(
              top: 200,
              left: 18,
              child: Text(
                '帳號創建成功!!!\n為了理解使用者目前狀況\n請填寫以下問卷',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inter',
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  height: 1.5, // 調整行高
                ),
              ),
            ),
            // 下一步按鈕的背景框
            Positioned(
              top: 514,
              left: 124,
              child: Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(147, 129, 108, 0.5), // 替代SVG的顏色
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // 下一步文字
            Positioned(
              top: 518,
              left: 167,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BornWidget(),
                    ),
                  );
                },
                child: Text('下一步',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ),
            // 返回按鈕的圖示(最後發布時拿除)
            Positioned(
              top: 776.1,
              left: 124,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: 179.80448080946567 * (math.pi / 180),
                  child: Container(
                    width: 57,
                    height: 61,
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
