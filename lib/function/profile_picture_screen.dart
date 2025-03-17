import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class ProfilePictureScreen extends StatefulWidget {
  final String userId; // 用戶 ID

  const ProfilePictureScreen({super.key, required this.userId});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture(); // 載入已存的圖片
  }

  // 🔹 從 Firebase Storage 讀取圖片
  Future<void> _loadProfilePicture() async {
    try {
      String downloadUrl = await FirebaseStorage.instance
          .ref('profile_pictures/${widget.userId}.jpg')
          .getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      logger.e("❌ 無法載入圖片: $e");
    }
  }

  // 🔹 選擇圖片並上傳到 Firebase Storage
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String filePath = 'profile_pictures/${widget.userId}.jpg';

      try {
        await FirebaseStorage.instance.ref(filePath).putFile(file);
        String downloadUrl =
            await FirebaseStorage.instance.ref(filePath).getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
        });

        logger.e("✅ 上傳成功: $downloadUrl");
      } catch (e) {
        logger.e("❌ 上傳失敗: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("更換大頭貼")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageUrl != null
                ? CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(_imageUrl!),
                  )
                : const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/default.png'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: const Text("選擇圖片並上傳"),
            ),
          ],
        ),
      ),
    );
  }
}
