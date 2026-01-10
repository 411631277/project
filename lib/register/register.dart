import 'dart:math';
import 'package:doctor_2/function/main.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_2/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:doctor_2/services/backend3000/backend3000.dart';

final FirestoreService firestoreService = FirestoreService();
final Logger logger = Logger();

class RegisterWidget extends StatefulWidget {
  final String role;
  const RegisterWidget({super.key, required this.role});

  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  // 🔹 防重複提交旗標
  bool isSubmitting = false;
  bool _obscurePassword = true;
  bool? noChronicDisease = false;

  // 🔹 控制器
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController prePregnancyWeightController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otherDiseaseController = TextEditingController();
//
  String? _accountCheckMessage;
  Color _accountCheckColor = Colors.transparent;
  String? maritalStatus;
  bool isEmailPreferred = false;
  bool isPhonePreferred = false;
  bool? isNewMom;
  bool? hasChronicDisease;
  Map<String, String> answers = {
    '是否會喝酒?': '',
    '是否會吸菸?': '',
    '是否會嚼食檳榔': '',
  };

  Map<String, bool> chronicDiseaseOptions = {
    '妊娠糖尿病': false,
    '妊娠高血壓': false,
    '子癇前症': false,
    '甲狀腺功能異常': false,
    '慢性貧血': false,
    '慢性腎臟病': false,
    '自體免疫疾病': false,
    '胃腸道疾病': false,
    '其他': false,
  };

  @override
  void initState() {
    super.initState();
    accountController.addListener(() {
      setState(() {
        _accountCheckMessage = null;
        _accountCheckColor = Colors.transparent;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    heightController.dispose();
    weightController.dispose();
    prePregnancyWeightController.dispose();
    phoneController.dispose();
    accountController.dispose();
    passwordController.dispose();
    otherDiseaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
        canPop: false,
        // ignore: deprecated_member_use
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(
            context,
            '/MainScreenWidget',
          );
        },
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
            body: SafeArea(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: const Color.fromRGBO(233, 227, 213, 1),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 表單欄位（姓名、生日、身高、體重、帳號、密碼、聯絡喜好、是非題、慢性病、婚姻、新手媽媽）
                      Row(
                        children: [
                          Expanded(
                              child:
                                  _buildLabeledTextField('姓名', nameController)),
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                              child:
                                  _buildDatePickerField('生日', birthController)),
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                              child: _buildheightPickerField(
                                  context, '身高', heightController)),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      Row(
                        children: [
                          Expanded(
                              child: _buildWeightPickerField(
                                  context, '目前體重', weightController)),
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                              child: _buildWeightPickerField(context, '孕前體重',
                                  prePregnancyWeightController)),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      _buildAccountRow(),
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
                            decoration: _inputDecoration()
                                .copyWith(counterText: ""), // 去除下方字數顯示
                          ),
                        ],
                      ),

                      _buildLabel('聯絡偏好設定(可複選)'),
                      Row(
                        children: [
                          Expanded(
                              child: _buildCheckbox(
                                  'E-Mail',
                                  isEmailPreferred,
                                  (v) => setState(
                                      () => isEmailPreferred = v ?? false))),
                          Expanded(
                              child: _buildCheckbox(
                                  '電話',
                                  isPhonePreferred,
                                  (v) => setState(
                                      () => isPhonePreferred = v ?? false))),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      ...answers.keys.map((q) => _buildYesNoRow(q)),
                      SizedBox(height: screenHeight * 0.02),

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
                                });
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
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),

                      if (hasChronicDisease == true) ...[
                        const SizedBox(height: 10),
                        _buildLabel('請選擇特殊疾病種類(可複選)：'),
                        ...chronicDiseaseOptions.entries
                            .map((e) => CheckboxListTile(
                                  title: Text(e.key),
                                  value: e.value,
                                  onChanged: (v) => setState(
                                      () => chronicDiseaseOptions[e.key] = v!),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                )),
                        if (chronicDiseaseOptions['其他'] == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: otherDiseaseController,
                              decoration: const InputDecoration(
                                labelText: '請輸入其他慢性病',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                      ],
                      _buildLabel('目前婚姻狀況'),
                      DropdownButtonFormField<String>(
                        value: maritalStatus,
                        decoration: _inputDecoration(),
                        hint: const Text('選擇婚姻狀況'),
                        items: ['結婚', '未婚', '離婚', '喪偶']
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) => setState(() => maritalStatus = v),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      _buildLabel('是否為新手媽媽'),
                      Row(
                        children: [
                          Expanded(
                              child: _buildCheckbox('是', isNewMom == true,
                                  (v) => setState(() => isNewMom = true))),
                          Expanded(
                              child: _buildCheckbox('否', isNewMom == false,
                                  (v) => setState(() => isNewMom = false))),
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildButton('返回', Colors.grey, () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MainScreenWidget()));
                          }),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              iconColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    setState(() => isSubmitting = true);
                                    final userId = await _saveUserData();
                                    if (mounted) {
                                      setState(() => isSubmitting = false);
                                      if (userId != null) {
                                        if (!context.mounted) return;
                                        Navigator.pushNamed(
                                          context,
                                          '/SuccessWidget',
                                          arguments: {
                                            'userId': userId,
                                            'isNewMom':
                                                isNewMom, // 這個 isNewMom 變數要是你在 register 裡已經抓到的值
                                          },
                                        );
                                      } else {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('儲存失敗，請稍後再試')));
                                      }
                                    }
                                  },
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Text('下一步',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

//方法區域
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
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9@&!*.\-_]')),
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
        _accountCheckMessage = '請先輸入帳號';
        _accountCheckColor = Colors.red;
      });
      return;
    }

    try {
      // 查詢 Man_users 集合
      final manUserQuery = FirebaseFirestore.instance
          .collection('Man_users')
          .where('帳號', isEqualTo: acc)
          .limit(1)
          .get();

      // 查詢 users 集合
      final userQuery = FirebaseFirestore.instance
          .collection('users')
          .where('帳號', isEqualTo: acc)
          .limit(1)
          .get();

      final results = await Future.wait([manUserQuery, userQuery]);

      final existsInManUsers = results[0].docs.isNotEmpty;
      final existsInUsers = results[1].docs.isNotEmpty;

      if (existsInManUsers || existsInUsers) {
        setState(() {
          _accountCheckMessage = '很抱歉，此帳號已註冊';
          _accountCheckColor = Colors.red;
        });
        return;
      }

      setState(() {
        _accountCheckMessage = '此帳號可以使用';
        _accountCheckColor = Colors.green;
      });
    } catch (e) {
      logger.e('檢查帳號錯誤: $e');
      setState(() {
        _accountCheckMessage = '檢查時發生錯誤，請稍後再試';
        _accountCheckColor = Colors.red;
      });
    }
  }

  Future<String> generateIncrementalUserId() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final snapshot = await usersCollection
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final lastId = int.tryParse(snapshot.docs.first.id) ?? 0;
      final nextId = lastId + 1;
      return nextId.toString();
    } else {
      return '1';
    }
  }

  /// 儲存使用者資料：原子性處理 Firestore + MySQL
  Future<String?> _saveUserData() async {
    try {
      // 🔢 取得目前總筆數，計算新的 userId
      AggregateQuerySnapshot countSnapshot =
          await FirebaseFirestore.instance.collection('users').count().get();

      int newId = (countSnapshot.count ?? 0) + 1;
      String userId = newId.toString();

      final pairingCode = generatePairingCode();

      final Map<String, dynamic> data = {
        'userId': userId,
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
        '聯絡偏好': {
          'email': isEmailPreferred,
          'phone': isPhonePreferred,
        },
        '是否會嚼食檳榔': answers['是否會嚼食檳榔'],
        '是否會吸菸': answers['是否會吸菸?'],
        '是否會喝酒': answers['是否會喝酒?'],
        '慢性病症狀': {
          for (var e in chronicDiseaseOptions.entries)
            if (e.value)
              e.key == '其他'
                  ? (otherDiseaseController.text.isNotEmpty
                      ? otherDiseaseController.text
                      : null)
                  : true
        },
        '配對碼': pairingCode,
        '配對碼已使用': false,
      };

      // ✅ 儲存到 MySQL
      final bool sqlOK = await sendDataToMySQL(userId, pairingCode);
      if (!sqlOK) throw Exception('MySQL 同步失敗');

      // ✅ 寫入 Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(data);

      logger.i('✅ Firestore 已寫入，用戶ID：$userId');

      return userId;
    } catch (e) {
      logger.e('❌ 註冊流程失敗：$e');
      return null;
    }
  }

  /// 同步到 MySQL，回傳是否成功
  Future<bool> sendDataToMySQL(String userId, String pairingCode) async {
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
    final payload = {
  'user_name': nameController.text,
  'user_gender': widget.role == '媽媽' ? '女' : '男',
  'user_salutation': isNewMom == true ? '是' : '否',
  'user_birthdate': formatBirthForMySQL(birthController.text),
  'user_phone': phoneController.text,
  'user_account': accountController.text,
  'user_password': passwordController.text,
  'user_height': double.tryParse(
          heightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ??
      0.0,
  'current_weight': double.tryParse(
          weightController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ??
      0.0,
  'emergency_contact_name': '',
  'emergency_contact_phone': '',
  'betel_nut_habit': betelNutHabitValue,
  'smoking_habit': smokinghabitValue,
  'drinking_habit': drinkinghabitvalue,
  'pre_pregnancy_weight': double.tryParse(prePregnancyWeightController.text
          .replaceAll(RegExp(r'[^0-9.]'), '')) ??
      0.0,
  'marital_status': maritalStatus ?? '未婚',
  'contact_preference': [
    if (isEmailPreferred) 'e-mail',
    if (isPhonePreferred) '電話'
  ].join(','),
  'chronic_illness': hasChronicDisease == true
      ? [
          ...chronicDiseaseOptions.entries
              .where((e) => e.value && e.key != '其他')
              .map((e) => e.key),
          if (chronicDiseaseOptions['其他'] == true) '其他'
        ].join(',')
      : '無',
  'chronic_illness_details': otherDiseaseController.text,
  'pairing_code': pairingCode,
};

try {
  // ✅ 集中管理：送到 /users
  await Backend3000.userApi.postUser(
    isManUser: false, // 這段是 /users（媽媽/一般用戶）
    payload: payload,
  );

  logger.i('✅ 同步資料到 MySQL 成功');
  return true;
} catch (e) {
  logger.e('❌ 同步 MySQL 失敗: $e');
  return false;
}
  }

  String formatBirthForMySQL(String text) {
    try {
      final d = DateFormat('yyyy年MM月dd日', 'zh_TW').parse(text);
      return DateFormat('yyyy-MM-dd').format(d);
    } catch (_) {
      return '';
    }
  }

  // 以下為 UI helper methods
  InputDecoration _inputDecoration() => const InputDecoration(
      filled: true, fillColor: Colors.white, border: OutlineInputBorder());

  Widget _buildLabeledTextField(String label, TextEditingController c,
          {bool obscureText = false}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextField(
              controller: c,
              obscureText: obscureText,
              decoration: _inputDecoration()),
        ],
      );

  Widget _buildPasswordField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('密碼'),
          TextField(
            controller: passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
        ],
      );

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

  Widget _buildDatePickerField(String label, TextEditingController c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextField(
            controller: c,
            readOnly: true,
            decoration: _inputDecoration(),
            onTap: () async {
              final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000, 1, 1),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  locale: const Locale('zh', 'TW'));
              if (d != null) {
                setState(() =>
                    c.text = DateFormat('yyyy年MM月dd日', 'zh_TW').format(d));
              }
            },
          ),
        ],
      );

  Widget _buildWeightPickerField(
          BuildContext ctx, String l, TextEditingController c) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(l),
          TextField(
            controller: c,
            readOnly: true,
            decoration: _inputDecoration(),
            onTap: () => _showWeightPicker(ctx, c),
          ),
        ],
      );

  void _showWeightPicker(BuildContext ctx, TextEditingController c) {
    int val = c.text.isNotEmpty ? int.parse(c.text.replaceAll(' kg', '')) : 50;
    showModalBottomSheet(
        context: ctx,
        builder: (_) => StatefulBuilder(
              builder: (_, setM) => SizedBox(
                height: 250,
                child: Column(children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                      scrollController:
                          FixedExtentScrollController(initialItem: val - 30),
                      itemExtent: 40,
                      onSelectedItemChanged: (i) => setM(() => val = i + 30),
                      children: List.generate(
                          121, (i) => Center(child: Text('${i + 30} kg'))),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        c.text = '$val kg';
                        Navigator.pop(ctx);
                      },
                      child: const Text('確定'))
                ]),
              ),
            ));
  }

  Widget _buildheightPickerField(
          BuildContext ctx, String l, TextEditingController c) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(l),
          TextField(
              controller: c,
              readOnly: true,
              decoration: _inputDecoration(),
              onTap: () => _showheightPicker(ctx, c)),
        ],
      );

  void _showheightPicker(BuildContext ctx, TextEditingController c) {
    int val = c.text.isNotEmpty ? int.parse(c.text.replaceAll(' cm', '')) : 155;
    showModalBottomSheet(
        context: ctx,
        builder: (_) => StatefulBuilder(
              builder: (_, setM) => SizedBox(
                height: 250,
                child: Column(children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoPicker(
                      scrollController:
                          FixedExtentScrollController(initialItem: val - 100),
                      itemExtent: 40,
                      onSelectedItemChanged: (i) => setM(() => val = i + 100),
                      children: List.generate(
                          121, (i) => Center(child: Text('${i + 100} cm'))),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        c.text = '$val cm';
                        Navigator.pop(ctx);
                      },
                      child: const Text('確定'))
                ]),
              ),
            ));
  }

  Widget _buildLabel(String txt) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(txt,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  Widget _buildCheckbox(String txt, bool val, ValueChanged<bool?> onCh) =>
      CheckboxListTile(
        title: Text(txt),
        value: val,
        onChanged: onCh,
        controlAffinity: ListTileControlAffinity.leading,
      );

  Widget _buildButton(String txt, Color col, VoidCallback onP) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: col,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: onP,
        child: Text(txt,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      );

  String generatePairingCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(rng.nextInt(chars.length))));
  }
}
