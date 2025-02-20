import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class DetaWidget extends StatefulWidget {
  final String userId; // 🔹 從登入或註冊時傳入的 userId
  const DetaWidget({super.key, required this.userId});

  @override
  State<DetaWidget> createState() => _DetaWidgetState();
}

class _DetaWidgetState extends State<DetaWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController emergencyName1 = TextEditingController();
  final TextEditingController emergencyName2 = TextEditingController();
  final TextEditingController emergencyRelation1 = TextEditingController();
  final TextEditingController emergencyRelation2 = TextEditingController();
  final TextEditingController emergencyPhone1 = TextEditingController();
  final TextEditingController emergencyPhone2 = TextEditingController();

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
            // **圖示**
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.37,
              child: Container(
                width: screenWidth * 0.2,
                height: screenHeight * 0.08,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/data.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            // **姓名與生日**
            _buildLabel(screenWidth, screenHeight * 0.15, 0.05, '姓名'),
            _buildLabel(screenWidth, screenHeight * 0.15, 0.55, '生日'),
            _buildTextField(
                nameController, screenWidth, screenHeight * 0.19, 0.05, 0.4),
            _buildDatePickerField(screenWidth, screenHeight * 0.19, 0.55, 0.4,
                birthDateController),

            // **身高與體重**
            _buildLabel(screenWidth, screenHeight * 0.25, 0.05, '身高'),
            _buildLabel(screenWidth, screenHeight * 0.25, 0.55, '目前體重'),
            _buildHeightPickerField(
                screenWidth, screenHeight * 0.29, 0.05, 0.4, heightController),
            _buildWeightPickerField(
                screenWidth, screenHeight * 0.29, 0.55, 0.4, weightController),

            // **緊急聯絡人**
            _buildLabel(screenWidth, screenHeight * 0.43, 0.05, '新增緊急聯絡人'),

            // 聯絡人姓名
            _buildLabel(screenWidth, screenHeight * 0.48, 0.05, '姓名'),
            _buildLabel(screenWidth, screenHeight * 0.48, 0.55, '姓名'),
            _buildTextField(
                emergencyName1, screenWidth, screenHeight * 0.52, 0.05, 0.4),
            _buildTextField(
                emergencyName2, screenWidth, screenHeight * 0.52, 0.55, 0.4),

            // 聯絡人關係
            _buildLabel(screenWidth, screenHeight * 0.58, 0.05, '關係'),
            _buildLabel(screenWidth, screenHeight * 0.58, 0.55, '關係'),
            _buildTextField(emergencyRelation1, screenWidth,
                screenHeight * 0.62, 0.05, 0.4),
            _buildTextField(emergencyRelation2, screenWidth,
                screenHeight * 0.62, 0.55, 0.4),

            // 聯絡人電話
            _buildLabel(screenWidth, screenHeight * 0.68, 0.05, '電話'),
            _buildLabel(screenWidth, screenHeight * 0.68, 0.55, '電話'),
            _buildTextField(
                emergencyPhone1, screenWidth, screenHeight * 0.72, 0.05, 0.4),
            _buildTextField(
                emergencyPhone2, screenWidth, screenHeight * 0.72, 0.55, 0.4),

            // **返回按鈕**
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Transform.rotate(
                  angle: math.pi,
                  child: Image.asset(
                    'assets/images/back.png',
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.23,
                  ),
                ),
              ),
            ),

            // **刪除帳號 & 修改確認按鈕**
            Positioned(
              top: screenHeight * 0.8,
              left: screenWidth * 0.60,
              child: Column(
                children: [
                  _buildButton('刪除帳號', Colors.grey.shade400, () {
                    Navigator.pushNamed(
                      context,
                      '/DeleteWidget',
                      arguments: widget.userId,
                    );
                  }),
                  const SizedBox(height: 20),
                  _buildButton('修改確認', Colors.grey.shade400, () async {
                    await _updateUserData(); // 🔹 先更新 Firebase

                    // ✅ 確保 context 仍然有效
                    if (!context.mounted) return;
                    Navigator.pushNamed(
                      context,
                      '/ReviseWidget',
                      arguments: widget.userId, // ✅ 傳遞 userId
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // 🔹 先獲取 Firestore 內的原始資料
      DocumentSnapshot userSnapshot = await users.doc(widget.userId).get();

      // 🔹 取得原始資料（轉成 Map 格式）
      Map<String, dynamic> existingData =
          userSnapshot.data() as Map<String, dynamic>;

      // 🔹 準備要更新的資料（只更新有填寫的欄位，其他欄位保留原值）
      Map<String, dynamic> updatedData = {
        "名字": nameController.text.isNotEmpty
            ? nameController.text
            : existingData["名字"],
        "生日": birthDateController.text.isNotEmpty
            ? birthDateController.text
            : existingData["生日"],
        "身高": heightController.text.isNotEmpty
            ? heightController.text
            : existingData["身高"],
        "目前體重": weightController.text.isNotEmpty
            ? weightController.text
            : existingData["目前體重"],
        "緊急聯絡人1_姓名": emergencyName1.text.isNotEmpty
            ? emergencyName1.text
            : existingData["緊急聯絡人1_姓名"],
        "緊急聯絡人1_關係": emergencyRelation1.text.isNotEmpty
            ? emergencyRelation1.text
            : existingData["緊急聯絡人1_關係"],
        "緊急聯絡人1_電話": emergencyPhone1.text.isNotEmpty
            ? emergencyPhone1.text
            : existingData["緊急聯絡人1_電話"],
        "緊急聯絡人2_姓名": emergencyName2.text.isNotEmpty
            ? emergencyName2.text
            : existingData["緊急聯絡人2_姓名"],
        "緊急聯絡人2_關係": emergencyRelation2.text.isNotEmpty
            ? emergencyRelation2.text
            : existingData["緊急聯絡人2_關係"],
        "緊急聯絡人2_電話": emergencyPhone2.text.isNotEmpty
            ? emergencyPhone2.text
            : existingData["緊急聯絡人2_電話"],
      };

      // 🔹 更新 Firestore，只影響有變動的資料
      await users.doc(widget.userId).update(updatedData);
      logger.i("✅ 使用者資料成功更新：users/${widget.userId}");
    } catch (e) {
      logger.e("❌ 更新使用者資料時發生錯誤：$e");
    }
  }

  // **標籤 Widget**
  Widget _buildLabel(double screenWidth, double top, double left, String text) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: Text(
        text,
        style: TextStyle(
          color: const Color.fromRGBO(147, 129, 108, 1),
          fontFamily: 'Inter',
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  // **輸入框 Widget**
  Widget _buildTextField(TextEditingController controller, double screenWidth,
      double top, double left, double widthFactor) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: SizedBox(
        width: screenWidth * widthFactor,
        height: 35,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
      ),
    );
  }

  // **日期選擇器**
  Widget _buildDatePickerField(double screenWidth, double top, double left,
      double widthFactor, TextEditingController controller) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            controller.text =
                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
          }
        },
        child: AbsorbPointer(
          child:
              _buildTextField(controller, screenWidth, top, left, widthFactor),
        ),
      ),
    );
  }

  // **身高選擇器**
  Widget _buildHeightPickerField(double screenWidth, double top, double left,
      double widthFactor, TextEditingController controller) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: GestureDetector(
        onTap: () => _showPicker(context, controller, 150, 200, " cm"),
        child: AbsorbPointer(
          child:
              _buildTextField(controller, screenWidth, top, left, widthFactor),
        ),
      ),
    );
  }

  // **體重選擇器**
  Widget _buildWeightPickerField(double screenWidth, double top, double left,
      double widthFactor, TextEditingController controller) {
    return Positioned(
      top: top,
      left: screenWidth * left,
      child: GestureDetector(
        onTap: () => _showPicker(context, controller, 30, 100, " kg"),
        child: AbsorbPointer(
          child:
              _buildTextField(controller, screenWidth, top, left, widthFactor),
        ),
      ),
    );
  }

  // **數值選擇器通用方法**
  void _showPicker(BuildContext context, TextEditingController controller,
      int min, int max, String unit) {
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
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    controller.text = "${min + index}$unit";
                  },
                  children: List<Widget>.generate(max - min + 1, (int index) {
                    return Center(child: Text("${min + index}$unit"));
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("確定"),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildButton(String text, Color color, VoidCallback onPressed) {
  return SizedBox(
    width: 120, // 按鈕寬度
    height: 40, // 按鈕高度
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
          color: Colors.black,
          fontSize: 14, // 字體縮小
        ),
      ),
    ),
  );
}
