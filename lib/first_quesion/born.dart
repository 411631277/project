import 'package:doctor_2/first_quesion/notyet1.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BornWidget extends StatelessWidget {
  const BornWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 412,
        height: 917,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 334,
              left: 133,
              child: SizedBox(
                width: 147,
                height: 51,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notyet1Widget(),
                      ),
                    );
                  },
                  child: const Text(
                    '還沒',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 433,
              left: 133,
              child: SizedBox(
                width: 147,
                height: 51,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  onPressed: () {
                    // TODO: 處理 "出生了" 按鈕邏輯Notyet1Widget
                  },
                  child: const Text(
                    '出生了',
                    style: TextStyle(
                      color: Color.fromRGBO(147, 129, 108, 1),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 229,
              left: 62,
              child: Text(
                '請問寶寶出生了嗎?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 776,
              left: 124,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: 179.80448080946567 * (math.pi / 180),
                  child: Container(
                    width: 61,
                    height: 65.25581359863281,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Back.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
