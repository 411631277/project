import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;
import 'package:doctor_2/services/backend3000/backend3000.dart';

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
  body: GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus(); // 點擊空白處收起鍵盤
    },
    child: SingleChildScrollView(
     
      child: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 227, 213, 1),
        ),
        child: Stack(
          children: <Widget>[
          // ---------- 原本的 Scrollable 欄位放這裡 ----------
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 16),
                  child: Image.asset(
                    'assets/images/Baby.png',
                    width: 80,
                  ),
                ),
                _buildInputRow('姓名', babyNameController),
                _buildDatePickerField('生日', babyBirthController),
                _buildGenderSelector(),
                _buildWeightPickerField('出生體重', babyWeightController),
                _buildHeightPickerField('出生身高', babyHeightController),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // ---------- 寶寶出生是否有特殊狀況 (跟原版一樣) ----------
          Positioned(
            top: screenHeight * 0.68,
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
            top: screenHeight * 0.73,
            left: screenWidth * 0.22,
            child: Row(
              children: [
                Checkbox(
                  value: !hasSpecialCondition,
                  onChanged: (v) {
                    setState(() {
                      hasSpecialCondition = false;
                      specialConditionController.clear();
                    });
                  },
                ),
                const Text('無',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1))),
                SizedBox(width: screenWidth * 0.2),
                Checkbox(
                  value: hasSpecialCondition,
                  onChanged: (v) => setState(() => hasSpecialCondition = true),
                ),
                const Text('有',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(147, 129, 108, 1))),
              ],
            ),
          ),
          if (hasSpecialCondition)
            Positioned(
              top: screenHeight * 0.80,
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

          // ---------- 填寫完成 & 返回按鈕 (同原版) ----------
          Positioned(
            top: screenHeight * 0.9,
            left: screenWidth * 0.3,
            child:
                _buildButton(context, '填寫完成', Colors.brown.shade400, () async {
              // 呼叫 _saveBabyData，將所有欄位傳入
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
              if (!mounted) return;
              Navigator.pushNamed(
                context,
                '/BabyAccWidget',
                arguments: {
                  'userId': widget.userId,
                  'isManUser': widget.isManUser,
                },
              );
            }),
          ),
          Positioned(
            top: screenHeight * 0.85,
            left: screenWidth * 0.1,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
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
    ))));
  }

  // **返回按鈕**

  Widget _buildInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 180,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '性別',
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(147, 129, 108, 1),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              Row(
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
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
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
                  const Text('女生'),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildWeightPickerField(
      String label, TextEditingController controller) {
    return _buildPickerRow(label, controller, 0.0, 7.0, 0.1, 'kg');
  }

  Widget _buildHeightPickerField(
      String label, TextEditingController controller) {
    return _buildPickerRow(label, controller, 20, 90, 1, 'cm');
  }

  Widget _buildPickerRow(String label, TextEditingController controller,
      double start, double end, double step, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 180,
                child: GestureDetector(
                  onTap: () =>
                      _showPicker(context, controller, start, end, step, unit),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context, TextEditingController controller,
      double start, double end, double step, String unit) {
    final values = <String>[];
    for (double val = start; val <= end; val += step) {
      values.add(val.toStringAsFixed(step < 1 ? 1 : 0));
    }

    int defaultIndex = ((end - start) / step / 2).round(); // 預設中間值
    int initialIndex = controller.text.isNotEmpty
        ? values.indexWhere((v) => controller.text.contains(v))
        : defaultIndex;

    int selectedIndex = initialIndex;

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
                scrollController:
                    FixedExtentScrollController(initialItem: initialIndex),
                onSelectedItemChanged: (index) {
                  selectedIndex = index; // 暫存選擇
                },
                children:
                    values.map((e) => Center(child: Text('$e $unit'))).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.text =
                    '${values[selectedIndex]} $unit'; // ⬅️ 僅在按下按鈕時更新
                Navigator.pop(context);
              },
              child: const Text("確定"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 180,
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      locale: const Locale("zh", "TW"),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.year}年${pickedDate.month}月${pickedDate.day}日";
                      setState(() {
                        controller.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    TextEditingController specialConditionController,
  ) async {
    try {
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
        '寶寶出生特殊狀況':
            hasSpecialCondition ? specialConditionController.text : null,
        '填寫時間': FieldValue.serverTimestamp(),
      });

      logger.i("✅ 寶寶資訊已儲存到 Firestore users/$userId/baby/$babyId");

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
      return "";
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
    final payload = <String, dynamic>{
      'baby_name': babyName,
      'baby_birthdate': formatBirthForMySQL(babyBirth),
      'baby_gender': babyGender,
      'baby_weight':
          double.tryParse(babyWeight.replaceAll(RegExp(r'[^0-9.]'), '')),
      'baby_height':
          double.tryParse(babyHeight.replaceAll(RegExp(r'[^0-9.]'), '')),
      'baby_solution': hasSpecialCondition ? '有' : '無',
    };

    if (hasSpecialCondition &&
        babySolutionDetails != null &&
        babySolutionDetails.isNotEmpty) {
      payload['baby_solution_details'] = babySolutionDetails;
    }

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

   try {
  await Backend3000.babyApi.submitBaby(payload);
  logger.i("✅ 後端同步成功");
} catch (e, stack) {
  logger.e("❌ 後端同步失敗", error: e, stackTrace: stack);
}
  }
}
