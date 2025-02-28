import 'dart:io';

import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/bluetooth.dart';
import 'package:doctor_2/home/question.dart';
import 'package:doctor_2/home/robot.dart';
import 'package:doctor_2/home/setting.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class HomeScreenWidget extends StatefulWidget {
  final String userId; // 🔹 從登入或註冊時傳入的 userId
  final bool isManUser;
  const HomeScreenWidget(
      {super.key, required this.userId, required this.isManUser});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

// ignore: camel_case_types
class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  String userName = "載入中..."; // 預設文字，等待從 Firebase 讀取
  String babyName = "小寶";
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadBabyName();
    _loadProfilePicture(); // 🔹 初始化時讀取使用者名稱
  }

  /// **🔹 讀取 Firebase Storage 內的圖片**
  Future<void> _loadProfilePicture() async {
    try {
      String downloadUrl = await FirebaseStorage.instance
          .ref('profile_pictures/${widget.userId}.jpg')
          .getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      // 如果 Firebase Storage 找不到圖片，則使用預設圖片
      logger.e("❌ 無法載入圖片，使用預設圖片: $e");
      setState(() {
        _profileImageUrl = null; // 設為 null，這樣 UI 會載入 `picture.png`
      });
    }
  }

  /// **🔹 選擇圖片並上傳**
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // 使用者取消選擇

    try {
      File file = File(image.path);
      String filePath = 'profile_pictures/${widget.userId}.jpg';

      // **🔹 上傳到 Firebase Storage**
      await FirebaseStorage.instance.ref(filePath).putFile(file);

      // **🔹 重新載入圖片**
      _loadProfilePicture();
      logger.i("✅ 圖片上傳成功");
    } catch (e) {
      logger.e("❌ 上傳圖片失敗: $e");
    }
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
  // 讀取最後輸入的寶寶名稱
  Future<void> _loadBabyName() async {
    try {
      QuerySnapshot babySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('baby')
          .orderBy('填寫時間', descending: true) // 按照建立時間排序，最新的在最前
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
            color: const Color.fromRGBO(233, 227, 213, 1),
            child: Stack(
              children: <Widget>[
                // 🔹 點擊切換圖片
                Positioned(
                  top: screenHeight * 0.03,
                  left: screenWidth * 0.07,
                  child: GestureDetector(
                    onTap: _pickAndUploadImage, // 點擊更換圖片
                    child: Container(
                      width: screenWidth * 0.20, // 調整為長方形
                      height: screenHeight * 0.12, // 調整為長方形
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // 保留微圓角，讓圖片更美觀
                        image: DecorationImage(
                          image: _profileImageUrl != null
                              ? NetworkImage(
                                  _profileImageUrl!) // 使用 Firebase Storage 讀取的圖片
                              : const AssetImage('assets/images/Picture.png')
                                  as ImageProvider,
                          fit: BoxFit.cover, // 確保圖片填滿但不變形
                        ),
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
                          builder: (context) => SettingWidget(
                            userId: widget.userId,
                            isManUser: false,
                          ),
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
                Positioned(
                  top: screenHeight * 0.3,
                  left: screenWidth * 0.08,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BluetoothWidget(),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.13,
                        height: screenHeight * 0.08,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bluetooth.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )),
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
                            builder: (context) => BabyWidget(
                                userId: widget.userId, isManUser: false),
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
                          Radius.elliptical(
                              screenWidth * 0.4, screenHeight * 0.06),
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
            )));
  }
}
