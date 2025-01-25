import 'package:doctor_2/first_quesion/breastfeeding_duration.dart';
import 'package:doctor_2/first_quesion/finish.dart';
import 'package:doctor_2/first_quesion/first_breastfeeding.dart';
import 'package:doctor_2/first_quesion/firsttime.dart';
import 'package:doctor_2/first_quesion/frequency.dart';
import 'package:doctor_2/first_quesion/notyet1.dart';
import 'package:doctor_2/first_quesion/stop.dart';
import 'package:doctor_2/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/main.screen.dart';
import 'package:doctor_2/register/success.dart';

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
      initialRoute: '/', // 初始路由
      routes: {
        '/': (context) => const Main_screenWidget(), // 主畫面
        '/Notyet1Widget': (context) => const Notyet1Widget(), // Notyet1頁面
        '/FrequencyWidget': (context) => const FrequencyWidget(), // Deta頁面
        '/SuccessWidget': (context) => const SuccessWidget(), // Success頁面
        '/FirstBreastfeedingWidget': (context) =>
            const FirstBreastfeedingWidget(),
        '/Home_screenWidget': (context) => const Home_screenWidget(),
        '/FinishWidget': (context) => const FinishWidget(),
        '/FirsttimeWidget': (context) => const FirsttimeWidget(),
        '/Breastfeeding_durationWidget': (context) =>
            const Breastfeeding_durationWidget(),
        '/StopWidget': (context) => const StopWidget(),
      },
    );
  }
}
