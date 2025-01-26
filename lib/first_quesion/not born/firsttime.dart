import 'package:flutter/material.dart';

class FirsttimeWidget extends StatefulWidget {
  const FirsttimeWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirsttimeWidgetState createState() => _FirsttimeWidgetState();
}

class _FirsttimeWidgetState extends State<FirsttimeWidget> {
  String? answer; // 用於儲存「是」或「否」的回答

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // 問題文字
            const Positioned(
              top: 317,
              left: 90,
              child: Text(
                '是否為第一次生產?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              top: 370,
              left: 89,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 是選項
                  SizedBox(
                    width: 120,
                    child: RadioListTile<String>(
                      title: const Text(
                        '是',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'yes',
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value;
                        });
                      },
                    ),
                  ),
                  // 否選項
                  SizedBox(
                    width: 120,
                    child: RadioListTile<String>(
                      title: const Text(
                        '否',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(147, 129, 108, 1),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      value: 'no',
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 下一步按鍵
            if (answer != null)
              Positioned(
                top: 553,
                left: 126,
                child: SizedBox(
                  width: 154,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () {
                      if (answer == 'yes') {
                        Navigator.pushNamed(
                            context, '/FinishWidget'); // 替換為「是」的頁面路徑
                      } else {
                        Navigator.pushNamed(context,
                            '/Breastfeeding_durationWidget'); // 替換為「否」的頁面路徑
                      }
                    },
                    child: const Text(
                      '下一步',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
