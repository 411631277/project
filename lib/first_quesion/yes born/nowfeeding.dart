import 'package:flutter/material.dart';

class Nowfeeding extends StatefulWidget {
  const Nowfeeding({super.key});

  @override
  State<Nowfeeding> createState() => _Nowfeeding();
}

class _Nowfeeding extends State<Nowfeeding> {
  String? purebreastmilk;
  String? firstime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            const Positioned(
              top: 360,
              left: 79,
              child: Text(
                '新生兒哺乳是否為純母乳??',
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
              top: 380,
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
                      groupValue: purebreastmilk,
                      onChanged: (value) {
                        setState(() {
                          purebreastmilk = value;
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
                      groupValue: purebreastmilk,
                      onChanged: (value) {
                        setState(() {
                          purebreastmilk = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 第二部分: 是否為首次哺乳??
            const Positioned(
              top: 450,
              left: 57,
              child: Text(
                '是否為首次哺乳?',
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
              top: 470,
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
                      groupValue: firstime,
                      onChanged: (value) {
                        setState(() {
                          firstime = value;
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
                      groupValue: firstime,
                      onChanged: (value) {
                        setState(() {
                          firstime = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 下一步按鍵
            if (firstime != null)
              Positioned(
                top: 709,
                left: 129,
                child: SizedBox(
                  width: 154,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () {
                      if (firstime == 'yes') {
                        Navigator.pushNamed(
                            context, '/FirstBreastfeedingWidget');
                      } else if (firstime == 'no') {
                        Navigator.pushNamed(context, '/NotfirstWidget');
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
            // 返回按鍵
            Positioned(
              top: 560,
              left: 94,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // 返回上一頁
                },
                child: Container(
                  width: 61,
                  height: 65,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/back.png'),
                      fit: BoxFit.fitWidth,
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
