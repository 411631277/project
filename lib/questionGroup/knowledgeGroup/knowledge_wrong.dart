import 'package:doctor_2/first_question/finish.dart';
import 'package:flutter/material.dart';

class WrongAnswersPage extends StatelessWidget {
  final List<Map<String, dynamic>> wrongAnswers;
  final String userId;
  final bool isManUser;


  const WrongAnswersPage({
    super.key,
    required this.wrongAnswers,
    required this.userId,
    required this.isManUser,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
       backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.05),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: ListView.builder(
              itemCount: wrongAnswers.length,
              itemBuilder: (context, index) {
                final item = wrongAnswers[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5E1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['question'],
                          style: TextStyle(fontSize: screenWidth * 0.045),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          '你的回答：${item['userAnswer']}',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        Text(
                          '正確答案：${item['correctAnswer']}',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.1,
            ),
            child: SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade400,
                ),
                onPressed: () {
                   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinishWidget(
          userId: userId,
          isManUser: isManUser,
        ),
      ),
    );
                },
                child: Text(
                  '下一步',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
