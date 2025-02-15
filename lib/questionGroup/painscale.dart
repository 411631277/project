import 'package:flutter/material.dart';
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
  bool isNaturalBirth = false;
  bool isCSection = false;
  bool usedSelfPainControl = false;
  bool notUsedSelfPainControl = false;
  double painLevel = 0;

  bool get isAllAnswered {
    if (isNaturalBirth) {
      return true; // 如果選擇自然產，直接顯示下一步按鈕
    } else if (isCSection) {
      return usedSelfPainControl || notUsedSelfPainControl; // 剖腹產需要額外選擇
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

            // 添加 "孩子出生的方式" 標題
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

            // 生產方式選項
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 水平置中
              children: [
                Column(
                  children: [
                    Checkbox(
                      value: isNaturalBirth,
                      onChanged: (value) {
                        setState(() {
                          isNaturalBirth = value!;
                          if (value) {
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
                const SizedBox(width: 50), // 選項間距
                Column(
                  children: [
                    Checkbox(
                      value: isCSection,
                      onChanged: (value) {
                        setState(() {
                          isCSection = value!;
                          if (value) {
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

            // 疼痛指數滑桿
            Padding(
              padding: const EdgeInsets.only(left: 92), // 調整數值，增加左邊間距
              child: const Text("會陰/剖腹傷口疼痛指數"),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/happy.png', // 不痛的圖片
                      width: 40, // 設定圖片寬度
                      height: 40, // 設定圖片高度
                    ),
                    const Text("不痛"),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/sad.png', // 非常痛的圖片
                      width: 40, // 設定圖片寬度
                      height: 40, // 設定圖片高度
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

            // 是否使用自控式止痛選項
            if (isCSection) // 剖腹產時顯示
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 75), // 調整數值，增加左邊間距
                    child: const Text(
                      "是否有使用自控式止痛\n    (僅限剖腹產勾選)",
                      style: TextStyle(
                        color: Colors.red, // 設置文字顏色為藍色
                        fontSize: 16, // 可選：調整文字大小
                        fontWeight: FontWeight.bold, // 可選：設定文字加粗
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 水平置中
                    children: [
                      Column(
                        children: [
                          Checkbox(
                            value: usedSelfPainControl,
                            onChanged: (value) {
                              setState(() {
                                usedSelfPainControl = value!;
                                if (value) notUsedSelfPainControl = false;
                              });
                            },
                          ),
                          const Text("是"),
                        ],
                      ),
                      const SizedBox(width: 50), // 選項間距
                      Column(
                        children: [
                          Checkbox(
                            value: notUsedSelfPainControl,
                            onChanged: (value) {
                              setState(() {
                                notUsedSelfPainControl = value!;
                                if (value) usedSelfPainControl = false;
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

            // 按鈕區域
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              // 下一步按鈕
              // 下一步按鈕
              if (isAllAnswered)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.brown.shade400,
                  ),
                  onPressed: () async {
                    bool success = await _saveAnswersToFirebase();
                    if (!context.mounted || !success) return;

                    Navigator.pushNamed(context, '/FinishWidget',
                        arguments: widget.userId);
                  },
                  child: const Text(
                    "下一步",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }

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

      // 儲存到 Firebase
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("questions")
          .doc(documentName)
          .set(dataToSave);

      logger.i("✅ 疼痛分數問卷已成功儲存！");
      return true;
    } catch (e) {
      logger.e("❌ 儲存疼痛分數問卷時發生錯誤：$e");
      return false;
    }
  }
}
