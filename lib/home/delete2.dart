import 'package:doctor_2/home/setting.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class Delete2Widget extends StatelessWidget {
  final String userId; // ✅ 從上一頁傳入 userId
  final bool isManUser;
  const Delete2Widget(
      {super.key, required this.userId, required this.isManUser});

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
                      '確認要刪除帳號嗎?',
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
                        _buildButton(context, '是', Colors.red.shade400,
                            () async {
                          await _deleteUserData(context, userId); // ✅ 傳入 userId
                        }),
                        _buildButton(context, '否', Colors.grey.shade400, () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingWidget(
                                  userId: userId, isManUser: false),
                            ),
                          );
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
    );
  }

  // **🔹 刪除使用者資料**
  Future<void> _deleteUserData(BuildContext context, String userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDoc = firestore.collection('users').doc(userId);

      // 🔹 先刪除該使用者的所有子集合
      await _deleteSubcollections(userDoc);

      // 🔹 刪除主文件
      await userDoc.delete();

      logger.i("✅ 使用者 $userId 的帳號已成功刪除");

      // ✅ 確保 context 存在後執行
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/DeleteAccWidget', (route) => false);
      }
    } catch (e) {
      logger.e("❌ 刪除帳號失敗: $e");
    }
  }

  // 🔹 遞迴刪除子集合的方法
  Future<void> _deleteSubcollections(DocumentReference userDoc) async {
    try {
      QuerySnapshot subcollections = await userDoc.collection('baby').get();

      for (QueryDocumentSnapshot doc in subcollections.docs) {
        await userDoc.collection('baby').doc(doc.id).delete();
      }

      logger.i("✅ 已刪除 user ${userDoc.id} 的所有子集合");
    } catch (e) {
      logger.e("❌ 刪除子集合時發生錯誤: $e");
    }
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
