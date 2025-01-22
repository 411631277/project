/* ignore: file_names
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DetaWidget extends StatelessWidget {
  const DetaWidget({super.key});

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
            // 圖示
            Positioned(
              top: 56,
              left: 152,
              child: Container(
                width: 100,
                height: 84,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/5.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 姓名與生日
            const Positioned(
              top: 192,
              left: 17,
              child: Text(
                '姓名',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Positioned(
              top: 192,
              left: 224,
              child: Text(
                '生日',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 192,
              left: 87,
              child: Container(
                width: 102,
                height: 32,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            Positioned(
              top: 192,
              left: 298,
              child: Container(
                width: 102,
                height: 32,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            // 血型、身高與體重
            const Positioned(
              top: 246,
              left: 17,
              child: Text(
                '血型',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 246,
              left: 75,
              child: Container(
                width: 57,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 246,
              left: 144,
              child: Text(
                '身高',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 246,
              left: 202,
              child: Container(
                width: 56,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 246,
              left: 276,
              child: Text(
                '體重',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 246,
              left: 344,
              child: Container(
                width: 57,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            // 緊急聯絡人區域
            const Positioned(
              top: 354,
              left: 17,
              child: Text(
                '緊急聯絡人',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 姓名、關係與電話
            const Positioned(
              top: 405,
              left: 17,
              child: Text(
                '姓名',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 410,
              left: 80,
              child: Container(
                width: 119,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 461,
              left: 17,
              child: Text(
                '關係',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 461,
              left: 80,
              child: Container(
                width: 119,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 515,
              left: 17,
              child: Text(
                '電話',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 517,
              left: 80,
              child: Container(
                width: 119,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 410,
              left: 219,
              child: Text(
                '姓名',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 410,
              left: 283,
              child: Container(
                width: 119,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 461,
              left: 219,
              child: Text(
                '關係',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 461,
              left: 283,
              child: Container(
                width: 119,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
            const Positioned(
              top: 515,
              left: 219,
              child: Text(
                '電話',
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: 517,
              left: 283,
              child: Container(
                width: 119,
                height: 31,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.black),
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
                  angle: -179.7534073506047 * (math.pi / 180),
                  child: Container(
                    width: 58,
                    height: 61,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/7.png'),
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
}  */
