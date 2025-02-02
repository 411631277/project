import 'package:doctor_2/first_quesion/not%20born/breastfeeding_duration.dart';
import 'package:doctor_2/first_quesion/finish.dart';
import 'package:doctor_2/first_quesion/first_breastfeeding.dart';
import 'package:doctor_2/first_quesion/not%20born/firsttime.dart';
import 'package:doctor_2/first_quesion/not%20born/frequency.dart';
import 'package:doctor_2/first_quesion/not%20born/notyet1.dart';
import 'package:doctor_2/first_quesion/stop.dart';
import 'package:doctor_2/first_quesion/yes%20born/notfirst.dart';
import 'package:doctor_2/first_quesion/yes%20born/nowfeeding.dart';
import 'package:doctor_2/home/baby_acc.dart';
import 'package:doctor_2/home/delete.dart';
import 'package:doctor_2/home/delete_acc.dart';
import 'package:doctor_2/home/home_screen.dart';
import 'package:doctor_2/home/revise.dart';
import 'package:doctor_2/register/iam.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/main.screen.dart';
import 'package:doctor_2/register/success.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        '/BreastfeedingDurationWidget': (context) =>
            const BreastfeedingDurationWidget(),
        '/StopWidget': (context) => const StopWidget(),
        '/Nowfeeding': (context) => const Nowfeeding(),
        '/NotfirstWidget': (context) => const NotfirstWidget(),
        '/IamWidget': (context) => const IamWidget(),
        '/ReviseWidget': (context) => const ReviseWidget(),
        '/DeleteWidget': (context) => const DeleteWidget(),
        '/DeleteAccWidget': (context) => const DeleteAccWidget(),
        '/Main_screenWidget': (context) => const Main_screenWidget(),
        '/BabyAccWidget': (context) => const BabyAccWidget(),
      },
    );
  }
}
