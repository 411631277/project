//會陰疼痛量表
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Logger logger = Logger();

class PainScaleWidget extends StatefulWidget {
  final String userId;
  const PainScaleWidget({super.key, required this.userId});

  @override
  State<PainScaleWidget> createState() => _PainScaleWidgetState();
}

class _PainScaleWidgetState extends State<PainScaleWidget> {
  bool isNaturalBirth = false;         // 是否自然產
  bool isCSection = false;             // 是否剖腹產
  bool usedSelfPainControl = false;    // 是否有使用自控式止痛
  bool notUsedSelfPainControl = false; // 是否沒有使用自控式止痛
  double painLevel = 0;                // 疼痛指數 (0 ~ 10)

  /// 判斷是否已完成所有必填項目
  bool get isAllAnswered {
    if (isNaturalBirth) {
      return true; 
    } else if (isCSection) {
      // 剖腹產還需判斷是否選了自控式止痛
      return usedSelfPainControl || notUsedSelfPainControl;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "會陰疼痛分數計算",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 45),

            // **孩子出生的方式**
            const Center(
              child: Text(
                "孩子出生的方式",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(147, 129, 108, 1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // **生產方式選項 (自然產 / 剖腹產)**
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Checkbox(
                      value: isNaturalBirth,
                      onChanged: (value) {
                        setState(() {
                          isNaturalBirth = value ?? false;
                          if (isNaturalBirth) {
                            // 取消剖腹產相關選項
                            isCSection = false;
                            usedSelfPainControl = false;
                            notUsedSelfPainControl = false;
                          }
                        });
                      },
                    ),
                    const Text("自然產"),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Checkbox(
                      value: isCSection,
                      onChanged: (value) {
                        setState(() {
                          isCSection = value ?? false;
                          if (isCSection) {
                            // 取消自然產
                            isNaturalBirth = false;
                          }
                        });
                      },
                    ),
                    const Text("剖腹產"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),

            // **疼痛指數滑桿標題**
            const Padding(
              padding: EdgeInsets.only(left: 92),
              child: Text("會陰/剖腹傷口疼痛指數"),
            ),
            const SizedBox(height: 30),

            // **疼痛指數滑桿 (0 ~ 10)**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/happy.png', // 不痛的表情
                      width: 40,
                      height: 40,
                    ),
                    const Text("不痛"),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/sad.png',   // 非常痛的表情
                      width: 40,
                      height: 40,
                    ),
                    const Text("非常痛"),
                  ],
                ),
              ],
            ),
            Slider(
              value: painLevel,
              min: 0,
              max: 10,
              divisions: 10,
              label: painLevel.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  painLevel = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // **是否使用自控式止痛 (僅剖腹產時顯示)**
            if (isCSection)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 75),
                    child: Text(
                      "是否有使用自控式止痛\n    (僅限剖腹產勾選)",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Checkbox(
                            value: usedSelfPainControl,
                            onChanged: (value) {
                              setState(() {
                                usedSelfPainControl = value ?? false;
                                if (usedSelfPainControl) {
                                  notUsedSelfPainControl = false;
                                }
                              });
                            },
                          ),
                          const Text("是"),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: [
                          Checkbox(
                            value: notUsedSelfPainControl,
                            onChanged: (value) {
                              setState(() {
                                notUsedSelfPainControl = value ?? false;
                                if (notUsedSelfPainControl) {
                                  usedSelfPainControl = false;
                                }
                              });
                            },
                          ),
                          const Text("否"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            const Spacer(),

            // **按鈕區域**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // **返回按鈕**
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Image.asset(
                      'assets/images/back.png',
                      width: screenWidth * 0.15,
                    ),
                  ),
                ),

                // **下一步按鈕：所有問題回答後才顯示**
                if (isAllAnswered)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: () async {
                      final success = await _saveAnswersToFirebase();
                      if (!context.mounted || !success) return;

                      // 成功儲存後導頁 (或可改成 pop 回到上一頁)
                      Navigator.pushNamed(
                        context,
                        '/FinishWidget',
                        arguments: widget.userId,
                      );
                    },
                    child: const Text(
                      "填答完成",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 將作答結果儲存到 Firestore，並更新 painScaleCompleted = true
  Future<bool> _saveAnswersToFirebase() async {
    try {
      final String documentName = "PainScaleWidget";

      // 組合資料
      final Map<String, dynamic> dataToSave = {
        "birthType": isNaturalBirth
            ? "自然產"
            : isCSection
                ? "剖腹產"
                : null,
        "painLevel": painLevel,
        "usedSelfPainControl": isCSection
            ? (usedSelfPainControl
                ? "是"
                : notUsedSelfPainControl
                    ? "否"
                    : null)
            : null,
        "timestamp": Timestamp.now(),
      };

      // 1. 儲存問卷內容到 users/{userId}/questions/{documentName}
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc(documentName)
          .set(dataToSave);

      // 2. 更新 painScaleCompleted = true，讓主問卷列表可顯示已完成
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .update({"painScaleCompleted": true});

      logger.i("✅ 疼痛分數問卷已成功儲存，並更新 painScaleCompleted！");
      await sendPainScaleToMySQL(widget.userId);

      return true;
      
    } catch (e) {
      logger.e("❌ 儲存疼痛分數問卷時發生錯誤：$e");
      return false;
    }
  }
  Future<void> sendPainScaleToMySQL(String userId) async {
  final url = Uri.parse('http://163.13.201.85:3000/painscale');

  final now = DateTime.now();
  final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final birthType = isNaturalBirth
      ? "自然產"
      : isCSection
          ? "剖腹產"
          : null;

  final painControl = isCSection
      ? (usedSelfPainControl
          ? "是"
          : notUsedSelfPainControl
              ? "否"
              : null)
      : null;

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': int.parse(userId),
      'painscale_question_content': "會陰疼痛量表",
      'painscale_test_date': formattedDate,
      'childbirth_method': birthType,
      'pain_level': painLevel.toInt(),
      'used_self_controlled_pain_relief': painControl,
    }),
  );

 if (response.statusCode >= 200 && response.statusCode < 300) {
    logger.i("✅ 疼痛分數已同步到 MySQL！");
  } else {
    logger.e("❌ 疼痛分數同步 MySQL 失敗: ${response.body}");
  }
}


}

