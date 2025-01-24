import 'package:flutter/material.dart';
import 'dart:math' as math;

class PhoneWidget extends StatelessWidget {
  const PhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 412,
      height: 917,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(233, 227, 213, 1),
      ),
      child: Stack(
        children: <Widget>[
          // 標題 "院內電話查詢"
          const Positioned(
            top: 103,
            left: 132,
            child: Text(
              '院內電話查詢',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 30,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          // "語音預約掛號"
          const Positioned(
            top: 205,
            left: 146,
            child: Text(
              '語音預約掛號',
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          const Positioned(
            top: 245, // 高度差 40
            left: 139,
            child: Text(
              '(02)87927111',
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          // "人工預約掛號"
          const Positioned(
            top: 325, // 隔 80
            left: 146,
            child: Text(
              '人工預約掛號',
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          const Positioned(
            top: 365, // 高度差 40
            left: 139,
            child: Text(
              '(02)87927222',
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          // "三總產後病房電話"
          const Positioned(
            top: 445, // 隔 80
            left: 123,
            child: Text(
              '三總產後病房電話',
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          const Positioned(
            top: 485, // 高度差 40
            left: 100,
            child: Text(
              '(02)8792-3100#55000',
              style: TextStyle(
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          // 圖示 (電話圖案)
          Positioned(
            top: 97,
            left: 49,
            child: Container(
              width: 42,
              height: 48,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/phone.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          // 返回按鈕
          Positioned(
            top: 733,
            left: 109,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // 返回上一頁
              },
              child: Transform.rotate(
                angle: -178.41630656524814 * (math.pi / 180),
                child: Container(
                  width: 58.74,
                  height: 62.83,
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
    );
  }
}
