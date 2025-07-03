// 🔹 Flutter / Dart / Plugin 套件匯入
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// 🔹 專案內頁面
import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/question.dart';
import 'package:doctor_2/home/robot.dart';
import 'package:doctor_2/home/setting.dart';
import 'package:doctor_2/home/tgos.dart';

// 🔹 全域 Logger
final Logger logger = Logger();

class HomeScreenWidget extends StatefulWidget {
  final String userId;
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
  // 🔹 使用者名稱與寶寶暱稱
  String userName = "載入中...";
  String babyName = "寶寶資料填寫";

  // 🔹 圖片與圖片選擇器
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker();

  // 🔹 計步資料
  int? _startOfDaySteps;
  int _stepCount = 0;
  int _targetSteps = 5000;
  int? _lastDeviceSteps;
  String _currentDay = "";

  StreamSubscription<StepCount>? _stepSubscription;

  double getCaloriesBurned() => _stepCount * 0.03;

  @override
  void initState() {
    super.initState();
    _currentDay = DateTime.now().toString().substring(0, 10);

    // 🔸 初始化資料流程
    _loadUserName();
    _loadProfilePicture();
    _loadTargetStepsFromFirebase();
    _loadStepsForToday()
        .then((_) => _loadStoredSteps())
        .then((_) => initPedometer());

    requestPermission(); // 請求計步權限
  }

  @override
  void dispose() {
    _stepSubscription?.cancel();
    super.dispose();
  }

  /// 📌 取得使用者名稱
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

  /// 📌 載入使用者大頭貼
  Future<void> _loadProfilePicture() async {
    try {
      String downloadUrl = await FirebaseStorage.instance
          .ref('profile_pictures/${widget.userId}.jpg')
          .getDownloadURL();

      setState(() => _profileImageUrl = downloadUrl);
    } catch (e) {
      logger.e("❌ 無法載入圖片: $e");
      setState(() => _profileImageUrl = null);
    }
  }

  /// 📌 使用者選擇並上傳圖片
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      File file = File(image.path);
      await FirebaseStorage.instance
          .ref('profile_pictures/${widget.userId}.jpg')
          .putFile(file);
      _loadProfilePicture();
      logger.i("✅ 圖片上傳成功");
    } catch (e) {
      logger.e("❌ 上傳圖片失敗: $e");
    }
  }

  /// 📌 顯示大頭貼預覽與更換對話框
  void _showProfilePreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _profileImageUrl != null
                            ? Image.network(
                                _profileImageUrl!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/Picture.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
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
      ),
    );
  }

  /// 📌 顯示「設定目標步數」對話框
  Future<void> _showTargetStepsDialog() async {
    final controller = TextEditingController(text: _targetSteps.toString());
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("設定目標步數"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "請輸入目標步數"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              final input = controller.text.trim();
              final newTarget = int.tryParse(input);
              if (newTarget != null && newTarget > 0) {
                setState(() => _targetSteps = newTarget);
                _saveTargetStepsToFirebase(newTarget);
              }
              Navigator.pop(context);
            },
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }

  /// 📌 儲存目標步數至 Firebase
  Future<void> _saveTargetStepsToFirebase(int newTarget) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({'targetSteps': newTarget}, SetOptions(merge: true));
      logger.i("✅ 目標步數更新為 $newTarget");
    } catch (e) {
      logger.e("❌ 更新目標步數失敗: $e");
    }
  }

  /// 📌 從 Firebase 載入目標步數
  Future<void> _loadTargetStepsFromFirebase() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        int firebaseTarget = data['targetSteps'] ?? 5000;
        setState(() => _targetSteps = firebaseTarget);
        logger.i("載入目標步數: $_targetSteps");
      }
    } catch (e) {
      logger.e("❌ 載入目標步數失敗: $e");
    }
  }

  /// 📌 從 Firebase 載入「今天」的步數紀錄
  Future<void> _loadStepsForToday() async {
    try {
      _currentDay = DateTime.now().toString().substring(0, 10);

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('count')
          .doc(_currentDay)
          .get(GetOptions(source: Source.server));

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _stepCount = data['步數'] ?? 0;
          _lastDeviceSteps = data['lastDeviceSteps'] ?? 0;
        });
        logger.i("今天 $_currentDay：步數 $_stepCount, 基準 $_lastDeviceSteps");
      } else {
        setState(() {
          _stepCount = 0;
          _lastDeviceSteps = null;
        });

        Pedometer.stepCountStream.first.then((event) {
          if (event.steps > 0) {
            setState(() {
              _lastDeviceSteps = event.steps;
              _stepCount = 0;
            });
            _saveStepsForToday();
            logger.i("初始化基準：$event.steps");
          }
        });

        await _saveStepsForToday();
        logger.i("初始化 Firebase：今日步數=0, 基準=null");
      }
    } catch (e) {
      logger.e("❌ Firebase 步數讀取失敗: $e");
    }
  }

  /// 📌 初始化 pedometer 監聽器，處理跨天與步數增量計算
  void initPedometer() {
    try {
      _stepSubscription = Pedometer.stepCountStream.listen((event) {
        if (!mounted) return;

        final today = DateTime.now().toString().substring(0, 10);
        final deviceSteps = event.steps;

        if (_currentDay != today) {
          _saveStepsForToday();
          setState(() {
            _currentDay = today;
            _stepCount = 0;
            _startOfDaySteps = deviceSteps;
          });
          _saveStepsToLocal(0, deviceSteps);
          logger.i("跨天：重置基準與步數");
          return;
        }

        if (_startOfDaySteps == null) {
          setState(() => _startOfDaySteps = deviceSteps);
          _saveStepsToLocal(0, deviceSteps);
          logger.i("設定初始基準步數：$deviceSteps");
          return;
        }

        int todaySteps = deviceSteps - _startOfDaySteps!;
        if (todaySteps >= 0) {
          setState(() => _stepCount = todaySteps);
          _saveStepsToLocal(todaySteps, _startOfDaySteps!);
        } else {
          logger.w("異常負步數，忽略");
        }

        _saveStepsForToday();
      }, onError: (error) {
        logger.e("計步器錯誤：$error");
      });
    } catch (e) {
      logger.e("初始化 pedometer 失敗：$e");
    }
  }

  /// 📌 儲存當天的步數到 Firebase
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

      logger.i("✅ Firebase 更新步數成功 $_currentDay");
    } catch (e) {
      logger.e("❌ Firebase 更新步數失敗: $e");
    }

    await sendStepDataToMySQL(); // 同步到 MySQL
  }

  /// 📌 儲存步數到 local storage
  Future<void> _saveStepsToLocal(int steps, int deviceSteps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stepCount_$_currentDay', steps);
    await prefs.setInt('startSteps_$_currentDay', deviceSteps);
  }

  /// 📌 載入 local 儲存的步數
  Future<void> _loadStoredSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().substring(0, 10);

    setState(() {
      _currentDay = today;
      _stepCount = prefs.getInt('stepCount_$today') ?? 0;
      _startOfDaySteps = prefs.getInt('startSteps_$today');
    });
  }

  /// 📌 請求計步權限
  Future<void> requestPermission() async {
    try {
      final status = await Permission.activityRecognition.request();
      if (status.isGranted) {
        logger.i("計步權限已允許");
      } else if (status.isPermanentlyDenied) {
        logger.e("請使用者手動開啟權限");
        openAppSettings();
      } else {
        logger.w("計步權限被拒絕");
      }
    } catch (e) {
      logger.e("權限請求錯誤: $e");
    }
  }

  /// 📌 將步數傳送至遠端 MySQL
  Future<void> sendStepDataToMySQL() async {
    final url = Uri.parse('http://163.13.201.85:3000/steps');
    final now = DateTime.now();
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': int.parse(widget.userId),
          'step_date': formattedDate,
          'steps': _stepCount,
          'goal': _targetSteps,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        logger.i("✅ 步數資料已同步至 MySQL");
      } else {
        logger.e("❌ 同步失敗: ${response.body}");
      }
    } catch (e) {
      logger.e("❌ 發送 MySQL 錯誤: $e");
    }
  }

  /// 📌 離開確認視窗
  Future<bool> _showExitDialog(BuildContext context) async {
    bool shouldExit = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('是否要關閉程式？'),
        actions: [
          TextButton(
            onPressed: () {
              shouldExit = true;
              Navigator.of(context).pop();
            },
            child: const Text('是'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('否'),
          ),
        ],
      ),
    );
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final base = math.min(screenWidth, screenHeight);

    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return;
        bool shouldExit = await _showExitDialog(context);
        if (shouldExit && mounted) {
          if (!context.mounted) return;
          SystemNavigator.pop(); // 離開 App
        }
      },
      child: Scaffold(
        body: Container(
          color: const Color.fromRGBO(233, 227, 213, 1),
          child: Stack(
            children: <Widget>[
              // 🔹 頭像
              Positioned(
                top: screenHeight * 0.03,
                left: screenWidth * 0.07,
                child: GestureDetector(
                  onTap: _showProfilePreviewDialog,
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

              // 🔹 設定按鈕
              Positioned(
                top: screenHeight * 0.05,
                left: screenWidth * 0.77,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingWidget(
                          userId: widget.userId,
                          isManUser: widget.isManUser,
                          stepCount: _stepCount,
                          updateStepCount: (val) {
                            setState(() => _stepCount = val);
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

              // 🔹 問題按鈕
              Positioned(
                top: screenHeight * 0.05,
                left: screenWidth * 0.6,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionWidget(
                          userId: widget.userId,
                          isManUser: false,
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

              // 🔹 使用者名稱
              Positioned(
                top: screenHeight * 0.07,
                left: screenWidth * 0.32,
                child: Text(
                  userName,
                  style: TextStyle(
                    color: const Color.fromRGBO(165, 146, 125, 1),
                    fontFamily: 'Inter',
                    fontSize: base * 0.05,
                  ),
                ),
              ),

              // 🔹 步數與目標狀態區塊
              Positioned(
                top: screenHeight * 0.5,
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 當前步數 / 目標步數
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        Text(
                          "當前步數：$_stepCount",
                          style: TextStyle(
                            fontSize: base * 0.05,
                            color: const Color.fromRGBO(165, 146, 125, 1),
                          ),
                        ),
                        SizedBox(width: base * 0.08),
                        GestureDetector(
                          onTap: _showTargetStepsDialog,
                          child: Text(
                            "目標步數：$_targetSteps",
                            style: TextStyle(
                              fontSize: base * 0.05,
                              color: const Color.fromRGBO(165, 146, 125, 1),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // 達標狀態與熱量
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (_stepCount >= _targetSteps) ? "步數已達標" : "步數未達標",
                            style: TextStyle(
                              fontSize: base * 0.05,
                              color: (_stepCount >= _targetSteps)
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "消耗熱量約${getCaloriesBurned().toStringAsFixed(1)} Cal",
                              style: TextStyle(
                                fontSize: base * 0.05,
                                color: const Color.fromRGBO(165, 146, 125, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 小寶圖片按鈕
              Positioned(
                top: screenHeight * 0.75,
                left: screenWidth * 0.08,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BabyWidget(
                          userId: widget.userId,
                          isManUser: false,
                        ),
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

              // 🔹 小寶名字
              Positioned(
                top: screenHeight * 0.77,
                left: screenWidth * 0.25,
                child: Text(
                  babyName,
                  style: TextStyle(
                    fontSize: base * 0.05,
                    color: const Color.fromRGBO(165, 146, 125, 1),
                  ),
                ),
              ),

              // 🔹 心情語
              Positioned(
                top: screenHeight * 0.20,
                left: screenWidth * 0.08,
                child: SizedBox(
                  width: screenWidth * 0.84,
                  child: Text(
                    '今天辛苦了，你的努力已經讓寶寶感受到滿滿的愛。\n\n'
                    '每一天你都做得比想像中更棒，請相信自己，也別忘了好好照顧自己。',
                    style: TextStyle(
                      fontSize: base * 0.05,
                      color: const Color.fromRGBO(165, 146, 125, 1),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),

              // 🔹 機器人按鈕
              Positioned(
                top: screenHeight * 0.82,
                left: screenWidth * 0.8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RobotWidget(
                          userId: widget.userId,
                          isManUser: false,
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

              // 🔹 協助標籤背景
              Positioned(
                top: screenHeight * 0.81,
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
                          screenWidth * 0.4,
                          screenHeight * 0.06,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 🔹 協助文字
              Positioned(
                top: screenHeight * 0.825,
                left: screenWidth * 0.5,
                child: Text(
                  '需要協助嗎?',
                  style: TextStyle(
                    fontSize: base * 0.045,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),

              // 🔹 TGOS 地圖按鈕
              Positioned(
                top: screenHeight * 0.83,
                left: screenWidth * 0.08,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TgosMapPage()),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/tgos.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
