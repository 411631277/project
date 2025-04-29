import 'package:doctor_2/home/delete2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class DeleteWidget extends StatelessWidget {
  final String userId; // ✅ 從上一頁傳入 userId
  final bool isManUser;
  final void Function(int) updateStepCount;
  const DeleteWidget({
    super.key,
    required this.userId,
    required this.updateStepCount, required this.isManUser,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
 canPop: false,
 child: Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '您要刪除帳號嗎?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(
                          context,
                          '是',
                          const Color.fromARGB(255, 176, 148, 147),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Delete2Widget(
                                  userId: userId,
                                  isManUser: isManUser,

                                  updateStepCount: updateStepCount, // ✅ 傳遞更新函式
                                ),
                              ),
                            );
                          },
                        ),
                        _buildButton(context, '否', Colors.grey.shade400, () {
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // **按鈕樣式**
  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
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
