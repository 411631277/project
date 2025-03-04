import 'dart:io';
import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/question.dart';
import 'package:doctor_2/home/robot.dart';
import 'package:doctor_2/home/setting.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

final Logger logger = Logger();

class HomeScreenWidget extends StatefulWidget {
  final String userId; // 從登入或註冊時傳入的 userId
  final bool isManUser;

  const HomeScreenWidget({
    super.key,
    required this.userId,
    required this.isManUser,
  });

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  String userName = "載入中...";
  String babyName = "小寶";
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  /// **顯示給使用者的「當天累積步數」**
  int _stepCount = 0;

  /// **記錄裝置計步器上次讀取的絕對值，用來計算增量**
  int? _lastDeviceSteps;

  /// **記錄目前是哪一天 (YYYY-MM-DD)，對應到 Firebase docId**
  String _currentDay = "";

  StreamSubscription<StepCount>? _stepSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadBabyName();
    _loadProfilePicture();

    // 載入「今天」的步數資料
    _loadStepsForToday().then((_) {
      // 完成後再啟動計步器監聽
      initPedometer();
    });

    requestPermission(); // 請求計步權限
  }

  /// **🔹 從 Firebase 讀取「今天」的步數資料**
  Future<void> _loadStepsForToday() async {
    try {
      // 以 YYYY-MM-DD 作為 docId
      _currentDay = DateTime.now().toString().substring(0, 10);

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('count')
          .doc(_currentDay) // ← 直接以 "2025-03-09" 之類當 docId
          .get(GetOptions(source: Source.server)); // 強制從伺服器讀取

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        int firebaseSteps = data['步數'] ?? 0;
        int firebaseLastDeviceSteps = data['lastDeviceSteps'] ?? 0;

        setState(() {
          _stepCount = firebaseSteps;
          _lastDeviceSteps =
              (firebaseLastDeviceSteps != 0) ? firebaseLastDeviceSteps : null;
        });
        logger.i(
            "載入今天 $_currentDay 的步數: $_stepCount, lastDeviceSteps=$_lastDeviceSteps");
      } else {
        // 該日期沒有資料 => 初始化
        setState(() {
          _stepCount = 0;
          _lastDeviceSteps = null;
        });
        // 存回 Firebase，避免下次取不到
        await _saveStepsForToday();
        logger.i("今天 $_currentDay 尚無資料，已初始化: 步數=0, lastDeviceSteps=null");
      }
    } catch (e) {
      logger.e("❌ 讀取 Firebase 步數錯誤: $e");
    }
  }

  /// **🔹 監聽裝置計步器事件，若跨天就存檔到前一天，再切換到新的一天 doc**
  void initPedometer() {
    try {
      _stepSubscription = Pedometer.stepCountStream.listen((StepCount event) {
        if (!mounted) return;

        String today = DateTime.now().toString().substring(0, 10);

        // 若日期變更 => 表示跨天
        if (_currentDay != today) {
          // 先把舊日最終步數存檔
          _saveStepsForToday();

          // 切換到新的一天
          setState(() {
            _currentDay = today;
            _stepCount = 0;
            _lastDeviceSteps = event.steps; // 以當前裝置值作為新基準
          });
          _saveStepsForToday();
          logger.i("跨天: 由 $_currentDay 切換到 $today, 步數歸0, 基準=${event.steps}");
          return;
        }

        // 沒跨天 => 正常累加
        int currentDeviceSteps = event.steps;

        // 第一次事件 => 設置基準
        if (_lastDeviceSteps == null) {
          setState(() {
            _lastDeviceSteps = currentDeviceSteps;
          });
          _saveStepsForToday();
          logger.i("第一次事件 => 設定基準: _lastDeviceSteps=$currentDeviceSteps");
          return;
        }

        // 計算差量
        int difference = currentDeviceSteps - _lastDeviceSteps!;
        if (difference > 0) {
          setState(() {
            _stepCount += difference;
            _lastDeviceSteps = currentDeviceSteps;
          });
          _saveStepsForToday();
          logger.i("步數增加 +$difference => 總步數 $_stepCount");
        } else if (difference < 0) {
          // 如果計步器被重置或手機重開機 => 重新設定基準
          setState(() {
            _lastDeviceSteps = currentDeviceSteps;
          });
          _saveStepsForToday();
          logger.w("計步器歸零/重開機，重設基準為 $currentDeviceSteps");
        }
      }, onError: (error) {
        logger.e("計步器錯誤: $error");
      });
    } catch (e) {
      logger.e("初始化計步器失敗: $e");
    }
  }

  /// **🔹 將當前的 _stepCount、_lastDeviceSteps 存到「當天 doc」中**
  Future<void> _saveStepsForToday() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('count')
          .doc(_currentDay)
          .set({
        '步數': _stepCount,
        'lastDeviceSteps': _lastDeviceSteps ?? 0,
      }, SetOptions(merge: true));

      logger.i(
          "✅ 已更新 ${widget.userId} => $_currentDay, 步數: $_stepCount, 基準: $_lastDeviceSteps");
    } catch (e) {
      logger.e("❌ 步數更新失敗: $e");
    }
  }

  /// **🔹 請求計步權限**
  Future<void> requestPermission() async {
    try {
      var status = await Permission.activityRecognition.request();
      if (status.isGranted) {
        logger.i("計步權限已允許");
      } else if (status.isDenied) {
        logger.w("計步權限被拒絕，功能可能無法使用");
      } else if (status.isPermanentlyDenied) {
        logger.e("計步權限被永久拒絕，請手動開啟權限");
        openAppSettings();
      }
    } catch (e) {
      logger.e("請求計步權限錯誤: $e");
    }
  }

  @override
  void dispose() {
    _stepSubscription?.cancel();
    super.dispose();
  }

  // ============== 以下為 UI 相關程式碼，保持原樣即可 ==============

  Future<void> _loadProfilePicture() async {
    try {
      String downloadUrl = await FirebaseStorage.instance
          .ref('profile_pictures/${widget.userId}.jpg')
          .getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      logger.e("❌ 無法載入圖片，使用預設圖片: $e");
      setState(() {
        _profileImageUrl = null;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      File file = File(image.path);
      String filePath = 'profile_pictures/${widget.userId}.jpg';
      await FirebaseStorage.instance.ref(filePath).putFile(file);
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
          userName = userDoc['名字'] ?? '未知用戶';
        });
      }
    } catch (e) {
      logger.e("❌ 錯誤：讀取使用者名稱失敗 $e");
    }
  }

  Future<void> _loadBabyName() async {
    try {
      QuerySnapshot babySnapshot = await FirebaseFirestore.instance
          .collection('users')
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
            // 頭像
            Positioned(
              top: screenHeight * 0.03,
              left: screenWidth * 0.07,
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  width: screenWidth * 0.20,
                  height: screenHeight * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : const AssetImage('assets/images/Picture.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // 顯示當前步數
            Positioned(
              top: screenHeight * 0.40,
              left: screenWidth * 0.08,
              child: Column(
                children: [
                  Text(
                    "當前步數：$_stepCount",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: const Color.fromRGBO(165, 146, 125, 1),
                    ),
                  ),
                ],
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
                        isManUser: widget.isManUser,
                        stepCount: _stepCount,
                        updateStepCount: (val) {
                          setState(() {
                            _stepCount = val;
                          });
                          _saveStepsForToday();
                        },
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
              top: screenHeight * 0.20,
              left: screenWidth * 0.08,
              child: SizedBox(
                width: screenWidth * 0.84,
                child: Text(
                    '今天心情還好嗎?一切都會越來越好喔!\n\n'
                    '別擔心，你已經做得很好了！每一天都是新的學習與成長，請相信自己，也別忘了好好照顧自己 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(165, 146, 125, 1),
                      fontFamily: 'Inter',
                      fontSize: screenWidth * 0.05,
                    )),
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
                          BabyWidget(userId: widget.userId, isManUser: false),
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
