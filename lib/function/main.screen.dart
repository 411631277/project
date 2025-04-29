import 'package:doctor_2/function/agree.dart';
import 'package:doctor_2/login/login.dart';
import 'package:flutter/material.dart';

//註解已完成

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false, // 允許返回，但是要攔截
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return; // 如果系統已經處理，就不動
        bool shouldExit = await _showExitDialog(context);
        if (shouldExit && mounted) {
        if (!context.mounted) return;
          Navigator.of(context).pop(); // 離開 App (在第一層會直接退出)
        }
      },
      child: Scaffold(
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(233, 227, 213, 1),
          ),
          child: Stack(
            children: <Widget>[
              //（這裡是你原本的 Stack 內容，不用改）
              Positioned(
                top: screenHeight * 0.68,
                left: screenWidth * 0.22,
                child: _buildButton(
                  context,
                  label: '註冊',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResearchAgreementWidget(),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: screenHeight * 0.5,
                left: screenWidth * 0.22,
                child: _buildButton(
                  context,
                  label: '登入',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginWidget(),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: screenHeight * -0.01,
                left: 0,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Main.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.55,
      height: screenHeight * 0.09,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(165, 146, 125, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.1),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 顯示退出提示框
  Future<bool> _showExitDialog(BuildContext context) async {
    bool shouldExit = false;
    await showDialog(
      context: context,
      barrierDismissible: false, // 不允許點外面關掉
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('是否要關閉程式？'),
          actions: [
             TextButton(
              onPressed: () {
                shouldExit = true;
                Navigator.of(context).pop(); // 關掉對話框
              },
              child: const Text('是'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關掉對話框
              },
              child: const Text('否'),
            ),
           
          ],
        );
      },
    );
    return shouldExit;
  }
}
