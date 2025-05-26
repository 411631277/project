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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.1 , right: screenWidth * 0.05),
        child: Image.asset(
          'assets/images/Baby.png',
          width: screenWidth * 0.4,
          height: screenHeight * 0.2,
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(height: screenHeight * 0.03),
      const CircularProgressIndicator(),
      SizedBox(height: screenHeight * 0.02),
      const Text(
        '載入中，請稍候...',
        style: TextStyle(fontSize: 16),
      ),
    ],
  ),
),
);
}
}