import 'package:doctor_2/main.screen.dart';
import 'package:doctor_2/success.dart';
import 'package:flutter/material.dart';
// 引入 main_screen.dart 文件

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

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
                  _buildCheckbox('E-Mail'),
                  const SizedBox(width: 20),
                  _buildCheckbox('電話'),
                ],
              ),
              const SizedBox(height: 20),
              // 是否問題
              _buildYesNoRow('是否會喝酒?'),
              _buildYesNoRow('是否會吸菸?'),
              _buildYesNoRow('是否會嚼食檳榔'),
              _buildYesNoRow('有無慢性病'),
              const SizedBox(height: 20),
              // 下拉選單與婚姻狀況
              _buildLabel('目前婚姻狀況'),
              const SizedBox(height: 10),
              _buildDropdown(['--', '結婚', '未婚', '離婚', '喪偶']),
              const SizedBox(height: 20),
              _buildLabel('是否為新手媽媽'),
              Row(
                children: [
                  _buildCheckbox('是'),
                  const SizedBox(width: 20),
                  _buildCheckbox('否'),
                ],
              ),
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

  Widget _buildCheckbox(String label) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(147, 129, 108, 1),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildYesNoRow(String label) {
    return Row(
      children: [
        _buildLabel(label),
        const SizedBox(width: 20),
        _buildCheckbox('是'),
        const SizedBox(width: 20),
        _buildCheckbox('否'),
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
