import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

final TextEditingController babyNameController = TextEditingController();
final TextEditingController babyBirthController = TextEditingController();
final TextEditingController babyGenderController = TextEditingController();
final TextEditingController babyWeightController = TextEditingController();
final TextEditingController babyHeightController = TextEditingController();

class BabyWidget extends StatefulWidget {
  final String userId;
  final bool isManUser;
  const BabyWidget({super.key, required this.userId, required this.isManUser});

  @override
  State<BabyWidget> createState() => _BabyWidgetState();
}

class _BabyWidgetState extends State<BabyWidget> {
  bool hasSpecialCondition = false;
  TextEditingController specialConditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: SafeArea(
    child: Container(
      color: const Color.fromRGBO(233, 227, 213, 1),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/Baby.png', width: 60),
              const SizedBox(height: 20),
              _buildInputRow('姓名', babyNameController),
              const SizedBox(height: 15),
              _buildDatePickerField('生日', babyBirthController),
              const SizedBox(height: 15),
              _buildGenderSelector(),
              const SizedBox(height: 15),
              _buildWeightPickerField('出生體重', babyWeightController),
              const SizedBox(height: 15),
              _buildHeightPickerField('出生身高', babyHeightController),
              const SizedBox(height: 25),
              Center(
                child: const Text(
                  '寶寶出生是否有特殊狀況',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(147, 129, 108, 1)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: !hasSpecialCondition,
                    onChanged: (val) {
                      setState(() {
                        hasSpecialCondition = false;
                        specialConditionController.clear();
                      });
                    },
                  ),
                  const Text('無'),
                  const SizedBox(width: 30),
                  Checkbox(
                    value: hasSpecialCondition,
                    onChanged: (val) {
                      setState(() {
                        hasSpecialCondition = true;
                      });
                    },
                  ),
                  const Text('有'),
                ],
              ),
              if (hasSpecialCondition)
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 40),
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
              const SizedBox(height: 100), // 留空位避免底部按鈕蓋住
            ],
          ),
        ),
      ),
    ),
  ),
  bottomNavigationBar: Container(
  color: const Color.fromRGBO(233, 227, 213, 1), // ✅ 設定背景色
  padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 16),
  child: Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Transform.rotate(
          angle: 3.1416,
          child: Image.asset(
            'assets/images/back.png',
            width: 60,
          ),
        ),
      ),
      const Spacer(),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        ),
        onPressed: () {
          _saveBabyData(
            widget.userId,
            widget.isManUser,
            babyNameController.text,
            babyBirthController,
            babyGenderController,
            babyWeightController,
            babyHeightController,
            hasSpecialCondition,
            specialConditionController,
          );
          Navigator.pushNamed(context, '/BabyAccWidget', arguments: {
            'userId': widget.userId,
            'isManUser': widget.isManUser,
          });
        },
        child: const Text('填寫完成', style: TextStyle(fontSize: 18, color: Colors.white,)),
      ),
    ],
  ),
),


    );
  }

  Widget _buildInputRow(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1))),
        ),
        const SizedBox(width: 10),
       Expanded(
  child: Align(
    alignment: Alignment.centerRight,
    child: SizedBox(
      width: 160, // 跟身高體重一致
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        ),
      ),
    ),
  ),
)]);   
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        const SizedBox(
          width: 80,
          child: Text('性別', style: TextStyle(fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1))),
        ),
        const SizedBox(width: 10),
        Expanded(
  child: Align(
    alignment: Alignment.centerRight,
    child: Row(
      mainAxisSize: MainAxisSize.min,
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
        const Text('男生'),
        const SizedBox(width: 20),
        Radio<String>(
          value: '女生',
          groupValue: babyGenderController.text,
          onChanged: (value) {
            setState(() {
              babyGenderController.text = value ?? '';
            });
          },
        ),
        const Text('女生'),
      ],
    ),
  ),
),
      ]
    );
  }

  Widget _buildWeightPickerField(String label, TextEditingController controller) {
    return _buildPickerRow(label, controller, 0.0, 7.0, 0.1, 'kg');
  }

  Widget _buildHeightPickerField(String label, TextEditingController controller) {
    return _buildPickerRow(label, controller, 20, 90, 1, 'cm');
  }

  Widget _buildPickerRow(String label, TextEditingController controller, double start, double end, double step, String unit) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 160,
              child: GestureDetector(
                onTap: () => _showPicker(context, controller, start, end, step, unit),
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
          ),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context, TextEditingController controller, double start, double end, double step, String unit) {
    final values = <String>[];
    for (double val = start; val <= end; val += step) {
      values.add(val.toStringAsFixed(step < 1 ? 1 : 0));
    }
    int initialIndex = controller.text.isNotEmpty
        ? values.indexWhere((v) => controller.text.contains(v))
        : 0;

    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(initialItem: initialIndex),
                onSelectedItemChanged: (index) {
                  controller.text = '${values[index]} $unit';
                },
                children: values.map((e) => Center(child: Text('$e $unit'))).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("確定"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1))),
        ),
        const SizedBox(width: 10),
      Expanded(
  child: Align(
    alignment: Alignment.centerRight,
    child: SizedBox(
      width: 160, // 同樣改成 160
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  locale: const Locale("zh", "TW"),
                );
                if (picked != null) {
                  controller.text = '${picked.year}年${picked.month}月${picked.day}日';
                }
              },
            ),
          ),
        ),
     ) ],
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


