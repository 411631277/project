import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:doctor_2/function/main.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

//註解已完成

final FirestoreService firestoreService = FirestoreService();
final Logger logger = Logger();


class FaRegisterWidget extends StatefulWidget {
  const FaRegisterWidget({super.key, required String role});

  @override
  FaRegisterWidgetState createState() => FaRegisterWidgetState();
  }
  
  bool _obscurePassword = true;
  bool? noChronicDisease = false;
  // 🔹 用戶輸入控制器
  class FaRegisterWidgetState extends State<FaRegisterWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController prePregnancyWeightController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
   final TextEditingController pairingCodeController = TextEditingController();
  String? pairingCodeErrorMessage;
  String? pairingResult; 
  
  // 🔹 用戶選擇資料
  String? _accountCheckMessage;
  Color _accountCheckColor = Colors.transparent;
  String? maritalStatus;
  bool isEmailPreferred = false;
  bool isPhonePreferred = false;
  bool? isNewMom;
  Map<String, String> answers =
  {
    '是否會喝酒?': '',
    '是否會吸菸?': '',
    '是否會嚼食檳榔': '',
  };
  bool? hasChronicDisease;   // 是否有慢性病 (是/否)
  Map<String, bool> chronicDiseaseOptions = {
    "糖尿病": false,
    "高血壓": false,
    "肥胖症": false,
    "慢性腎臟病": false,
    "甲狀腺功能異常": false,
    "慢性肝病(肝硬化)": false,
    "自體免疫疾病": false,
    "靜脈曲張": false,
    "其他": false,
  };
  TextEditingController otherDiseaseController =
      TextEditingController(); // 具體選項

@override
  void initState() {
    super.initState();
    // 當使用者修改「帳號」欄位時，清除檢查結果，避免舊提示誤導
    accountController.addListener(() {
      setState(() {
        _accountCheckMessage = null;
        _accountCheckColor = Colors.transparent;
      });
    });
  }

// 釋放控制器，避免記憶體洩漏
  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    heightController.dispose();
    weightController.dispose();
    prePregnancyWeightController.dispose();
    emailController.dispose();
    phoneController.dispose();
    accountController.dispose();
    passwordController.dispose();
    pairingCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

   return PopScope(
  canPop: false, // 禁止 Flutter 自動 pop
  // ignore: deprecated_member_use
  onPopInvoked: (didPop) {
    Navigator.pushReplacementNamed(
      context,
      '/MainScreenWidget',
      
    );
  },
  child: Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 姓名、生日、身高
              Row(
                children: [
                  Expanded(child: _buildLabeledTextField('姓名', nameController)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(child: _buildDatePickerField('生日', birthController)),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(child: _buildheightPickerField(context, '身高', heightController)),
                  SizedBox(width: screenWidth * 0.05),
                ],
              ),

              SizedBox(height: screenHeight * 0.02), // 🔹 體重
              Row(
                children: [
                  Expanded(
                    child: _buildWeightPickerField(
                    context, '目前體重', weightController),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                ],
              ),

              // 🔹 帳號&密碼&信箱&電話
              SizedBox(height: screenHeight * 0.02),
               _buildAccountRow(), //帳號
              _buildPasswordField(),
             
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _buildLabel('電話(限10個號碼)'),
    TextField(
      controller: phoneController,
      keyboardType: TextInputType.number,
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: _inputDecoration().copyWith(counterText: ""), // 去除下方字數顯示
    ),
  ],
),

              // 🔹 聯絡偏好設定
              _buildLabel('聯絡偏好設定'),
              Row(
                children: [
                Expanded(
                    child: _buildCheckbox("E-Mail", isEmailPreferred, (value) {
                    setState(() => isEmailPreferred = value ?? false);
                    }
                    ),
                    ),
                Expanded(
                    child: _buildCheckbox("電話", isPhonePreferred, (value) {
                      setState(() => isPhonePreferred = value ?? false);
                    }
                    ),
                  ),
                ],
              ),

              // 🔹 是非題
              SizedBox(height: screenHeight * 0.02),
              ...answers.keys.map((question) => _buildYesNoRow(question)),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //「有無慢性病」標籤
                  _buildLabel('有無特殊疾病'),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('有'),
                          value: hasChronicDisease ?? false,
                          onChanged: (v) {
                            setState(() {
                              hasChronicDisease = v ?? false;

                              if (v == true) {
                                // 勾選有慢性病時，取消「沒有特殊疾病」
                                noChronicDisease = false;
                              } else {
                                // 取消有慢性病，所有慢性病選項也清空
                                chronicDiseaseOptions
                                    .updateAll((key, value) => false);
                              }
                             }
                            );
                           },
                          controlAffinity: ListTileControlAffinity.leading,
                          ),
                         ),
                        Expanded(
                         child: CheckboxListTile(
                          title: const Text('無'),
                           value: noChronicDisease ?? false,
                            onChanged: (bool? value) {
                             setState(() {
                              noChronicDisease = value ?? false;
                              if (value == true) {
                                // 當勾選「沒有特殊疾病」，自動取消「有慢性病」以及所有疾病選項
                                hasChronicDisease = false;
                                 chronicDiseaseOptions
                                  .updateAll((key, _) => false);
                               }
                              }
                             );
                            },
                           controlAffinity: ListTileControlAffinity.leading,
                           ),
                         ),
                        ],
                       ),
                  if (hasChronicDisease == true) ...[
                    const SizedBox(height: 10),
                    _buildLabel("請選擇特殊疾病種類："),
                    ...chronicDiseaseOptions.keys.map((option) {
                      return CheckboxListTile(
                        title: Text(option),
                        value: chronicDiseaseOptions[option],
                        onChanged: (value) {
                          setState(() {
                            chronicDiseaseOptions[option] = value!;
                          });
                        },
                        controlAffinity:
                            ListTileControlAffinity.leading, // 讓勾選框靠左
                      );
                    }),

                    // **如果勾選「其他」，顯示輸入框**
                    if (chronicDiseaseOptions["其他"] == true)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                          controller: otherDiseaseController,
                          decoration: const InputDecoration(
                                labelText: "請輸入其他慢性病",
                                border: OutlineInputBorder(),
                                filled: true, // 開啟填充背景
                                fillColor: Colors.white,
                              )
                            )
                          )
                        ],
                      ],
                     ),

              // 🔹 婚姻狀況
              _buildLabel('目前婚姻狀況'),
              DropdownButtonFormField<String>(
                value: maritalStatus,
                decoration: _inputDecoration(),
                hint: const Text('選擇婚姻狀況',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
                items: ['結婚', '未婚', '離婚', '喪偶']
                    .map((status) =>
                    DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => maritalStatus = value),
              ),

              // 🔹 是否為新手爸爸
              SizedBox(height: screenHeight * 0.02),
              _buildLabel('是否為新手爸爸'),
              Row(
                children: [
                Expanded(
                child: _buildCheckbox("是", isNewMom == true,
                (value) => setState(() => isNewMom = true))),
                Expanded(
                child: _buildCheckbox("否", isNewMom == false,
                (value) => setState(() => isNewMom = false))),
                ],
              ),
 // 🔹 配對碼（選填）與檢查按鈕
          _buildLabel('配偶分享碼（若沒有可略過）'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: pairingCodeController,
                  decoration: InputDecoration(
                    hintText: '請輸入分享碼',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    errorText: pairingCodeErrorMessage,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
              onPressed: () async {
  final code = pairingCodeController.text.trim();
  if (code.isEmpty) {
    setState(() => pairingResult = '請輸入配對碼');
    return;
  }

  try {
    logger.i("📌 嘗試查找配對碼: $code");

    // 🔍 查找 `users` 是否存在該配對碼
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('配對碼', isEqualTo: code)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final name = doc['名字'] ?? '未知';
      final isUsed = doc['配對碼已使用'] ?? false;

      if (isUsed) {
        setState(() => pairingResult = '此配對碼已被使用');
        logger.w("⚠️ 配對碼已被使用: $code");
        return;
      }

      // 顯示配對人
      setState(() => pairingResult = '配對人為 $name');
      logger.i("✅ 配對成功: $name");

    } else {
      logger.w("❌ 沒有找到對應的配對碼");
      setState(() => pairingResult = '無此配對碼');
    }
  } catch (e) {
    logger.e("配對檢查錯誤: $e");
    setState(() => pairingResult = '配對檢查錯誤');
  }
},

                child: const Text('檢查'),
              ),
            ],
          ),
          if (pairingResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                pairingResult!,
                style: TextStyle(
                  color: pairingResult!.startsWith('配對人為') ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
            ),

              // 🔹 按鈕
              const Divider(),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                _buildButton('返回', Colors.grey, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreenWidget()),
                    );
                  }
                  ),
                 _buildButton('下一步', Colors.blue, () async {
  setState(() => pairingCodeErrorMessage = null);

  final code = pairingCodeController.text.trim();
  bool isPaired = false;

  // 如果有填配對碼，先檢查
  if (code.isNotEmpty) {
    final isValid = await _validatePairingCode(code);
    if (!isValid) {
      setState(() => pairingCodeErrorMessage = '配對碼錯誤或已被使用');
      return;
    } else {
      isPaired = true;  // 配對成功標記為 true
    }
  }

  // 🔄 這裡才正式執行儲存
  final userId = await _saveUserData();
  if (!context.mounted) return;
  if (userId != null) {
    // ✅ 註冊完成後，只有配對成功時，才更新 Firebase
    if (isPaired) {
      await FirebaseFirestore.instance
          .collection('Man_users')
          .doc(userId)
          .update({'配對成功': true}).then((_) {
        logger.i("✅ Man_users 中的配對成功設為 true");
      }).catchError((e) {
        logger.e("🔥 Firebase 更新錯誤: $e");
      });
    } else {
      logger.i("⚠️ 未輸入配對碼，不標記配對成功");
    }

       if (!context.mounted) return;
         Navigator.pushNamed(
           context, '/FaSuccessWidget',
                   arguments: userId);
               } else {
              ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
               content: Text('儲存失敗，請稍後再試')));
                                  }
            }
         ) ,
        ],
      ),
   ]
   )
   ) 
   )
   )
   );
  }

Future<bool> _validatePairingCode(String inputCode) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('配對碼', isEqualTo: inputCode)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        final used = doc.data()['配對碼已使用'] ?? false;
        return !used;
      } else {
        return false;
      }
    } catch (e) {
      logger.e("配對碼驗證錯誤: $e");
      return false;
    }
  }

 Widget _buildAccountRow() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel('帳號(E-Mail)'),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: accountController,
              decoration: _inputDecoration(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: const Color.fromARGB(255, 148, 235, 235)),
            onPressed: _checkAccountDuplicate,
            child: const Text('檢查'),
          ),
        ],
      ),
      if (_accountCheckMessage != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(_accountCheckMessage!,
              style: TextStyle(color: _accountCheckColor)),
        ),
    ],
  );
}
        

  Future<void> _checkAccountDuplicate() async {
  final acc = accountController.text.trim();
  if (acc.isEmpty) {
    setState(() {
    _accountCheckMessage = "請先輸入帳號";
     _accountCheckColor = Colors.red;
    });
    return;
  }

  try {
    final userQuery = await FirebaseFirestore.instance  // 先查 users
        .collection('users')
        .where('帳號', isEqualTo: acc)
        .limit(1)
        .get();

      if (userQuery.docs.isNotEmpty) {        // 已有相同帳號
      setState(() {
        _accountCheckMessage = "很抱歉，此帳號已註冊";
        _accountCheckColor = Colors.red;
      });
      return; // 直接結束
    }

    // 再查 man_users
    final manUserQuery = await FirebaseFirestore.instance
        .collection('Man_users')
        .where('帳號', isEqualTo: acc)
        .limit(1)
        .get();

    if (manUserQuery.docs.isNotEmpty) {
      setState(() {
        _accountCheckMessage = "很抱歉，此帳號已註冊";
        _accountCheckColor = Colors.red;
      });
      return;
    }

    // 兩邊都沒有 => 帳號可以使用
    setState(() {
      _accountCheckMessage = "此帳號可以使用";
      _accountCheckColor = Colors.green;
    });
  } catch (e) {
    logger.e("檢查帳號錯誤: $e");
    setState(() {
      _accountCheckMessage = "檢查時發生錯誤，請稍後再試";
      _accountCheckColor = Colors.red;
    });
  }
  }

  //日期選擇器
  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          readOnly: true, //禁止手動輸入
          decoration: _inputDecoration(),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000, 1, 1),
              firstDate: DateTime(1950), // 最早 1950 年
              lastDate: DateTime.now(), // 不能選未來
              locale: const Locale("zh", "TW"), //設定為繁體中文
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy年MM月dd日', 'zh_TW').format(pickedDate);
              setState(() {
                controller.text = formattedDate;
              });
            }
          },
        ),
      ],
    );
  }

  //儲存使用者資料
 Future<String?> _saveUserData() async {
  try {
    AggregateQuerySnapshot countSnapshot = await FirebaseFirestore.instance
        .collection('Man_users')
        .count()
        .get();

    int newId = (countSnapshot.count ?? 0) + 1;
    String userId = newId.toString();

    // ✅ 先送 MySQL，若失敗就跳出
    await sendDataToMySQL(userId).then((success) async {
      if (!success) throw Exception('MySQL 同步失敗');
    });

    // 🔽 MySQL 成功後再寫 Firebase
    Map<String, dynamic> selectedChronicDiseases = {
      for (var entry in chronicDiseaseOptions.entries)
        if (entry.value) entry.key: true
    };
    if (selectedChronicDiseases.containsKey("其他")) {
      selectedChronicDiseases["其他"] = otherDiseaseController.text.isNotEmpty
          ? otherDiseaseController.text
          : null;
    }

    await FirebaseFirestore.instance
    .collection('Man_users')
    .doc(userId) 
    .set({
      '帳號': accountController.text,
      '密碼': passwordController.text,
      '名字': nameController.text,
      '生日': birthController.text,
      '身高': heightController.text,
      '目前體重': weightController.text,
      '孕前體重': prePregnancyWeightController.text,
      '手機號碼': phoneController.text,
      '婚姻狀況': maritalStatus,
      '是否為新手媽咪': isNewMom,
      '聯絡偏好': {'email': isEmailPreferred, 'phone': isPhonePreferred},
      '是否會嚼食檳榔': answers['是否會嚼食檳榔'],
      '是否會吸菸': answers['是否會吸菸?'],
      '是否會喝酒': answers['是否會喝酒?'],
      '是否有慢性病': hasChronicDisease,
      '慢性病症狀': selectedChronicDiseases,
      '配對碼': pairingCodeController.text.trim(), 
      '配對成功': false,
    });

    // ✅ 標記配對碼為已使用
    if (pairingCodeController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('配對碼', isEqualTo: pairingCodeController.text.trim())
          .limit(1)
          .get()
          .then((query) async {
            if (query.docs.isNotEmpty) {
              final docId = query.docs.first.id;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(docId)
                  .update({'配對碼已使用': true});
              logger.i('✅ 配對碼已標記為使用');
            }
          });
    }

    logger.i("✅ 使用者資料已存入 Firebase，ID：$userId");
    return userId;

  } catch (e) {
    logger.e("❌ 註冊流程錯誤：$e");
    return null;
  }
}


Future<bool> sendDataToMySQL(String userId) async {
  final url = Uri.parse('http://163.13.201.85:3000/man_users');

 String betelNutHabitValue;
  
    if (answers['是否會嚼食檳榔?'] == 'true') {
  betelNutHabitValue = "是";
} else if (answers['是否會嚼食檳榔?'] == 'false') {
  betelNutHabitValue = "從未";
} else {
  betelNutHabitValue = "曾經有，已戒掉";
}
 String smokinghabitValue;
    if (answers['是否會吸菸?'] == 'true') {
  smokinghabitValue = "是";
} else if (answers['是否會吸菸?'] == 'false') {
  smokinghabitValue = "從未";
} else {
  smokinghabitValue = "曾經有，已戒掉";
}
 String drinkinghabitvalue;
if (answers['是否會喝酒?'] == 'true') {
  drinkinghabitvalue = "是";
} else if (answers['是否會喝酒?'] == 'false') {
  drinkinghabitvalue = "從未";
} else {
  drinkinghabitvalue = "曾經有，已戒掉";
}

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'man_user_name': nameController.text,
      'man_user_id': int.parse(userId),
      'man_user_gender': "男",
      'man_user_salutation': isNewMom == true ? "是" : "否",
      'man_user_birthdate': formatBirthForMySQL(birthController.text),
      'man_user_phone': phoneController.text,
      'man_user_height': double.tryParse(heightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
      'man_current_weight': double.tryParse(weightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
      'man_emergency_contact_name': "",
      'man_emergency_contact_phone': "",
      'man_betel_nut_habit': betelNutHabitValue,
      'man_smoking_habit': smokinghabitValue ,
      'man_drinking_habit': drinkinghabitvalue ,
      'man_marital_status': maritalStatus ?? '未婚',
      'man_contact_preference': [
        if (isEmailPreferred) 'e-mail',
        if (isPhonePreferred) '電話',
      ].join(','),
      'man_chronic_illness': hasChronicDisease == true
          ? [
              ...chronicDiseaseOptions.entries
                  .where((entry) => entry.value && entry.key != "其他")
                  .map((entry) => entry.key),
              if (chronicDiseaseOptions["其他"] == true) '其他',
            ].join(',')
          : '無',
      'man_chronic_illness_details': otherDiseaseController.text.isNotEmpty
          ? otherDiseaseController.text
          : '',
      'man_user_account': accountController.text,
      'man_user_password': passwordController.text,
      'man_pairing_code': pairingCodeController.text.trim(),
    }),
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    logger.i("✅ 爸爸資料同步至 MySQL 成功");
    return true;
  } else {
    logger.e("❌ 爸爸同步 MySQL 失敗: ${response.body}");
    return false;
  }
}

  //輸入框設定
  InputDecoration _inputDecoration() => const InputDecoration(
      filled: true, fillColor: Colors.white, border: OutlineInputBorder());

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          obscureText: obscureText, //如果是密碼欄位則隱藏文字
          decoration: _inputDecoration(),
        ),
      ],
    );
  }
Widget _buildPasswordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel("密碼"),
      TextField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          // 右側的眼睛圖示
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),
    ],
  );
}
  

   Widget _buildYesNoRow(String question) {
    // 建立一個 Map 來對應每個選項的狀態

    Map<String, bool> optionStates = {
      "true": answers[question] == "true",
      "false": answers[question] == "false",
      "none": answers[question] == "none",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(question),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: optionStates["true"],
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        answers[question] = "true";
                      });
                    }
                  },
                ),
                const Text("是"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: optionStates["false"],
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        answers[question] = "false";
                      });
                    }
                  },
                ),
                const Text("從未"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: optionStates["none"],
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        answers[question] = "none";
                      });
                    }
                  },
                ),
                const Text("曾經有，已戒掉"),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

//建立標籤
Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}

//建立 CheckBox 選擇框
Widget _buildCheckbox(String text, bool value, ValueChanged<bool?> onChanged) {
  return CheckboxListTile(
    title: Text(text),
    value: value,
    onChanged: onChanged,
    controlAffinity: ListTileControlAffinity.leading,
  );
}

//建立按鈕
Widget _buildButton(String text, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: onPressed,
    child:
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
  );
}

//體重選項功能
Widget _buildWeightPickerField(
    BuildContext context, String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label),
      TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        ),
        onTap: () {
          _showWeightPicker(context, controller);
        },
      ),
    ],
  );
}

//體重選項設定
void _showWeightPicker(BuildContext context, TextEditingController controller) {
  int selectedWeight = controller.text.isNotEmpty
      ? int.parse(controller.text.replaceAll(' kg', ''))
      : 50; // 預設公斤值

  showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SizedBox(
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                    initialItem: selectedWeight - 30),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                    setModalState(() {
                    selectedWeight = index + 30;
                    });
                    },
                    children: List<Widget>.generate(121, (int index) {
                    return Center(child: Text('${index + 30} kg'));
                    }
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                  controller.text = '$selectedWeight kg'; //更新controller.text
                  Navigator.pop(context); //關閉彈出視窗
                  },
                  child: const Text("確定"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

//身高選項功能
Widget _buildheightPickerField(
  BuildContext context, String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel(label),
      TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
        onTap: () {
          _showheightPicker(context, controller);
        },
      ),
    ],
  );
}

String formatBirthForMySQL(String text) {
    try {
      final parsed = DateFormat('yyyy年MM月dd日', 'zh_TW').parse(text);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return ""; // 防呆處理，避免錯誤時整個崩潰
    }
  }

//身高功能設定
void _showheightPicker(BuildContext context, TextEditingController controller) {
  int selectedHeight = controller.text.isNotEmpty
      ? int.parse(controller.text.replaceAll(' cm', ''))
      : 160; // 預設身高值

  showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SizedBox(
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                    initialItem: selectedHeight - 100),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                    setModalState(() {
                    selectedHeight = index + 100;
                      }
                      );
                      },
                    children: List<Widget>.generate(121, (int index) {
                    return Center(child: Text('${index + 100} cm'));
                    }
                    ),
                    ),
                    ),
                ElevatedButton(
                  onPressed: () {
                    controller.text = '$selectedHeight cm'; //更新controller.text
                    Navigator.pop(context); //關閉彈出視窗
                  },
                  child: const Text("確定"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
}