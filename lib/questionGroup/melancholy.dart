import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class MelancholyWidget extends StatefulWidget {
  final String userId; // 接收 userId
  const MelancholyWidget({super.key, required this.userId});

  @override
  State<MelancholyWidget> createState() => _MelancholyWidgetState();
}

class _MelancholyWidgetState extends State<MelancholyWidget> {
  late final List<int> responses;
  final List<String> questions = [
    // 提升到類成員
    '我能開懷的笑並看到事物有趣的一面',
    '我能夠以快樂的心情來期待事情',
    '當事情不順利時，我會不必要的責備自己',
    '我會無緣無故感到焦慮和擔心',
    '我會無緣無故感到害怕和驚慌',
    '事情壓得我喘不過氣',
    '我很不開心以致失眠',
    '我感到悲傷和難過',
    '我的不快樂導致我哭泣',
    '我會有傷害自己的想法',
  ];

  @override
  void initState() {
    super.initState();
    responses = List.filled(questions.length, -1); // 根據題目數量初始化
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '產後憂鬱量表',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length, // 題目數量動態獲取
                itemBuilder: (context, index) {
                  return _buildQuestionRow(index, screenWidth);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 返回按鈕
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.rotate(
                    angle: math.pi, // 旋轉 180 度 (弧度制，180 度 = π 弧度)
                    child: Image.asset(
                      'assets/images/back.png',
                      width: screenWidth * 0.15,
                    ),
                  ),
                ),
                // 填答完按鈕（所有問題都回答後才會顯示）
                if (!responses.contains(-1))
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: () async {
                      await _saveAnswersToFirebase();
                      if (!context.mounted) return;
                      Navigator.pushNamed(
                        context,
                        '/FinishWidget',
                        arguments: widget.userId,
                      );
                    },
                    child: const Text(
                      "下一步",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 建立題目選項
  Widget _buildQuestionRow(int questionIndex, double screenWidth) {
    final List<String> options = ["很好", "好", "不好", "很不好"]; // 選項文字

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${questionIndex + 1}. ${questions[questionIndex]}',
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(147, 129, 108, 1),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4, // 選項數量 0, 1, 2, 3
            (optionIndex) => Row(
              children: [
                Radio<int>(
                  value: optionIndex,
                  groupValue: responses[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      responses[questionIndex] = value!;
                    });
                  },
                ),
                Text(
                  options[optionIndex], // 將選項文字顯示
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(147, 129, 108, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.grey), // 分隔線
      ],
    );
  }

  Future<bool> _saveAnswersToFirebase() async {
    try {
      final CollectionReference userResponses = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection("questions");

      await userResponses.doc('melancholy').set({
        'responses': responses,
        'timestamp': FieldValue.serverTimestamp(),
      });

      logger.i("✅ 問卷已成功儲存！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存問卷時發生錯誤：$e");
      return false;
    }
  }
}
