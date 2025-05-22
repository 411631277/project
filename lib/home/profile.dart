import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math; // 新增

final Logger logger = Logger();

class ProfilePage extends StatefulWidget {
  final String userId;
  final bool isManUser;

  const ProfilePage({
    super.key,
    required this.userId,
    required this.isManUser,
  });


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

String getAnswerText(String? value) {
  if (value == 'true') return '是';
  if (value == 'false') return '從未';
  if (value == 'none') return '曾經有，已戒掉';
  return '未提供';
}

  Future<void> fetchUserData() async {
  try {
    // 根據 isManUser 決定要讀取哪個集合
    final String collectionName = widget.isManUser ? 'Man_users' : 'users';

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } else {
      logger.w("❗️ 該用戶資料不存在於 $collectionName 集合");
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    logger.e("❌ 無法載入資料: $e");
    setState(() {
      isLoading = false;
    });
  }
}

  // 確保這些方法已經定義，或依需求自行實作
  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // 無圓角，長方形
      ),
      minimumSize: const Size(120, 40), // 可依需求調整尺寸
    ),
    onPressed: onPressed,
    child: Text(label),
  );
}

  Future<void> _updateUserData() async {
    // 您的更新資料邏輯
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('個人資料'),
        backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      infoTile('使用者身分', widget.isManUser ? '爸爸' : '媽媽'),
                      infoTile('帳號', userData['帳號'] ?? '未提供'),
                      infoTile('姓名', userData['名字'] ?? '未提供'),
                      infoTile('生日', userData['生日'] ?? '未提供'),
                      infoTile('手機號碼', userData['手機號碼'] ?? '未提供'),
                      infoTile('身高', userData['身高'] ?? '未提供'),
                      infoTile('體重', userData['目前體重'] ?? '未提供'),
                      infoTile(
                        '慢性病',
                        userData['是否有特殊疾病病'] == true
                            ? '有'
                            : (userData['是否有慢性病'] == false ? '否' : '無'),
                      ),
                      infoTile('婚姻狀況', userData['婚姻狀況'] ?? '未提供'),
                      infoTile(
  '有抽菸?',
  userData['是否會吸菸'] == 'true'
      ? '是'
      : (userData['是否會吸菸'] == 'false'
          ? '從未'
          : (userData['是否會吸菸'] == 'none' ? '曾經有，已戒掉' : '未提供')),
),
infoTile(
  '會喝酒?',
  userData['是否會喝酒'] == 'true'
      ? '是'
      : (userData['是否會喝酒'] == 'false'
          ? '從未'
          : (userData['是否會喝酒'] == 'none' ? '曾經有，已戒掉' : '未提供')),
),
infoTile(
  '會嚼食檳榔?',
  userData['是否會嚼食檳榔'] == 'true'
      ? '是'
      : (userData['是否會嚼食檳榔'] == 'false'
          ? '從未'
          : (userData['是否會嚼食檳榔'] == 'none' ? '曾經有，已戒掉' : '未提供')),
),

                    ],
                  ),
                ),
          // 新增的 Positioned widget 1：返回按鈕
          Positioned(
            top: screenHeight * 0.65,
            left: screenWidth * 0.08,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Transform.rotate(
                angle: math.pi,
                child: Image.asset(
                  'assets/images/back.png',
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.23,
                ),
              ),
            ),
          ),
          // 刪除與修改按鈕
          Positioned(
              top: screenHeight * 0.7,
              left: screenWidth * 0.60,
              child: Column(
                children: [
                  _buildButton('刪除帳號', Colors.grey.shade400, () {
                    Navigator.pushNamed(
                      context,
                      '/DeleteWidget',
                      arguments: {
                      'userId': widget.userId,
                      'isManUser': widget.isManUser,
                  });
                  }),
                  const SizedBox(height: 20),
                  _buildButton('修改帳號', Colors.grey.shade400, () async {
                    await _updateUserData();
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/DetaWidget', arguments: {
                      'userId': widget.userId,
                      'isManUser': widget.isManUser,
                    });
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label：',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
