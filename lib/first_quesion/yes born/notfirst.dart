import 'package:flutter/material.dart';

class NotfirstWidget extends StatefulWidget {
  const NotfirstWidget({super.key});

  @override
  State<NotfirstWidget> createState() => _NotfirstWidget();
}

class _NotfirstWidget extends State<NotfirstWidget> {
  String? painindex;
  String? brokenskin;
  String? duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // 第一部分: 前次哺乳的乳頭疼痛指數
            const Positioned(
              top: 75,
              left: 135,
              child: Text(
                '前次哺乳的乳頭疼痛指數',
                textAlign: TextAlign.left,
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
              top: 100,
              left: 129,
              child: SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: painindex,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: const Text(
                    '次數',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((count) => DropdownMenuItem<String>(
                            value: count,
                            child: Text(count),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      painindex = value;
                    });
                  },
                ),
              ),
            ),
            // 第二部分: 是否有乳頭破皮的狀況發生?
            const Positioned(
              top: 200,
              left: 79,
              child: Text(
                '是否有乳頭破皮的狀況發生?',
                textAlign: TextAlign.left,
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
              top: 220,
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
                      groupValue: brokenskin,
                      onChanged: (value) {
                        setState(() {
                          brokenskin = value;
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
                      groupValue: brokenskin,
                      onChanged: (value) {
                        setState(() {
                          brokenskin = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 第三部分: 前胎哺乳持續時長誰幾個月?
            const Positioned(
              top: 300,
              left: 135,
              child: Text(
                '前胎哺乳持續時長誰幾個月?',
                textAlign: TextAlign.left,
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
              top: 320,
              left: 129,
              child: SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: duration,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: const Text(
                    '次數',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  items: ['0', '1', '2', '3', '4']
                      .map((count) => DropdownMenuItem<String>(
                            value: count,
                            child: Text(count),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      duration = value;
                    });
                  },
                ),
              ),
            ),
            if (duration != null)
              Positioned(
                top: 687,
                left: 129,
                child: SizedBox(
                  width: 154,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () {
                      // 下一步邏輯，跳轉到目標頁面
                      Navigator.pushNamed(context, '/StopWidget');
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
