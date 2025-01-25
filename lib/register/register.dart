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
  // 問題的答案狀態
  Map<String, bool?> answers = {
    "是否會喝酒?": null,
    "是否會吸菸?": null,
    "是否會嚼食檳榔": null,
    "有無慢性病": null,
  };

  // 聯絡偏好設定狀態
  bool isEmailPreferred = false;
  bool isPhonePreferred = false;

  // 單獨管理「是否為新手媽媽」
  bool? isNewMom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 姓名、生日、身高
              Row(
                children: [
                  _buildLabel('姓名'),
                  const SizedBox(width: 100),
                  _buildLabel('生日'),
                  const SizedBox(width: 100),
                  _buildLabel('身高'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTextField(width: 100),
                  const SizedBox(width: 10),
                  _buildTextField(width: 100),
                  const SizedBox(width: 10),
                  _buildTextField(width: 100),
                ],
              ),
              const SizedBox(height: 20),
              // 目前體重、孕前體重
              Row(
                children: [
                  _buildLabel('目前體重'),
                  const SizedBox(width: 110),
                  _buildLabel('孕前體重'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTextField(width: 150),
                  const SizedBox(width: 20),
                  _buildTextField(width: 150),
                ],
              ),
              const SizedBox(height: 20),
              // Email、驗證碼
              _buildLabel('e-mail'),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTextField(width: 200),
                  const SizedBox(width: 10),
                  _buildButton('獲取驗證碼'),
                ],
              ),
              const SizedBox(height: 10),
              _buildTextField(hintText: '輸入驗證碼'),
              const SizedBox(height: 10),
              _buildButton('驗證', width: 80, backgroundColor: Colors.green),
              const SizedBox(height: 20),
              // 電話
              _buildLabel('電話'),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTextField(width: 200),
                  const SizedBox(width: 10),
                  _buildButton('獲取驗證碼'),
                ],
              ),
              const SizedBox(height: 10),
              _buildButton('驗證', width: 80, backgroundColor: Colors.green),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              // 勾選題
              ...answers.keys.map((question) => _buildYesNoRow(question)),
              const SizedBox(height: 20),
              // 下拉選單與婚姻狀況
              _buildLabel('目前婚姻狀況'),
              const SizedBox(height: 10),
              _buildDropdown(['--', '結婚', '未婚', '離婚', '喪偶']),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              // 按鈕
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    '返回',
                    width: 100,
                    backgroundColor: Colors.grey,
                    onPressed: () {
                      // 返回到 main_screen.dart 定义的页面
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Main_screenWidget()),
                      );
                    },
                  ),
                  _buildButton(
                    '下一步',
                    width: 100,
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessWidget(),
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
        fontSize: 20,
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

  Widget _buildDropdown(List<String> items) {
    return DropdownButton<String>(
      value: items[0],
      onChanged: (value) {},
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
    );
  }
}
