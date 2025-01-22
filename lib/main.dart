import 'package:doctor_2/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 隱藏 Debug 標籤
      title: 'Settings App', // 應用標題
      theme: ThemeData(
        primarySwatch: Colors.brown, // 主題顏色
      ),
      home: Home_screenWidget(), // 首頁設置為 SettingWidget
    );
  }
}
