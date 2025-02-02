import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger _logger = Logger(); // 🔹 建立 Logger

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').add(userData);
      _logger.i("資料成功儲存！"); // 🔹 使用 Logger 來記錄資訊
    } catch (e) {
      _logger.e("儲存資料時發生錯誤：$e"); // 🔹 使用 Logger 記錄錯誤
    }
  }
}
