import 'package:flutter/material.dart';

class NotfirstWidget extends StatefulWidget {
  const NotfirstWidget({super.key, required String userId});

  @override
  State<NotfirstWidget> createState() => _NotfirstWidget();
}

class _NotfirstWidget extends State<NotfirstWidget> {
  String? painindex;
  String? brokenskin;
  String? duration;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 檢查是否所有問題都填答
    final isAllAnswered =
        painindex != null && brokenskin != null && duration != null;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // **第一部分: 前次哺乳的乳頭疼痛指數**
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.2,
              child: Text(
                '前次哺乳的乳頭疼痛指數',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.2,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
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
                    '請選擇',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  items: ['0', '1', '2', '3', '4', '5']
                      .map((count) => DropdownMenuItem<String>(
                            value: count,
                            child: Text(
                              count,
                              textAlign: TextAlign.center,
                            ),
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

            // **第二部分: 是否有乳頭破皮的狀況發生?**
            Positioned(
              top: screenHeight * 0.3,
              left: screenWidth * 0.2,
              child: Text(
                '是否有乳頭破皮的狀況發生?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // **是選項**
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '是',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromRGBO(147, 129, 108, 1),
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
                  // **否選項**
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: Text(
                        '否',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromRGBO(147, 129, 108, 1),
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

            // **第三部分: 前胎哺乳持續時長**
            Positioned(
              top: screenHeight * 0.45,
              left: screenWidth * 0.25,
              child: Text(
                '前胎哺乳持續時長?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(147, 129, 108, 1),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.5,
              left: screenWidth * 0.25,
              child: SizedBox(
                width: screenWidth * 0.5,
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
                    '請選擇',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  items: List.generate(25, (index) => index.toString())
                      .map((month) => DropdownMenuItem<String>(
                            value: month,
                            child: Text(
                              '$month 個月',
                              textAlign: TextAlign.center,
                            ),
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

            // **「下一步」按鈕**
            if (isAllAnswered)
              Positioned(
                top: screenHeight * 0.75,
                left: screenWidth * 0.3,
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/StopWidget');
                    },
                    child: Text(
                      '下一步',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontFamily: 'Inter',
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
