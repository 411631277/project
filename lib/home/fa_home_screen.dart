import 'dart:io';
import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/robot.dart';
import 'package:doctor_2/home/setting.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class FaHomeScreenWidget extends StatefulWidget {
  final String userId; // 從登入或註冊時傳入的 userId
  final bool isManUser;
  final Function(int) updateStepCount;

  const FaHomeScreenWidget({
    super.key,
    required this.userId,
    required this.isManUser,
    required this.updateStepCount,
  });

  @override
  State<FaHomeScreenWidget> createState() => _FaHomeScreenWidgetState();
}

class _FaHomeScreenWidgetState extends State<FaHomeScreenWidget> {
  String userName = "載入中...";
  String babyName = "小寶";
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadBabyName();
    _loadProfilePicture();
  }

  /// 讀取 Firebase Storage 內的圖片
  Future<void> _loadProfilePicture() async {
    try {
      String userType = widget.isManUser ? 'man_users' : 'users';
      String downloadUrl = await FirebaseStorage.instance
          .ref('profile_pictures/$userType/${widget.userId}.jpg')
          .getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      logger.e("❌ 無法載入圖片: $e");
      setState(() {
        _profileImageUrl = null;
      });
    }
  }

  /// 選擇圖片並上傳
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // 使用者取消選擇

    try {
      File file = File(image.path);
      String userType = widget.isManUser ? 'man_users' : 'users';
      String filePath = 'profile_pictures/$userType/${widget.userId}.jpg';

      // 上傳到 Firebase Storage
      await FirebaseStorage.instance.ref(filePath).putFile(file);

      // 重新載入圖片
      _loadProfilePicture();
      logger.i("✅ 圖片上傳成功");
    } catch (e) {
      logger.e("❌ 上傳圖片失敗: $e");
    }
  }

  /// 顯示預覽大頭貼對話框
  void _showProfilePreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // 點擊對話框外部可關閉
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // 對話框背景透明
          insetPadding: const EdgeInsets.all(10), // 可調整預覽視窗邊距
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // 點擊背景關閉
            child: Container(
              color: Colors.black54, // 半透明背景
              child: Center(
                child: GestureDetector(
                  // 阻擋往外層的 onTap，避免按到預覽區域就關閉
                  onTap: () {},
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 預覽大頭貼
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (_profileImageUrl != null)
                              ? Image.network(
                                  _profileImageUrl!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/man.png',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // 更換大頭貼按鈕
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // 關閉預覽視窗後，再執行選圖流程
                            _pickAndUploadImage();
                          },
                          child: const Text("更換大頭貼"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Man_users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['名字'] ?? '未知用戶';
        });
      }
    } catch (e) {
      logger.e("❌ 讀取使用者名稱失敗: $e");
    }
  }

  Future<void> _loadBabyName() async {
    try {
      QuerySnapshot babySnapshot = await FirebaseFirestore.instance
          .collection('Man_users')
          .doc(widget.userId)
          .collection('baby')
          .orderBy('填寫時間', descending: true)
          .get();

      if (babySnapshot.docs.isNotEmpty) {
        setState(() {
          babyName = babySnapshot.docs.first.id;
        });
      } else {
        setState(() {
          babyName = "小寶";
        });
      }
    } catch (e) {
      logger.e("❌ 讀取寶寶名稱失敗: $e");
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
            // 🔹 頭像：改為點擊預覽，而非直接更換
            Positioned(
              top: screenHeight * 0.03,
              left: screenWidth * 0.07,
              child: GestureDetector(
                onTap: () => _showProfilePreviewDialog(),
                child: Container(
                  width: screenWidth * 0.20,
                  height: screenHeight * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : const AssetImage('assets/images/man.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
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
                        isManUser: true,
                        stepCount: 0,
                        updateStepCount: (steps) {},
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
              left: screenWidth * 0.08,
              child: SizedBox(
                width: screenWidth * 0.84,
                child: Text(
                  '當爸爸不容易，但你的陪伴與支持，'
                  '對伴侶來說是無可取代的力量。\n\n'
                  '每一次的擁抱、每一句溫暖的話語，都是她最堅強的後盾。\n\n'
                  '你不需要完美，只要願意一起面對，一起學習，一起成長，這就是最好的愛。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: screenWidth * 0.05,
                  ),
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
                      builder: (context) =>
                          BabyWidget(userId: widget.userId, isManUser: true),
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
                ),
              ),
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
              top: screenHeight * 0.82,
              left: screenWidth * 0.8,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RobotWidget(
                        userId: widget.userId,
                        isManUser: true,
                      ),
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

            // 需要協助嗎 區塊
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
