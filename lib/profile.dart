import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      appBar: AppBar(
        title: const Text('個人資料'),
        backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  infoTile('使用者身分', widget.isManUser ? '爸爸' : '媽媽'),
                  infoTile('姓名', userData['名字'] ?? '未提供'),
                  infoTile('Email', userData['電子信箱'] ?? '未提供'),
                  infoTile('手機號碼', userData['手機號碼'] ?? '未提供'),
                  infoTile('配對碼', userData['配對碼'] ?? '未提供'),
                  infoTile('身高', userData['身高'] ?? '未提供'),
                  infoTile('體重', userData['目前體重'] ?? '未提供'),
                  infoTile(
                    '慢性病',
                    userData['是否有慢性病'] == true
                        ? '有'
                        : (userData['是否有慢性病'] == false ? '否' : '未提供'),
                  ),
                  infoTile('婚姻狀況', userData['婚姻狀況'] ?? '未提供'),
                  infoTile(
                    '有抽菸?',
                    userData['answers']?['是否會吸菸?'] == true
                        ? '有'
                        : (userData['answers']?['是否會吸菸?'] == false
                            ? '否'
                            : '未提供'),
                  ),
                  infoTile(
                    '會喝酒?',
                    userData['answers']?['是否會喝酒?'] == true
                        ? '有'
                        : (userData['answers']?['是否會喝酒?'] == false
                            ? '否'
                            : '未提供'),
                  ),
                  infoTile(
                    '會嚼食檳榔?',
                    userData['answers']?['是否會嚼食檳榔'] == true
                        ? '有'
                        : (userData['answers']?['是否會嚼食檳榔'] == false
                            ? '否'
                            : '未提供'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(
                '$label：',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Expanded(
              child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          )),
        ],
      ),
    );
  }
}
