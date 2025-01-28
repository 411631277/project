import 'package:flutter/material.dart';
import 'dart:math' as math;

class DetaWidget extends StatelessWidget {
  const DetaWidget({super.key});

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
            // 圖示
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.37,
              child: Container(
                width: screenWidth * 0.24,
                height: screenHeight * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/5.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // 姓名與生日
            Positioned(
              top: screenHeight * 0.21,
              left: screenWidth * 0.05,
              child: _buildLabel('姓名'),
            ),
            Positioned(
              top: screenHeight * 0.21,
              left: screenWidth * 0.55,
              child: _buildLabel('生日'),
            ),
            Positioned(
              top: screenHeight * 0.21,
              left: screenWidth * 0.2,
              child: _buildTextField(width: screenWidth * 0.3),
            ),
            Positioned(
              top: screenHeight * 0.21,
              left: screenWidth * 0.7,
              child: _buildTextField(width: screenWidth * 0.3),
            ),
            // 血型、身高與體重
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.05,
              child: _buildLabel('血型'),
            ),
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.2,
              child: _buildTextField(width: screenWidth * 0.2),
            ),
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.45,
              child: _buildLabel('身高'),
            ),
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.6,
              child: _buildTextField(width: screenWidth * 0.2),
            ),
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.8,
              child: _buildLabel('體重'),
            ),
            Positioned(
              top: screenHeight * 0.27,
              left: screenWidth * 0.9,
              child: _buildTextField(width: screenWidth * 0.2),
            ),
            // 緊急聯絡人區域
            Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.05,
              child: _buildLabel('緊急聯絡人'),
            ),
            // 緊急聯絡人：姓名、關係與電話
            _buildEmergencyContactRow(
              top: screenHeight * 0.43,
              left1: screenWidth * 0.05,
              left2: screenWidth * 0.55,
            ),
            // 返回按鈕
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.4,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.1,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/7.png'),
                        fit: BoxFit.contain,
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

  // 共用的文字標籤方法
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromRGBO(147, 129, 108, 1),
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  // 共用的輸入框方法
  Widget _buildTextField({double width = 100}) {
    return SizedBox(
      width: width,
      height: 32,
      child: TextField(
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // 緊急聯絡人區域建構
  Widget _buildEmergencyContactRow({
    required double top,
    required double left1,
    required double left2,
  }) {
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left1,
          child: _buildLabel('姓名'),
        ),
        Positioned(
          top: top + 30,
          left: left1,
          child: _buildTextField(width: 150),
        ),
        Positioned(
          top: top + 70,
          left: left1,
          child: _buildLabel('關係'),
        ),
        Positioned(
          top: top + 100,
          left: left1,
          child: _buildTextField(width: 150),
        ),
        Positioned(
          top: top,
          left: left2,
          child: _buildLabel('姓名'),
        ),
        Positioned(
          top: top + 30,
          left: left2,
          child: _buildTextField(width: 150),
        ),
        Positioned(
          top: top + 70,
          left: left2,
          child: _buildLabel('關係'),
        ),
        Positioned(
          top: top + 100,
          left: left2,
          child: _buildTextField(width: 150),
        ),
      ],
    );
  }
}
