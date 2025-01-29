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
            // **圖示**
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.37,
              child: Container(
                width: screenWidth * 0.24,
                height: screenHeight * 0.09,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/5.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            // **姓名與生日**
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.05,
              child: _buildLabel('姓名', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.55,
              child: _buildLabel('生日', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.23,
              left: screenWidth * 0.2,
              child: _buildTextField(screenWidth * 0.3),
            ),
            Positioned(
              top: screenHeight * 0.23,
              left: screenWidth * 0.7,
              child: _buildTextField(screenWidth * 0.3),
            ),

            // **血型、身高與體重**
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.05,
              child: _buildLabel('血型', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.2,
              child: _buildTextField(screenWidth * 0.15),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.4,
              child: _buildLabel('身高', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.55,
              child: _buildTextField(screenWidth * 0.15),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.7,
              child: _buildLabel('體重', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.28,
              left: screenWidth * 0.85,
              child: _buildTextField(screenWidth * 0.15),
            ),

            // **緊急聯絡人**
            Positioned(
              top: screenHeight * 0.38,
              left: screenWidth * 0.05,
              child: _buildLabel('緊急聯絡人', screenWidth),
            ),

            // **聯絡人 1**
            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.05,
              child: _buildLabel('姓名', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.2,
              child: _buildTextField(screenWidth * 0.3),
            ),
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.05,
              child: _buildLabel('關係', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.2,
              child: _buildTextField(screenWidth * 0.3),
            ),
            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.05,
              child: _buildLabel('電話', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.2,
              child: _buildTextField(screenWidth * 0.3),
            ),

            // **聯絡人 2**
            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.55,
              child: _buildLabel('姓名', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.42,
              left: screenWidth * 0.7,
              child: _buildTextField(screenWidth * 0.3),
            ),
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.55,
              child: _buildLabel('關係', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.7,
              child: _buildTextField(screenWidth * 0.3),
            ),
            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.55,
              child: _buildLabel('電話', screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.7,
              child: _buildTextField(screenWidth * 0.3),
            ),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.3,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Transform.rotate(
                  angle: -179.7534073506047 * (math.pi / 180),
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.08,
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

  // **標籤 Widget**
  Widget _buildLabel(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        color: const Color.fromRGBO(147, 129, 108, 1),
        fontFamily: 'Inter',
        fontSize: screenWidth * 0.05,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  // **輸入框 Widget**
  Widget _buildTextField(double width) {
    return SizedBox(
      width: width,
      height: 32,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
