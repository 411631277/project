import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/question.dart';
import 'package:doctor_2/home/robot.dart';
import 'package:doctor_2/home/setting.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class HomeScreenWidget extends StatefulWidget {
  final String userId; // 🔹 從登入或註冊時傳入的 userId
  const HomeScreenWidget({super.key, required this.userId});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

// ignore: camel_case_types
class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  String userName = "載入中..."; // 預設文字，等待從 Firebase 讀取
  String babyName = "小寶";

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadBabyName(); // 🔹 初始化時讀取使用者名稱
  }

  Future<void> _loadUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['名字'] ?? '未知用戶'; // 🔹 讀取 Firestore 的名字欄位
        });
      }
    } catch (e) {
      logger.e("❌ 錯誤：讀取使用者名稱失敗 $e");
    }
  }

  // 讀取最後輸入的寶寶名稱
  Future<void> _loadBabyName() async {
    try {
      QuerySnapshot babySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('baby')
          .orderBy('createdAt', descending: true) // 按照建立時間排序，最新的在最前
          .get();

      if (babySnapshot.docs.isNotEmpty) {
        setState(() {
          babyName = babySnapshot.docs.first.id; // 🔹 使用最新的寶寶名字
        });
      } else {
        setState(() {
          babyName = "小寶"; // 若沒有寶寶資料，顯示預設值
        });
      }
    } catch (e) {
      logger.e("❌ 錯誤：讀取寶寶名稱失敗 $e");
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
            // Picture 照片
            Positioned(
              top: screenHeight * 0.03,
              left: screenWidth * 0.07,
              child: Container(
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Picture.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // 設定按鈕
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.77,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingWidget(),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.08,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Setting.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            // 問題按鈕
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.6,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionWidget(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.12,
                  height: screenHeight * 0.08,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Question.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            // 用戶名稱
            Positioned(
              top: screenHeight * 0.07,
              left: screenWidth * 0.32,
              child: Text(
                userName,
                style: TextStyle(
                  color: const Color.fromRGBO(165, 146, 125, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
            // 今日心情文字
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.1,
              child: Text(
                '今天心情還好嗎?一切都會越來越好喔!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(165, 146, 125, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
            // 今日步數區塊
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.05,
              child: Text(
                '今日步數',
                style: TextStyle(
                  color: const Color.fromRGBO(165, 146, 125, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.49,
              left: screenWidth * 0.05,
              child: Text(
                '步數未達標!',
                style: TextStyle(
                  color: const Color.fromRGBO(165, 146, 125, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.5,
              child: Text(
                '昨日步數',
                style: TextStyle(
                  color: const Color.fromRGBO(165, 146, 125, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.41,
              left: screenWidth * 0.35,
              child: Divider(
                color: const Color.fromRGBO(147, 129, 108, 1),
                thickness: 1,
              ),
            ),
            // 今日步數數值
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.3,
              child: Text(
                '8623',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            // 昨日步數數值
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.75,
              child: Text(
                '8380',
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
            // Baby 圖片
            Positioned(
              top: screenHeight * 0.70,
              left: screenWidth * 0.08,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BabyWidget(userId: widget.userId),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.13,
                    height: screenHeight * 0.08,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Baby.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  )),
            ),
            // 小寶文字
            Positioned(
              top: screenHeight * 0.72,
              left: screenWidth * 0.25,
              child: Text(
                babyName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(165, 146, 125, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ),
            // Robot 圖片
            Positioned(
              top: screenHeight * 0.85,
              left: screenWidth * 0.8,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RobotWidget(),
                    ),
                  );
                },
                child: Container(
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Robot.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            // 需要協助嗎區塊
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.43,
              child: Transform.rotate(
                angle: -5.56 * (math.pi / 180),
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(165, 146, 125, 1),
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(screenWidth * 0.4, screenHeight * 0.06),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.82,
              left: screenWidth * 0.48,
              child: Text(
                '需要協助嗎?',
                style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
