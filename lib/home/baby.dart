import 'package:flutter/material.dart';

class BabyWidget extends StatelessWidget {
  const BabyWidget({super.key});

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
            // **寶寶圖示**
            Positioned(
              top: screenHeight * 0.12,
              left: screenWidth * 0.08,
              child: Image.asset(
                'assets/images/baby.png',
                width: screenWidth * 0.15,
              ),
            ),

            // **姓名**
            _buildLabel(screenWidth, screenHeight * 0.15, '姓名'),
            _buildTextField(screenWidth, screenHeight * 0.15),

            // **生日**
            _buildLabel(screenWidth, screenHeight * 0.22, '生日'),
            _buildTextField(screenWidth, screenHeight * 0.22),

            // **性別**
            _buildLabel(screenWidth, screenHeight * 0.29, '性別'),
            _buildTextField(screenWidth, screenHeight * 0.29),

            // **出生體重**
            _buildLabel(screenWidth, screenHeight * 0.36, '出生體重'),
            _buildTextField(screenWidth, screenHeight * 0.36),

            // **出生身高**
            _buildLabel(screenWidth, screenHeight * 0.43, '出生身高'),
            _buildTextField(screenWidth, screenHeight * 0.43),

            // **寶寶特殊狀況**
            _buildLabel(screenWidth * 0.40, screenHeight * 0.50, '寶寶出生時有無特殊狀況'),

            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.2,
              child: Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  const Text(
                    '無',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1)),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  const Text(
                    '有',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1)),
                  ),
                ],
              ),
            ),

            // **輸入框**
            Positioned(
              top: screenHeight * 0.60,
              left: screenWidth * 0.15,
              child: _buildLargeTextField(screenWidth * 0.7),
            ),

            // **填寫完成按鈕**
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.3,
              child: _buildButton(context, '填寫完成', Colors.brown.shade400, () {
                Navigator.pushNamed(context, '/BabyAccWidget'); // 這裡請換成你的跳轉頁面
              }),
            ),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.85,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, size: 40, color: Colors.brown),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **標籤 Widget**
  Widget _buildLabel(double screenWidth, double top, String text) {
    return Positioned(
      top: top,
      left: screenWidth * 0.25,
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromRGBO(147, 129, 108, 1),
          fontSize: 20,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  // **輸入框 Widget**
  Widget _buildTextField(double screenWidth, double top) {
    return Positioned(
      top: top,
      left: screenWidth * 0.53,
      child: SizedBox(
        width: screenWidth * 0.4,
        height: 32,
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

  // **較大的輸入框**
  Widget _buildLargeTextField(double width) {
    return SizedBox(
      width: width,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
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
