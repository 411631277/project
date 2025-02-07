import 'package:flutter/material.dart';

class BabyAccWidget extends StatelessWidget {
  const BabyAccWidget({super.key});

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
            // **背景框**
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.18,
              child: Container(
                width: screenWidth * 0.65,
                height: screenHeight * 0.18,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  borderRadius: BorderRadius.circular(10), // 圓角
                ),
              ),
            ),

            // **成功訊息**
            Positioned(
              top: screenHeight * 0.40,
              left: screenWidth * 0.27,
              child: const Text(
                '寶寶資料創建成功',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.3,
              child: _buildButton(context, '返回', Colors.brown.shade400, () {
                Navigator.pushNamed(context, '/HomeScreenWidget'); // 跳轉到主畫面
              }),
            ),
          ],
        ),
      ),
    );
  }

  // **按鈕 Widget**
  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 40,
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
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
