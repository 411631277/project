import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MateWidget extends StatefulWidget {
  final String userId; // 🔹 從上一頁傳來的 userId
  final bool isManUser;
  const MateWidget({super.key, required this.userId ,  required this.isManUser});

  @override
  State<MateWidget> createState() => _MateWidgetState();
}

class _MateWidgetState extends State<MateWidget> {
  String pairingCode = "載入中..."; // 預設顯示
  bool isPairingUsed = false; // **配對碼是否已使用**

  @override
  void initState() {
    super.initState();
    fetchPairingCode(); // 🔹 讀取配對碼
  }

  // **🔹 從 Firebase 讀取配對碼與使用狀態**
 Future<void> fetchPairingCode() async {
  try {
    // 選擇正確的 Firebase Collection
    final collectionName = widget.isManUser ? "Man_users" : "users";
    
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        pairingCode = userDoc['配對碼'] ?? "未設定";
        
        // 🔍 檢查是否已使用
        isPairingUsed = userDoc.data().toString().contains('配對碼已使用')
            ? (userDoc['配對碼已使用'] ?? false)
            : false;

        // 🔹 顯示的邏輯調整
        if (widget.isManUser) {
          isPairingUsed = userDoc['配對成功'] ?? false;
          pairingCode = isPairingUsed ? "已配對" : "未配對";
        } else {
          // 🔍 判斷媽媽是否配對成功
          isPairingUsed = userDoc['配對碼已使用'] ?? false;
          if (isPairingUsed) {
            pairingCode = "已配對";
          }
        }
      });
    } else {
      setState(() {
        pairingCode = "無效的用戶";
      });
    }
  } catch (e) {
    setState(() {
      pairingCode = "讀取錯誤";
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
            // 配偶分享碼標籤
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
            // **配對碼顯示區塊**
          Positioned(
  top: screenHeight * 0.35,
  left: screenWidth * 0.42,
  child: Container(
    width: screenWidth * 0.4,
    height: screenHeight * 0.04,
    decoration: BoxDecoration(
      color: isPairingUsed ? Colors.red[100] : Colors.white,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Text(
        pairingCode, // 🔹 直接顯示修改後的配對碼或狀態
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isPairingUsed
              ? Colors.red
              : const Color.fromRGBO(147, 129, 108, 1),
          fontFamily: 'Poppins',
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
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
