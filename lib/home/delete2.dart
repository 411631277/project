import 'package:doctor_2/home/setting.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class Delete2Widget extends StatelessWidget {
  final String userId;
  final bool isManUser;
  final Function(int) updateStepCount;

  const Delete2Widget({
    super.key,
    required this.userId,
    required this.isManUser,
    required this.updateStepCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
        canPop: false,
        child: Scaffold(
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
                              await _freezeUserData(context, userId);
                            }),
                            _buildButton(context, '否', Colors.grey.shade400,
                                () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingWidget(
                                    userId: userId,
                                    isManUser: isManUser,
                                  ),
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
        ));
  }

  /// 將使用者資料「搬移」到 freeze 下的 man_user 或 user，再刪除原本資料
  Future<void> _freezeUserData(BuildContext context, String userId) async {
    try {
      // 原集合
      final String fromCollection = isManUser ? 'Man_users' : 'users';
      // 目標： freeze/man_user 或 freeze/user
      final String freezeSubCollection = isManUser ? 'man_user' : 'user';

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference fromDocRef =
          firestore.collection(fromCollection).doc(userId);
      DocumentSnapshot fromDocSnapshot = await fromDocRef.get();

      if (!fromDocSnapshot.exists) {
        logger.e("❌ 找不到使用者 $userId");
        return;
      }

      // 取得原本的資料
      Map<String, dynamic> userData =
          fromDocSnapshot.data() as Map<String, dynamic>;

      // 在 freeze/{freezeSubCollection}/(userId) 建立同樣的 doc
      // => e.g. freeze/man_user/userId or freeze/user/userId
      DocumentReference toDocRef = firestore
          .collection('freeze')
          .doc(freezeSubCollection)
          .collection(freezeSubCollection)
          .doc(userId);

      // 先寫入主文件
      await toDocRef.set(userData);
      logger.i(
          "✅ 已將 $fromCollection/$userId 移動到 freeze/$freezeSubCollection/$userId");

      // 搬移子集合 (例如 baby)
      await _copySubcollectionsToFreeze(fromDocRef, toDocRef);

      // 刪除原本的 doc (包含子集合)
      await _deleteOriginalUser(fromDocRef);
      logger.i("✅ 已刪除 $fromCollection/$userId 的原文件與子集合");

      // 導航至凍結完成頁面
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/DeleteAccWidget', (route) => false);
      }
    } catch (e) {
      logger.e("❌ 凍結帳號失敗: $e");
    }
  }

  /// 將子集合搬到 freeze
  Future<void> _copySubcollectionsToFreeze(
      DocumentReference fromDoc, DocumentReference toDoc) async {
    try {
      final babySnapshot = await fromDoc.collection('baby').get();
      for (var doc in babySnapshot.docs) {
        // 取得子文件資料
        Map<String, dynamic> babyData = doc.data();
        // 寫入 freeze 集合
        await toDoc.collection('baby').doc(doc.id).set(babyData);
      }
      logger.i("✅ 已將子集合 baby 搬移到 freeze");
    } catch (e) {
      logger.e("❌ 搬移子集合 baby 時發生錯誤: $e");
    }

    try {
      final count = await fromDoc.collection('count').get();
      for (var doc in count.docs) {
        // 取得子文件資料
        Map<String, dynamic> count = doc.data();
        // 寫入 freeze 集合
        await toDoc.collection('count').doc(doc.id).set(count);
      }
      logger.i("✅ 已將子集合 count 搬移到 freeze");
    } catch (e) {
      logger.e("❌ 搬移子集合 count 時發生錯誤: $e");
    }
    try {
      final questions = await fromDoc.collection('questions').get();
      for (var doc in questions.docs) {
        // 取得子文件資料
        Map<String, dynamic> questions = doc.data();
        // 寫入 freeze 集合
        await toDoc.collection('questions').doc(doc.id).set(questions);
      }
      logger.i("✅ 已將子集合 questions 搬移到 freeze");
    } catch (e) {
      logger.e("❌ 搬移子集合 questions 時發生錯誤: $e");
    }
  }

  /// 刪除原本 user doc 與子集合
  Future<void> _deleteOriginalUser(DocumentReference fromDoc) async {
    // 先刪子集合
    final babySnapshot = await fromDoc.collection('baby').get();
    for (var doc in babySnapshot.docs) {
      await fromDoc.collection('baby').doc(doc.id).delete();
    }
    final count = await fromDoc.collection('count').get();
    for (var doc in count.docs) {
      await fromDoc.collection('count').doc(doc.id).delete();
    }
    final questions = await fromDoc.collection('questions').get();
    for (var doc in questions.docs) {
      await fromDoc.collection('questions').doc(doc.id).delete();
    }

    // 再刪主文件
    await fromDoc.delete();
  }

  /// 按鈕樣式
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
