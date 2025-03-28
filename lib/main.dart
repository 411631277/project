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
import 'package:doctor_2/home/delate.dart';
import 'package:doctor_2/home/delete2.dart';
import 'package:doctor_2/home/delete_acc.dart';
import 'package:doctor_2/home/deta.dart';
import 'package:doctor_2/home/fa_home_screen.dart';
import 'package:doctor_2/home/home_screen.dart';
import 'package:doctor_2/home/revise.dart';
import 'package:doctor_2/questionGroup/attachment.dart';
import 'package:doctor_2/questionGroup/knowledge_widget.dart';
import 'package:doctor_2/questionGroup/melancholy.dart';
import 'package:doctor_2/questionGroup/painscale.dart';
import 'package:doctor_2/questionGroup/production.dart';
import 'package:doctor_2/questionGroup/roommate.dart';
import 'package:doctor_2/questionGroup/sleep.dart';
import 'package:doctor_2/questionGroup/sleep2.dart';
import 'package:doctor_2/register/fa_success.dart';
import 'package:doctor_2/register/iam.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/function/main.screen.dart';
import 'package:doctor_2/register/success.dart';
import 'package:doctor_2/first_question/born.dart';
import 'package:firebase_core/firebase_core.dart';
import 'function/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/l10n.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

//註解已完成

final Logger logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 直式向上
    DeviceOrientation.portraitDown, // 直式向下 (可選，通常也一起加)
  ]);

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

      //路由
      routes: {
        '/': (context) => const MainScreenWidget(
            ), // 主畫面
        '/IamWidget': (context) => const IamWidget(),
        '/DeleteAccWidget': (context) => const DeleteAccWidget(),
        '/MainScreenWidget': (context) => const MainScreenWidget(),
      },

      //接收userID放這裡
      onGenerateRoute: (settings) {
        if (settings.name == '/FaHomeScreenWidget') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FaHomeScreenWidget(
              userId: args['userId'],
              isManUser: (args['isManUser'] as bool?) ?? false,
              updateStepCount: (steps) {},
            ),
          );
        }
        if (settings.name == '/FaSuccessWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FaSuccessWidget(
              userId: userId,
              isManUser: true,
            ),
          );
        }
        if (settings.name == '/DeleteWidget') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DeleteWidget(
              userId: args['userId'],
              isManUser: args['isManUser'],
              updateStepCount: (steps) {},
            ),
          );
        }
        if (settings.name == '/Delete2Widget') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => Delete2Widget(
              userId: args['userId'],
              isManUser: args['isManUser'],
              updateStepCount: (steps) {},
            ),
          );
        }
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
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => HomeScreenWidget(
              userId: args['userId'],
              isManUser: args['isManUser'],
            ),
          );
        }
        if (settings.name == '/BabyWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BabyWidget(userId: userId, isManUser: true),
          );
        }
        if (settings.name == '/BabyAccWidget') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
              builder: (context) => BabyAccWidget(
                    userId: args['userId'],
                    isManUser: args['isManUser'],
                  ));
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
        if (settings.name == '/SleepWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => SleepWidget(userId: userId),
          );
        }
        if (settings.name == '/Sleep2Widget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => Sleep2Widget(userId: userId),
          );
        }
        if (settings.name == '/PainScaleWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PainScaleWidget(userId: userId),
          );
        }
        if (settings.name == '/RoommateWidget') {
          final userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => RoommateWidget(userId: userId),
          );
        }
        if (settings.name == '/DetaWidget') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetaWidget(
              userId: args['userId'],
              isManUser: args['isManUser'],
            ),
          );
        }
        if (settings.name == '/ReviseWidget') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ReviseWidget(
              userId: args['userId'],
              isManUser: args['isManUser'],
            ),
          );
        }

        return null;
      },
    );
  }
}
