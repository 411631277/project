import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getString('userId');
    final isManUser = prefs.getBool('isManUser') ?? false;

    await Future.delayed(const Duration(seconds: 2)); // 模擬 splash 等待

    if (!mounted) return;

    if (isLoggedIn && userId != null) {
      if (isManUser) {
        Navigator.pushReplacementNamed(context, '/FaHomeScreenWidget', arguments: {
    'userId': userId,
    'isManUser': isManUser,
  },);
      } else {
        Navigator.pushReplacementNamed(context, '/HomeScreenWidget', arguments: {
    'userId': userId,
    'isManUser': isManUser,
  },);
      }
    } else {
      Navigator.pushReplacementNamed(context, '/MainScreenWidget');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('載入中，請稍候...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
