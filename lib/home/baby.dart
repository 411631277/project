import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

final TextEditingController babyNameController = TextEditingController();
final TextEditingController babyBirthController = TextEditingController();
final TextEditingController babyGenderController = TextEditingController();
final TextEditingController babyWeightController = TextEditingController();
final TextEditingController babyHeightController = TextEditingController();

class BabyWidget extends StatefulWidget {
  final String userId; // 🔹 從登入或註冊時傳入的 userId
  const BabyWidget({super.key, required this.userId});

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
              left: screenWidth * 0.2,
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
                    babyNameController.text,
                    babyBirthController,
                    babyGenderController,
                    babyWeightController,
                    babyHeightController,
                    hasSpecialCondition,
                    specialConditionController);

                // ✅ **確保這裡傳遞的是 widget.userId**
                Navigator.pushNamed(
                  context,
                  '/BabyAccWidget',
                  arguments: widget.userId, // ✅ **改為 widget.userId**
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
            width: screenWidth * 0.40, // Label 寬度（固定比例）
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
            width: screenWidth * 0.4, // TextField 寬度（固定比例）
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
        : 115; // 預設值改為 115cm

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
                    initialItem: selectedHeight - 80, // 偏移值改為從 80 開始
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    selectedHeight = index + 80; // 偏移值改為 +80
                  },
                  children: List<Widget>.generate(71, (int index) {
                    return Center(
                        child: Text('${index + 80} cm')); // 生成 80~150 的選項
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
    int selectedWeight = controller.text.isNotEmpty
        ? int.parse(controller.text.replaceAll(' kg', ''))
        : 10; // 預設值改為 10kg

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
                    initialItem: selectedWeight, // 假設數值從 0 開始
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    selectedWeight = index; // 新範圍直接對應 index
                  },
                  children: List<Widget>.generate(21, (int index) {
                    return Center(child: Text('$index kg')); // 生成 0~20 的選項
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.text = '$selectedWeight kg'; // 更新控制器的值
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
        .collection('users') // 🔹 進入 users collection
        .doc(userId) // 🔹 指定使用者 ID
        .collection('baby') // 🔹 **在該使用者底下建立 baby 子 collection**
        .doc(babyId) // ✅ **使用 babyName 作為 docId**
        .set({
      '姓名': babyName,
      '生日': babyBirthController.text,
      '性別': babyGenderController.text,
      '出生體重': babyWeightController.text,
      '出生身高': babyHeightController.text,
      '寶寶出生特殊狀況': hasSpecialCondition
          ? specialConditionController.text
          : null, // 只有勾選時才存入
      '填寫時間': FieldValue.serverTimestamp(),
    });

    logger.i("✅ 寶寶資訊成功儲存於 users/$userId/baby/$babyId");
  } catch (e) {
    logger.e("❌ 儲存寶寶資訊時發生錯誤: $e");
  }
}
