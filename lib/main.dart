import 'package:doctor_2/first_quesion/breastfeeding_duration.dart';
import 'package:doctor_2/first_quesion/finish.dart';
import 'package:doctor_2/first_quesion/first_breastfeeding.dart';
import 'package:doctor_2/first_quesion/firsttime.dart';
import 'package:doctor_2/first_quesion/frequency.dart';
import 'package:doctor_2/first_quesion/notyet.dart';
import 'package:doctor_2/first_quesion/stop.dart';
import 'package:doctor_2/first_quesion/notfirst.dart';
import 'package:doctor_2/first_quesion/nowfeeding.dart';
import 'package:doctor_2/first_quesion/yesyet.dart';
import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/baby_acc.dart';
import 'package:doctor_2/home/delete.dart';
import 'package:doctor_2/home/delete_acc.dart';
import 'package:doctor_2/home/home_screen.dart';
import 'package:doctor_2/home/revise.dart';
import 'package:doctor_2/register/iam.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/main.screen.dart';
import 'package:doctor_2/register/success.dart';
import 'package:doctor_2/first_quesion/born.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); // ✅ 只執行一次 runApp()
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
      //路由設定
      initialRoute: '/', // 初始路由
      onGenerateRoute: (settings) {
        //接收userID放這裡
        if (settings.name == '/SuccessWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => SuccessWidget(userId: userId),
          );
        }
        if (settings.name == '/Notyet1Widget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => Notyet1Widget(userId: userId),
          );
        }
        if (settings.name == '/BornWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BornWidget(userId: userId),
          );
        }
        if (settings.name == '/FrequencyWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FrequencyWidget(userId: userId),
          );
        }
        if (settings.name == '/FirsttimeWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FirsttimeWidget(userId: userId),
          );
        }
        if (settings.name == '/FirstBreastfeedingWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FirstBreastfeedingWidget(userId: userId),
          );
        }
        if (settings.name == '/NotfirstWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => NotfirstWidget(userId: userId),
          );
        }
        if (settings.name == '/FinishWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FinishWidget(userId: userId),
          );
        }
        if (settings.name == '/BreastfeedingDurationWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BreastfeedingDurationWidget(userId: userId),
          );
        }
        if (settings.name == '/StopWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => StopWidget(userId: userId),
          );
        }
        if (settings.name == '/Nowfeeding') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => Nowfeeding(userId: userId),
          );
        }
        if (settings.name == '/YesyetWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => YesyetWidget(userId: userId),
          );
        }
        if (settings.name == '/StopWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => StopWidget(userId: userId),
          );
        }
        if (settings.name == '/HomeScreenWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => HomeScreenWidget(userId: userId),
          );
        }
        if (settings.name == '/BabyWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BabyWidget(userId: userId),
          );
        }
        if (settings.name == '/BabyAccWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BabyAccWidget(userId: userId),
          );
        }
        return null;
      },
      //靜態畫面
      routes: {
        '/': (context) => const HomeScreenWidget(
              userId: '1',
            ), // 主畫面
        '/IamWidget': (context) => const IamWidget(),
        '/ReviseWidget': (context) => const ReviseWidget(),
        '/DeleteWidget': (context) => const DeleteWidget(),
        '/DeleteAccWidget': (context) => const DeleteAccWidget(),
        '/Main_screenWidget': (context) => const Main_screenWidget(),
      },
      locale: const Locale('zh', 'TW'), // ✅ 設定為繁體中文
      supportedLocales: [
        const Locale('zh', 'TW'), // 繁體中文
        const Locale('zh', 'CN'), // 簡體中文
        const Locale('en', 'US'), // 英文
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
