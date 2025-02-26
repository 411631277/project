import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/register/fa_register.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class InputcodeWidget extends StatefulWidget {
  const InputcodeWidget({super.key, required String role});

  @override
  State<InputcodeWidget> createState() => _InputcodeWidgetState();
}

class _InputcodeWidgetState extends State<InputcodeWidget> {
  late TextEditingController pairingCodeController;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    pairingCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pairingCodeController.dispose();
    super.dispose();
  }

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
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.20,
              child: Text(
                '請輸入配偶的配對碼',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // **輸入框**
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: TextField(
                controller: pairingCodeController,
                decoration: InputDecoration(
                  hintText: '配對碼',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),
            // **錯誤訊息顯示**
            Positioned(
              top: screenHeight * 0.50,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            // **下一步按鈕**
            Positioned(
              top: screenHeight * 0.7,
              left: screenWidth * 0.3,
              child: SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await verifyPairingCode();
                  },
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                ),
              ),
            ),
            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
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
      ),
    );
  }

  // **檢查輸入的配對碼是否正確**
  Future<void> verifyPairingCode() async {
    final inputCode = pairingCodeController.text.trim();

    if (inputCode.isEmpty) {
      setState(() {
        errorMessage = "請輸入配對碼";
      });
      return;
    }

    try {
      // **搜尋 Firestore，檢查是否有配對碼相符的用戶**
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('配對碼', isEqualTo: inputCode)
          .where('配對碼已使用', isEqualTo: false) // 只檢查未使用的配對碼
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.i("✅ 配對碼正確，進入註冊頁面");

        if (context.mounted) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FaRegisterWidget(
                pairingCode: inputCode,
                role: '爸爸',
              ), // 🟢 傳遞配對碼
            ),
          );
        }
      } else {
        setState(() {
          errorMessage = "配對碼錯誤或已被使用，請重新輸入";
        });
        logger.e("❌ 配對碼錯誤或已被使用");
      }
    } catch (e) {
      setState(() {
        errorMessage = "驗證錯誤，請稍後再試";
      });
      logger.e("❌ Firestore 查詢錯誤: $e");
    }
  }
}
