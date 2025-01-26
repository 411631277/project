import 'package:doctor_2/main.screen.dart';
import 'package:doctor_2/register/success.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  // 新增變數來儲存婚姻狀況選擇
  String? maritalStatus; // 用於儲存目前婚姻狀況選擇
  Map<String, bool?> answers = {
    "是否會喝酒?": null,
    "是否會吸菸?": null,
    "是否會嚼食檳榔": null,
    "有無慢性病": null,
  };

  bool isEmailPreferred = false;
  bool isPhonePreferred = false;
  bool? isNewMom;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 姓名、生日、身高
              Row(
                children: [
                  Expanded(
                      child: _buildLabeledTextField('姓名', screenWidth * 0.25)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                      child: _buildLabeledTextField('生日', screenWidth * 0.25)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                      child: _buildLabeledTextField('身高', screenWidth * 0.25)),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // 目前體重、孕前體重
              Row(
                children: [
                  Expanded(
                      child: _buildLabeledTextField('目前體重', screenWidth * 0.4)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                      child: _buildLabeledTextField('孕前體重', screenWidth * 0.4)),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Email
              _buildLabel('e-mail'),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: [
                  Expanded(child: _buildTextField(width: screenWidth * 0.6)),
                  SizedBox(width: screenWidth * 0.02),
                  _buildButton('獲取驗證碼'),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              _buildTextField(hintText: '輸入驗證碼'),
              SizedBox(height: screenHeight * 0.01),
              _buildButton('驗證',
                  width: screenWidth * 0.2, backgroundColor: Colors.green),
              SizedBox(height: screenHeight * 0.02),
              // 電話
              _buildLabel('電話'),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: [
                  Expanded(child: _buildTextField(width: screenWidth * 0.6)),
                  SizedBox(width: screenWidth * 0.02),
                  _buildButton('獲取驗證碼'),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              _buildButton('驗證',
                  width: screenWidth * 0.2, backgroundColor: Colors.green),
              SizedBox(height: screenHeight * 0.02),
              // 聯絡偏好設定
              _buildLabel('聯絡偏好設定'),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("E-Mail"),
                      value: isEmailPreferred,
                      onChanged: (value) {
                        setState(() {
                          isEmailPreferred = value ?? false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("電話"),
                      value: isPhonePreferred,
                      onChanged: (value) {
                        setState(() {
                          isPhonePreferred = value ?? false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // 是/否問題
              ...answers.keys.map((question) => _buildYesNoRow(question)),
              SizedBox(height: screenHeight * 0.02),
              // 婚姻狀況
              _buildLabel('目前婚姻狀況'),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                width: screenWidth * 0.6,
                child: DropdownButtonFormField<String>(
                  value: maritalStatus,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  hint: const Text(
                    '選擇婚姻狀況',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  items: ['結婚', '未婚', '離婚', '喪偶']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      maritalStatus = value;
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // 是否為新手媽媽
              _buildLabel('是否為新手媽媽'),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("是"),
                      value: isNewMom == true,
                      onChanged: (value) {
                        setState(() {
                          isNewMom = true;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("否"),
                      value: isNewMom == false,
                      onChanged: (value) {
                        setState(() {
                          isNewMom = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: screenHeight * 0.02),
              // 按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    '返回',
                    width: screenWidth * 0.25,
                    backgroundColor: Colors.grey,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Main_screenWidget()),
                      );
                    },
                  ),
                  _buildButton(
                    '下一步',
                    width: screenWidth * 0.25,
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessWidget(),
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromRGBO(147, 129, 108, 1),
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _buildTextField({String? hintText, double width = 300}) {
    return SizedBox(
      width: width,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(height: 5),
        _buildTextField(width: width),
      ],
    );
  }

  Widget _buildButton(String text,
      {double width = 120,
      Color backgroundColor = Colors.grey,
      VoidCallback? onPressed}) {
    return SizedBox(
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildYesNoRow(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(question),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text("是"),
                value: answers[question] == true,
                onChanged: (value) {
                  setState(() {
                    answers[question] = true;
                  });
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("否"),
                value: answers[question] == false,
                onChanged: (value) {
                  setState(() {
                    answers[question] = false;
                  });
                },
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
