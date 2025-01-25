import 'package:flutter/material.dart';

class FrequencyWidget extends StatefulWidget {
  const FrequencyWidget({super.key});

  @override
  State<FrequencyWidget> createState() => _FrequencyWidgetState();
}

class _FrequencyWidgetState extends State<FrequencyWidget> {
  String? breastfeedingAnswer; // 存儲親自哺乳的回答
  String? pregnancyCount; // 懷孕次數
  String? deliveryCount; // 生產次數

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Stack(
          children: <Widget>[
            // 第一部分: 懷孕次數
            const Positioned(
              top: 134,
              left: 135,
              child: Text(
                '懷孕次數',
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
              top: 200,
              left: 129,
              child: SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: pregnancyCount,
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
                      pregnancyCount = value;
                    });
                  },
                ),
              ),
            ),
            // 第二部分: 是否發生過妊娠合併症
            const Positioned(
              top: 317,
              left: 135,
              child: Text(
                '生產次數',
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
              top: 387,
              left: 129,
              child: SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: deliveryCount,
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
                      deliveryCount = value;
                    });
                  },
                ),
              ),
            ),
            // 第三部分: 新生兒誕生後是否願意親自哺餵母乳?
            const Positioned(
              top: 462,
              left: 135,
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
              top: 559,
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
                      groupValue: breastfeedingAnswer,
                      onChanged: (value) {
                        setState(() {
                          breastfeedingAnswer = value;
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
                      groupValue: breastfeedingAnswer,
                      onChanged: (value) {
                        setState(() {
                          breastfeedingAnswer = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 下一步按鍵
            if (breastfeedingAnswer != null)
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
                      if (breastfeedingAnswer == 'yes') {
                        Navigator.pushNamed(
                            context, '/FirstBreastfeedingWidget');
                      } else if (breastfeedingAnswer == 'no') {
                        Navigator.pushNamed(context, '/SuccessWidget');
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
              top: 756,
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
