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
              top: screenHeight * 0.05,
              left: screenWidth * 0.37,
              child: Container(
                width: screenWidth * 0.2,
                height: screenHeight * 0.08,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/data.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            // **姓名與生日**
            _buildLabel(screenWidth, screenHeight * 0.15, 0.05, '姓名'),
            _buildLabel(screenWidth, screenHeight * 0.15, 0.55, '生日'),
            _buildTextField(screenWidth, screenHeight * 0.19, 0.05, 0.4),
            _buildTextField(screenWidth, screenHeight * 0.19, 0.55, 0.4),

            // **血型、身高與體重**
            _buildLabel(screenWidth, screenHeight * 0.25, 0.05, '血型'),
            _buildLabel(screenWidth, screenHeight * 0.25, 0.4, '身高'),
            _buildLabel(screenWidth, screenHeight * 0.25, 0.7, '體重'),
            _buildTextField(screenWidth, screenHeight * 0.29, 0.05, 0.25),
            _buildTextField(screenWidth, screenHeight * 0.29, 0.4, 0.25),
            _buildTextField(screenWidth, screenHeight * 0.29, 0.7, 0.25),

            // **住址**
            _buildLabel(screenWidth, screenHeight * 0.35, 0.05, '住址'),
            _buildTextField(screenWidth, screenHeight * 0.39, 0.05, 0.85),

            // **緊急聯絡人**
            _buildLabel(screenWidth, screenHeight * 0.46, 0.05, '緊急聯絡人'),

            // **聯絡人 1**
            _buildLabel(screenWidth, screenHeight * 0.50, 0.05, '姓名'),
            _buildLabel(screenWidth, screenHeight * 0.50, 0.55, '姓名'),
            _buildTextField(screenWidth, screenHeight * 0.54, 0.05, 0.4),
            _buildTextField(screenWidth, screenHeight * 0.54, 0.55, 0.4),

            _buildLabel(screenWidth, screenHeight * 0.60, 0.05, '關係'),
            _buildLabel(screenWidth, screenHeight * 0.60, 0.55, '關係'),
            _buildTextField(screenWidth, screenHeight * 0.64, 0.05, 0.4),
            _buildTextField(screenWidth, screenHeight * 0.64, 0.55, 0.4),

            _buildLabel(screenWidth, screenHeight * 0.70, 0.05, '電話'),
            _buildLabel(screenWidth, screenHeight * 0.70, 0.55, '電話'),
            _buildTextField(screenWidth, screenHeight * 0.74, 0.05, 0.4),
            _buildTextField(screenWidth, screenHeight * 0.74, 0.55, 0.4),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Transform.rotate(
                  angle: 180 * (math.pi / 180),
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // **刪除帳號 & 修改確認按鈕（直向排列 + 字體縮小）**
            Positioned(
              top: screenHeight * 0.80,
              left: screenWidth * 0.55,
              child: Column(
                children: [
                  _buildButton('刪除帳號', Colors.grey.shade400, () {
                    Navigator.pushNamed(context, '/DeleteWidget'); // 刪除帳號邏輯
                  }),
                  const SizedBox(height: 10), // 按鈕間距
                  _buildButton('修改確認', Colors.grey.shade400, () {
                    Navigator.pushNamed(context, '/ReviseWidget'); // 修改確認邏輯
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **標籤 Widget**
  Widget _buildLabel(double screenWidth, double top, double left, String text) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: Text(
        text,
        style: TextStyle(
          color: const Color.fromRGBO(147, 129, 108, 1),
          fontFamily: 'Inter',
          fontSize: screenWidth * 0.04, // 字體稍微小一點
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  // **輸入框 Widget**
  Widget _buildTextField(
      double screenWidth, double top, double left, double widthFactor) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: SizedBox(
        width: screenWidth * widthFactor,
        height: 35,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  // **按鈕 Widget**
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 120, // 按鈕寬度
      height: 40, // 按鈕高度
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14, // 字體縮小
          ),
        ),
      ),
    );
  }
}
