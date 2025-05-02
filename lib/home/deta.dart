import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:math' as math;

final Logger logger = Logger();

class DetaWidget extends StatefulWidget {
  final String userId; // 從登入或註冊時傳入的 userId
  final bool isManUser;
  const DetaWidget({super.key, required this.userId, required this.isManUser});

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
            // 圖示
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

            // **姓名 與 生日**
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.05,
              child: _labelWidget("姓名", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.55,
              child: _labelWidget("生日", screenWidth),
            ),
            // 輸入框: 姓名
            Positioned(
              top: screenHeight * 0.19,
              left: screenWidth * 0.05,
              child: _textFieldWidget(nameController, screenWidth * 0.4),
            ),
            // 輸入框: 生日(帶日期選擇)
            Positioned(
              top: screenHeight * 0.19,
              left: screenWidth * 0.55,
              child: _datePickerWidget(birthDateController, screenWidth * 0.4),
            ),

            // **身高 與 目前體重**
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.05,
              child: _labelWidget("身高", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.55,
              child: _labelWidget("目前體重", screenWidth),
            ),
            // 輸入框: 身高(帶Picker)
            Positioned(
              top: screenHeight * 0.29,
              left: screenWidth * 0.05,
              child: _heightPickerWidget(heightController, screenWidth * 0.4),
            ),
            // 輸入框: 體重(帶Picker)
            Positioned(
              top: screenHeight * 0.29,
              left: screenWidth * 0.55,
              child: _weightPickerWidget(weightController, screenWidth * 0.4),
            ),

            // **緊急聯絡人**
            Positioned(
              top: screenHeight * 0.43,
              left: screenWidth * 0.05,
              child: _labelWidget("新增緊急聯絡人", screenWidth),
            ),
            // 聯絡人姓名
            Positioned(
              top: screenHeight * 0.48,
              left: screenWidth * 0.05,
              child: _labelWidget("姓名", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.48,
              left: screenWidth * 0.55,
              child: _labelWidget("姓名", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.05,
              child: _textFieldWidget(emergencyName1, screenWidth * 0.4),
            ),
            Positioned(
              top: screenHeight * 0.52,
              left: screenWidth * 0.55,
              child: _textFieldWidget(emergencyName2, screenWidth * 0.4),
            ),

            // 聯絡人關係
            Positioned(
              top: screenHeight * 0.58,
              left: screenWidth * 0.05,
              child: _labelWidget("關係", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.58,
              left: screenWidth * 0.55,
              child: _labelWidget("關係", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.62,
              left: screenWidth * 0.05,
              child: _textFieldWidget(emergencyRelation1, screenWidth * 0.4),
            ),
            Positioned(
              top: screenHeight * 0.62,
              left: screenWidth * 0.55,
              child: _textFieldWidget(emergencyRelation2, screenWidth * 0.4),
            ),

            // 聯絡人電話
            Positioned(
              top: screenHeight * 0.68,
              left: screenWidth * 0.05,
              child: _labelWidget("電話", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.68,
              left: screenWidth * 0.55,
              child: _labelWidget("電話", screenWidth),
            ),
            Positioned(
              top: screenHeight * 0.72,
              left: screenWidth * 0.05,
              child: _textFieldWidget(emergencyPhone1, screenWidth * 0.4),
            ),
            Positioned(
              top: screenHeight * 0.72,
              left: screenWidth * 0.55,
              child: _textFieldWidget(emergencyPhone2, screenWidth * 0.4),
            ),

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

            // **刪除帳號 & 修改確認**
            Positioned(
              top: screenHeight * 0.85,
              left: screenWidth * 0.60,
              child: Column(
                children: [
                 
                  const SizedBox(height: 20),
                  _buildButton('修改確認', Colors.grey.shade400, () async {
                    await _updateUserData();
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, '/ReviseWidget', arguments: {
                      'userId': widget.userId,
                      'isManUser': widget.isManUser,
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //===========================
  // 普通 Widget，不再回傳 Positioned
  //===========================

  Widget _labelWidget(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        color: const Color.fromRGBO(147, 129, 108, 1),
        fontFamily: 'Inter',
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _textFieldWidget(TextEditingController controller, double width) {
    return SizedBox(
      width: width,
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
    );
  }

  /// 日期選擇器：不回傳 Positioned，只回傳 GestureDetector + _textFieldWidget
  Widget _datePickerWidget(TextEditingController controller, double width) {
    return GestureDetector(
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
        child: _textFieldWidget(controller, width),
      ),
    );
  }

  /// 身高選擇器
  Widget _heightPickerWidget(TextEditingController controller, double width) {
    return GestureDetector(
      onTap: () => _showPicker(context, controller, 150, 200, " cm"),
      child: AbsorbPointer(
        child: _textFieldWidget(controller, width),
      ),
    );
  }

  /// 體重選擇器
  Widget _weightPickerWidget(TextEditingController controller, double width) {
    return GestureDetector(
      onTap: () => _showPicker(context, controller, 30, 100, " kg"),
      child: AbsorbPointer(
        child: _textFieldWidget(controller, width),
      ),
    );
  }

  /// Picker 通用
  void _showPicker(BuildContext context, TextEditingController controller,
    int min, int max, String unit) {
  int selectedValue = int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? min;

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
                scrollController: FixedExtentScrollController(initialItem: selectedValue - min),
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  selectedValue = min + index;
                },
                children: List<Widget>.generate(max - min + 1, (int index) {
                  return Center(child: Text("${min + index}$unit"));
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.text = "$selectedValue$unit";
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


  /// 更新使用者資料
  Future<void> _updateUserData() async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection(
        widget.isManUser ? 'Man_users' : 'users',
      );

      DocumentSnapshot userSnapshot = await users.doc(widget.userId).get();
      Map<String, dynamic> existingData =
          userSnapshot.data() as Map<String, dynamic>;

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
      await _updateUserDataToMySQL();
      await users.doc(widget.userId).update(updatedData);
      logger.i("✅ 使用者資料成功更新：${widget.isManUser ? 'Man_users' : 'users'}/${widget.userId}");
    } catch (e) {
      logger.e("❌ 更新使用者資料時發生錯誤：$e");
    }
  }


  Future<void> _updateUserDataToMySQL() async {
    final url = Uri.parse('http://163.13.201.85:3000/users');
  final Map<String, dynamic> payload = {
    'user_id': int.parse(widget.userId),
  };
if (heightController.text.isNotEmpty) {
  // 例如: 去掉 'cm'，再轉數字
  String cleanHeight = heightController.text.replaceAll(RegExp(r'[^0-9.]'), '');
  payload['user_height'] = int.tryParse(cleanHeight) ?? 0; // 或 null
}

if (weightController.text.isNotEmpty) {
  String cleanWeight = weightController.text.replaceAll(RegExp(r'[^0-9.]'), '');
  payload['current_weight'] = double.tryParse(cleanWeight) ?? 0;
}

 if (nameController.text.isNotEmpty) payload['user_name'] = nameController.text;
if (birthDateController.text.isNotEmpty) payload['user_birthdate'] = birthDateController.text;
if (emergencyName1.text.isNotEmpty) payload['emergency_contact_name'] = emergencyName1.text;
if (emergencyRelation1.text.isNotEmpty) payload['emergency_contact_relation'] = emergencyRelation1.text;
if (emergencyPhone1.text.isNotEmpty) payload['emergency_contact_phone'] = emergencyPhone1.text;
if (emergencyName2.text.isNotEmpty) payload['emergency_contact_name2'] = emergencyName2.text;
if (emergencyRelation2.text.isNotEmpty) payload['emergency_contact_relation2'] = emergencyRelation2.text;
if (emergencyPhone2.text.isNotEmpty) payload['emergency_contact_phone2'] = emergencyPhone2.text;

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      logger.i("✅ MySQL 更新成功");
    } else {
      logger.e("❌ MySQL 更新失敗: ${response.body}");
    }
  } catch (e) {
    logger.e("❌ MySQL 通訊錯誤: $e");
  }
}

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 120,
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
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
