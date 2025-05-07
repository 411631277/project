import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_2/first_question/first_breastfeeding.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger logger = Logger();

class NotfirstWidget extends StatefulWidget {
  final String userId;
  const NotfirstWidget({super.key, required this.userId});

  @override
  State<NotfirstWidget> createState() => _NotfirstWidgetState();
}

class _NotfirstWidgetState extends State<NotfirstWidget> {
  String? painindex;
  String? brokenskin;
  String? selectedDuration;
  bool isLoading = true; // 🔹 Firestore 資料加載中狀態

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore(); // 🔹 初始化時載入 Firestore 的數據
  }

  /// **🔹 從 Firestore 讀取數據**
  Future<void> _loadDataFromFirestore() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          painindex = userData['前次哺乳乳頭疼痛次數']?.toString();
          brokenskin = userData['是否有乳頭破皮']?.toString();
         final original = userData['前胎哺乳持續時長']?.toString();
         selectedDuration = original?.replaceAll(' 個月', '');
          isLoading = false;
        });
      } else {
        logger.w("⚠️ 找不到 userId: ${widget.userId} 的 Firestore 文檔");
        setState(() => isLoading = false);
      }
    } catch (e) {
      logger.e("❌ 加載 Firestore 數據失敗: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 🔹 Firestore 還在加載時顯示 Loading
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 檢查是否所有問題都填答
    final isAllAnswered =
        painindex != null && brokenskin != null && selectedDuration != null;

    return PopScope(
    canPop: false,
    child: Scaffold(
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
              child: const Text(
                '前次哺乳的乳頭疼痛指數',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontSize: 20,
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
                  hint: const Text('請選擇'),
                  items: ['0', '1', '2', '3', '4', '5']
                      .map((paincount) => DropdownMenuItem<String>(
                            value: paincount,
                            child: Text(paincount),
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
              child: const Text(
                '是否有乳頭破皮的狀況發生?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontSize: 20,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.35,
              left: screenWidth * 0.2,
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: const Text('是'),
                      value: 'yes',
                      groupValue: brokenskin,
                      onChanged: (value) {
                        setState(() {
                          brokenskin = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: RadioListTile<String>(
                      title: const Text('否'),
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
                  value: selectedDuration,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: const Text('請選擇', textAlign: TextAlign.center),
                  items: List.generate(25, (index) => index.toString())
                      .map((month) => DropdownMenuItem<String>(
                            value: month,
                            child:
                                Text('$month 個月', textAlign: TextAlign.center),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value;
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
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .set({
                          "前次哺乳乳頭疼痛次數": painindex,
                          "是否有乳頭破皮": brokenskin,
                          "前胎哺乳持續時長": "$selectedDuration 個月",
                        }, SetOptions(merge: true)); // 🔹 保留先前數據

                        await sendNotFirstDataToMySQL(
                            widget.userId, painindex!, brokenskin!, selectedDuration!);

                        logger.i("✅ Firestore 更新成功，userId: ${widget.userId}");

                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FirstBreastfeedingWidget(userId: widget.userId),
                          ),
                        );
                      } catch (e) {
                        logger.e("❌ Firestore 更新失敗: $e");
                      }
                    },
                    child: const Text("下一步"),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  Future<void> sendNotFirstDataToMySQL(String userId, String painIndex,
      String brokenSkin, String selectedDuration) async {
    final url = Uri.parse('http://163.13.201.85:3000/user_question');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': int.parse(userId),
        'previous_nipple_pain_level': painIndex,
        'nipple_cracking': brokenSkin == 'yes' ? '是'  : '否',
        'previous_breastfeeding_selectedDuration_months': int.parse(selectedDuration),
      }),
    );

    if (response.statusCode == 200) {
      logger.i("✅ 哺乳經驗同步至 MySQL 成功");
    } else {
      logger.e("❌ 同步至 MySQL 失敗: ${response.body}");
    }
  }
}
