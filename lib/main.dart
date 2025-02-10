import 'package:doctor_2/first_question/breastfeeding_duration.dart';
import 'package:doctor_2/first_question/finish.dart';
import 'package:doctor_2/first_question/first_breastfeeding.dart';
import 'package:doctor_2/first_question/firsttime.dart';
import 'package:doctor_2/first_question/frequency.dart';
import 'package:doctor_2/first_question/notyet.dart';
import 'package:doctor_2/first_question/stop.dart';
import 'package:doctor_2/first_question/notfirst.dart';
import 'package:doctor_2/first_question/nowfeeding.dart';
import 'package:doctor_2/first_question/yesyet.dart';
import 'package:doctor_2/home/baby.dart';
import 'package:doctor_2/home/baby_acc.dart';
import 'package:doctor_2/home/delete.dart';
import 'package:doctor_2/home/delete_acc.dart';
import 'package:doctor_2/home/home_screen.dart';
import 'package:doctor_2/home/question.dart';
import 'package:doctor_2/home/revise.dart';
import 'package:doctor_2/questionGroup/attachment.dart';
import 'package:doctor_2/questionGroup/knowledge_widget.dart';
import 'package:doctor_2/questionGroup/melancholy.dart';
import 'package:doctor_2/questionGroup/production.dart';
import 'package:doctor_2/register/iam.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/main.screen.dart';
import 'package:doctor_2/register/success.dart';
import 'package:doctor_2/first_question/born.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/l10n.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('zh', 'TW'); // 默認語言為繁體中文

  void setLocale(Locale locale) {
    logger.e('切換語言為: ${locale.languageCode}');
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settings App',
      theme: ThemeData(primarySwatch: Colors.brown),
      locale: _locale, // 傳遞當前語言
      supportedLocales: const [
        Locale('zh', 'TW'),
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/': (context) => const QuestionWidget(
              userId: '3',
            ), // 主畫面
        '/IamWidget': (context) => const IamWidget(),
        '/ReviseWidget': (context) => const ReviseWidget(),
        '/DeleteWidget': (context) => const DeleteWidget(),
        '/DeleteAccWidget': (context) => const DeleteAccWidget(),
        '/Main_screenWidget': (context) => const Main_screenWidget(),
      },
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
        if (settings.name == '/KnowledgeWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => KnowledgeWidget(userId: userId),
          );
        }
        if (settings.name == '/MelancholyWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => MelancholyWidget(userId: userId),
          );
        }
        if (settings.name == '/ProdutionWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ProdutionWidget(userId: userId),
          );
        }
        if (settings.name == '/AttachmentWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => AttachmentWidget(userId: userId),
          );
        }

        return null;
      },
    );
  }
}
