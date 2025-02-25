import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MateWidget extends StatefulWidget {
  final String userId; // 🔹 從上一頁傳來的 userId

  const MateWidget({super.key, required this.userId});

  @override
  State<MateWidget> createState() => _MateWidgetState();
}

class _MateWidgetState extends State<MateWidget> {
  String pairingCode = "載入中..."; // 預設顯示狀態

  @override
  void initState() {
    super.initState();
    fetchPairingCode(); // 🔹 讀取配對碼
  }

  // 🔹 從 Firebase Firestore 獲取配對碼
  Future<void> fetchPairingCode() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          pairingCode = userDoc['配對碼'] ?? "未設定"; // 🔹 如果沒有配對碼，顯示「未設定」
        });
      } else {
        setState(() {
          pairingCode = "無效的用戶";
        });
      }
    } catch (e) {
      setState(() {
        pairingCode = "載入錯誤";
      });
      logger.e("❌ 讀取配對碼錯誤: $e");
    }
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
            // 圖示
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.25,
                height: screenHeight * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pregnancy.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 標題文字
            Positioned(
              top: screenHeight * 0.13,
              left: screenWidth * 0.38,
              child: Text(
                '配偶分享碼',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 配偶分享碼文字
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.1,
              child: Text(
                '配偶分享碼',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // 分享碼背景框
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.42,
              child: Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.04,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Center(
                  child: Text(
                    pairingCode, // 🔹 顯示 Firebase 讀取的配對碼
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(147, 129, 108, 1),
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // 返回按鈕
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
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
}
