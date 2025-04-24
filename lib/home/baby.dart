import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

final Logger logger = Logger();

final TextEditingController babyNameController = TextEditingController();
final TextEditingController babyBirthController = TextEditingController();
final TextEditingController babyGenderController = TextEditingController();
final TextEditingController babyWeightController = TextEditingController();
final TextEditingController babyHeightController = TextEditingController();

class BabyWidget extends StatefulWidget {
  final String userId; // 🔹 從登入或註冊時傳入的 userId
  final bool isManUser;
  const BabyWidget({super.key, required this.userId, required this.isManUser});

  @override
  State<BabyWidget> createState() => _BabyWidgetState();
}

class _BabyWidgetState extends State<BabyWidget> {
  bool hasSpecialCondition = false; // 是否有特殊狀況
  TextEditingController specialConditionController =
      TextEditingController(); // 輸入框控制器

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
            // **寶寶圖示**
            Positioned(
              top: screenHeight * 0.02,
              left: screenWidth * 0.06,
              child: Image.asset(
                'assets/images/Baby.png',
                width: screenWidth * 0.15,
              ),
            ),

            // **姓名**
            _buildInputRow(
                screenWidth, screenHeight * 0.15, '姓名', babyNameController),
            // **生日**
            Positioned(
              top: screenHeight * 0.23,
              left: screenWidth * 0.1, // 控制標籤與輸入框的水平位置
              child: SizedBox(
                width: screenWidth * 0.8, // 與其他輸入框寬度保持一致
                child: _buildDatePickerField('生日', babyBirthController),
              ),
            ),
            // **性別**
            Positioned(
              top: screenHeight * 0.31,
              left: screenWidth * 0.1,
              child: SizedBox(
                width: screenWidth * 0.8, // 調整寬度，確保佈局一致
                child: _buildGenderSelector(), // 使用性別選擇器方法
              ),
            ),
            // **出生體重**
            Positioned(
              top: screenHeight * 0.39,
              left: screenWidth * 0.1,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: _buildWeightPickerField('出生體重', babyWeightController),
              ),
            ),
            // **出生身高**
            Positioned(
              top: screenHeight * 0.47,
              left: screenWidth * 0.1,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: _buildHeightPickerField('出生身高', babyHeightController),
              ),
            ),

            Positioned(
              top: screenHeight * 0.60, // 調整文字的垂直位置
              left: screenWidth * 0.25,
              child: const Text(
                '寶寶出生是否有特殊狀況',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(147, 129, 108, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.65,
              left: screenWidth * 0.22,
              child: Row(
                children: [
                  // **無**
                  Checkbox(
                    value: !hasSpecialCondition,
                    onChanged: (bool? value) {
                      setState(() {
                        hasSpecialCondition = false; // 取消勾選"有"
                        specialConditionController.clear(); // 清空輸入框
                      });
                    },
                  ),
                  const Text(
                    '無',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1)),
                  ),
                  SizedBox(width: screenWidth * 0.2),

                  // **有**
                  Checkbox(
                    value: hasSpecialCondition,
                    onChanged: (bool? value) {
                      setState(() {
                        hasSpecialCondition = true;
                      });
                    },
                  ),
                  const Text(
                    '有',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1)),
                  ),
                ],
              ),
            ),

            // **如果選擇"有"，則顯示輸入框**
            if (hasSpecialCondition)
              Positioned(
                top: screenHeight * 0.70,
                left: screenWidth * 0.15,
                child: SizedBox(
                  width: screenWidth * 0.7,
                  child: TextField(
                    controller: specialConditionController,
                    decoration: const InputDecoration(
                      labelText: "請輸入特殊狀況",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

            // **填寫完成按鈕**
            Positioned(
              top: screenHeight * 0.80,
              left: screenWidth * 0.3,
              child: _buildButton(context, '填寫完成', Colors.brown.shade400, () {
                _saveBabyData(
                    widget.userId, // ✅ 傳入 userId
                    widget.isManUser,
                    babyNameController.text,
                    babyBirthController,
                    babyGenderController,
                    babyWeightController,
                    babyHeightController,
                    hasSpecialCondition,
                    specialConditionController);

                // ✅ **確保這裡傳遞的是 widget.userId**
                Navigator.pushNamed(context, '/BabyAccWidget', arguments: {
                  'userId': widget.userId,
                  'isManUser': widget.isManUser,
                } // ✅ **改為 widget.userId**
                    );
              }),
            ),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Transform.rotate(
                  angle: math.pi,
                  child: Container(
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/back.png'),
                        fit: BoxFit.fitWidth,
                      ),
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

  Widget _buildInputRow(double screenWidth, double top, String label,
      TextEditingController controller) {
    return Positioned(
      top: top,
      left: screenWidth * 0.10, // Label 起始位置
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.36, // Label 寬度（固定比例）
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(147, 129, 108, 1),
                fontFamily: 'Inter',
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.44 + 0.5, // TextField 寬度（固定比例）
            height: 32, // TextField 高度
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // **按鈕 Widget**
  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120, // 標籤寬度，確保與其他標籤一致
          child: const Text(
            '性別',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 男生選項
              Row(
                children: [
                  Radio<String>(
                    value: '男生',
                    groupValue: babyGenderController.text,
                    onChanged: (value) {
                      setState(() {
                        babyGenderController.text = value ?? '';
                      });
                    },
                  ),
                  const Text(
                    '男生',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(147, 129, 108, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20), // 男生和女生之間的間距

              // 女生選項
              Row(
                children: [
                  Radio<String>(
                    value: '女生',
                    groupValue: babyGenderController.text,
                    onChanged: (value) {
                      setState(() {
                        babyGenderController.text = value ?? '';
                      });
                    },
                  ),
                  const Text(
                    '女生',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(147, 129, 108, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

// 體重選擇器功能
  Widget _buildWeightPickerField(
      String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140, // Label 寬度
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _showWeightPicker(context, controller),
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// 身高選擇器功能
  Widget _buildHeightPickerField(
      String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140, // Label 寬度
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _showHeightPicker(context, controller),
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// 身高選擇功能
  void _showHeightPicker(
      BuildContext context, TextEditingController controller) {
    int selectedHeight = controller.text.isNotEmpty
        ? int.parse(controller.text.replaceAll(' cm', ''))
        : 50; // 預設值改為 115cm

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedHeight - 20, // 偏移值改為從 80 開始
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    selectedHeight = index + 20; // 偏移值改為 +80
                  },
                  children: List<Widget>.generate(71, (int index) {
                    return Center(
                        child: Text('${index + 20} cm')); // 生成 80~150 的選項
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.text = '$selectedHeight cm'; // 更新控制器的值
                  Navigator.pop(context); // 關閉彈出視窗
                },
                child: const Text("確定"),
              ),
            ],
          ),
        );
      },
    );
  }

// 體重選擇功能
  void _showWeightPicker(
      BuildContext context, TextEditingController controller) {
    double selectedWeight = controller.text.isNotEmpty
        ? double.parse(controller.text.replaceAll(' kg', ''))
        : 3.0; // 預設值改為 3.0 kg

    final List<String> weightOptions = List.generate(71, (index) {
      return (index / 10).toStringAsFixed(1); // 生成 0.0 ~ 7.0 (0.1 間隔)
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: (selectedWeight * 10).round(), // 對應至0.1間隔
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    selectedWeight = index / 10; // 轉為小數點後一位
                  },
                  children: weightOptions
                      .map((weight) => Center(child: Text('$weight kg')))
                      .toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.text = '${selectedWeight.toStringAsFixed(1)} kg';
                  Navigator.pop(context);
                },
                child: const Text("確定"),
              ),
            ],
          ),
        );
      },
    );
  }

  // 日期選擇器
  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140, // 標籤寬度
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40, // 與其他輸入框高度一致
            child: TextField(
              controller: controller,
              readOnly: true, // 禁止手動輸入
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context, // 確保傳入正確 context
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  locale: const Locale("zh", "TW"),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.year}年${pickedDate.month}月${pickedDate.day}日";
                  setState(() {
                    controller.text = formattedDate; // 更新日期
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

void _saveBabyData(
    String userId,
    bool isManUser,
    String babyName,
    TextEditingController babyBirthController,
    TextEditingController babyGenderController,
    TextEditingController babyWeightController,
    TextEditingController babyHeightController,
    bool hasSpecialCondition,
    TextEditingController specialConditionController) async {
  try {
    // ✅ **使用寶寶姓名作為 docId**（可以根據需求調整）
    String babyId = babyName.isNotEmpty
        ? babyName
        : DateTime.now().millisecondsSinceEpoch.toString();

     await FirebaseFirestore.instance
        .collection(isManUser ? 'Man_users' : 'users')
        .doc(userId)
        .collection('baby')
        .doc(babyId)
        .set({
      '姓名': babyName,
      '生日': babyBirthController.text,
      '性別': babyGenderController.text,
      '出生體重': babyWeightController.text,
      '出生身高': babyHeightController.text,
      '寶寶出生特殊狀況': hasSpecialCondition
          ? specialConditionController.text
          : null,
      '填寫時間': FieldValue.serverTimestamp(),
    });
    logger.i("✅ 寶寶資訊已儲存到 Firestore users/$userId/baby/$babyId");

    // 2. 再呼叫後端 API，同步到 MySQL
    await sendBabyDataToMySQL(
      userId: userId,
      isManUser: isManUser,
      babyName: babyName,
      babyBirth: babyBirthController.text,
      babyGender: babyGenderController.text,
      babyWeight: babyWeightController.text,
      babyHeight: babyHeightController.text,
      hasSpecialCondition: hasSpecialCondition,
      babySolutionDetails: specialConditionController.text,
    );
  } catch (e) {
    logger.e("❌ _saveBabyData 發生錯誤: $e");
  }
}

String formatBirthForMySQL(String text) {
    try {
      final parsed = DateFormat('yyyy年MM月dd日', 'zh_TW').parse(text);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return ""; // 防呆處理，避免錯誤時整個崩潰
    }
  }


 Future<void> sendBabyDataToMySQL({
  required String userId,
  required bool isManUser,
  required String babyName,
  required String babyBirth,
  required String babyGender,
  required String babyWeight,
  required String babyHeight,
  required bool hasSpecialCondition,
 String? babySolutionDetails,
}) async {
  final uri = Uri.parse('http://163.13.201.85:3000/baby');

  // 1) 先放所有「必填」欄位
  final payload = <String, dynamic>{
    'baby_name':      babyName,                       // 一定要有
    'baby_birthdate': formatBirthForMySQL(babyBirth),
    'baby_gender':    babyGender,
    'baby_weight':    double.tryParse(
                         babyWeight.replaceAll(RegExp(r'[^0-9.]'), '')),
    'baby_height':    double.tryParse(
                         babyHeight.replaceAll(RegExp(r'[^0-9.]'), '')),
    'baby_solution':  hasSpecialCondition ? '有' : '無',
  };

 if (hasSpecialCondition && babySolutionDetails != null && babySolutionDetails.isNotEmpty) {
    payload['baby_solution_details'] = babySolutionDetails;
  }

  // 2) 再「擇一」加入 user_id 或 man_user_id
  final idInt = int.tryParse(userId);
  if (idInt == null) {
    logger.e("❌ userId 無法轉成 int：$userId");
    return;
  }
  if (isManUser) {
    payload['man_user_id'] = idInt;
  } else {
    payload['user_id'] = idInt;
  }

  // 3) （可選）再檢查一次，確保所有必填 key 都在
  assert(payload.containsKey('baby_name')
         && payload.containsKey(isManUser ? 'man_user_id' : 'user_id'));

  logger.i("📦 傳送至後端 MySQL 的 payload：$payload");

  try {
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      logger.i("✅ 後端同步成功：${resp.body}");
    } else {
      logger.e("❌ 後端同步失敗 (狀態 ${resp.statusCode})：${resp.body}");
    }
  } catch (e) {
    logger.e("🔥 sendBabyDataToMySQL 發生錯誤：$e");
  }
}


