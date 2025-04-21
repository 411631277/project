// sleep_combined.dart
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class SleepWidget extends StatefulWidget {
  final String userId;
  const SleepWidget({super.key, required this.userId});

  @override
  State<SleepWidget> createState() => _SleepWidgetState();
}

class _SleepWidgetState extends State<SleepWidget> {
  // 第一部分：填空題 controllers & 答案
  final Map<int, TextEditingController> hourControllers = {
    for (var i = 0; i < 5; i++) i: TextEditingController()
  };
  final Map<int, TextEditingController> minuteControllers = {
    for (var i = 0; i < 5; i++) i: TextEditingController()
  };
  final List<Map<String, dynamic>> _q1 = [
    {"type":"fill","question":"過去一個月來，您通常何時上床？","index":0,"hasHour":true,"hasMinute":true},
    {"type":"fill","question":"過去一個月來，您通常多久才能入睡？","index":1,"hasHour":false,"hasMinute":true},
    {"type":"fill","question":"過去一個月來，您早上通常何時起床？","index":2,"hasHour":true,"hasMinute":true},
    {"type":"fill","question":"過去一個月來，您通常實際睡眠可以入睡幾小時？","index":3,"hasHour":true,"hasMinute":false},
    {"type":"fill","question":"過去一個月來，您平均一天睡幾小時？","index":4,"hasHour":true,"hasMinute":false},
    {"type":"choice","question":"您覺得睡眠品質好嗎?","options":["很好","好","不好","很不好"]},
    {"type":"choice","question":"過去一個月來，整體而言，您覺得自己的睡眠品質如何？","options":["很好","好","不好","很不好"]},
    {"type":"choice","question":"過去一個月來，您通常一星期幾個晚上需要使用藥物幫忙睡眠？","options":["從未發生","約一兩次","三次或以上"]},
    {"type":"choice","question":"過去一個月來，您是否曾在用餐、開車或社交場合瞌睡而無法保持清醒，每星期約幾次?","options":["從未發生","約一兩次","三次或以上"]},
    {"type":"choice","question":"過去一個月來，您會感到無心完成該做的事","options":["沒有","有一點","的確有","很嚴重"]},
  ];
  final Map<int, String?> _a1 = {};

  // 第二部分：表格題
  final List<String> _q2 = [
    "無法在 30 分鐘內入睡",
    "半夜或凌晨便清醒",
    "必須起來上廁所",
    "覺得呼吸不順暢",
    "大聲打鼾或咳嗽",
    "會覺得冷",
    "覺得躁熱",
    "睡覺時常會做惡夢",
    "身上有疼痛",
  ];
  final Map<int, String?> _a2 = {};

  bool get _isAllAnswered {
    // 填空題
    for (var i = 0; i < 5; i++) {
      if (_q1[i]['hasHour'] && hourControllers[i]!.text.trim().isEmpty) return false;
      if (_q1[i]['hasMinute'] && minuteControllers[i]!.text.trim().isEmpty) return false;
    }
    // 第一部分選擇題
    for (var i = 5; i < _q1.length; i++) {
      if ((_a1[i] ?? '').isEmpty) return false;
    }
    // 第二部分表格題
    if (_a2.length != _q2.length) return false;
    return true;
  }

  @override
  void dispose() {
    // 改用傳統 for 迴圈，不要 forEach
    for (final c in hourControllers.values) {
      c.dispose();
    }
    for (final c in minuteControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ==== 第一部分 ==== //
            const Text(
              "睡眠評估問卷",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_q1.length, (i) {
              final q = _q1[i];
              if (q['type'] == 'fill') {
                return _buildFillQuestion(q);
              } else {
                return _buildChoiceQuestion(i, q);
              }
            }),

            const Divider(height: 32, thickness: 1, color: Colors.brown),

            // ==== 第二部分 ==== //
            const Text(
              "以下問題選擇一個適當的答案打勾，請全部作答",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              border: const TableBorder.symmetric(
                inside: BorderSide(color: Colors.black12),
              ),
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(233, 227, 213, 1),
                  ),
                  children: [
                    _buildHeaderCell("題目"),
                    _buildHeaderCell("從未發生"),
                    _buildHeaderCell("約一兩次"),
                    _buildHeaderCell("三次或以上"),
                  ],
                ),
                ...List.generate(_q2.length, (i) {
                  return TableRow(
                    decoration: BoxDecoration(
                      color: _a2[i] != null
                          ? const Color.fromARGB(255, 241, 215, 237)
                          : const Color.fromRGBO(233, 227, 213, 1),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${i + 1}. ${_q2[i]}",
                            style: const TextStyle(fontSize: 14)),
                      ),
                      _buildRadioCell(i, "從未發生"),
                      _buildRadioCell(i, "約一兩次"),
                      _buildRadioCell(i, "三次或以上"),
                    ],
                  );
                }),
              ],
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Image.asset('assets/images/back.png', width: w * 0.15),
                  ),
                ),
                if (_isAllAnswered)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.brown.shade400,
                    ),
                    onPressed: _handleSubmit,
                    child: const Text("提交完成", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildFillQuestion(Map<String, dynamic> q) {
    final idx = q['index'] as int;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text(
            "${idx + 1}. ${q['question']}",
            style: const TextStyle(fontSize: 16, color: Color.fromRGBO(147, 129, 108, 1)),
          ),
        ),
        if (q['hasHour']) ...[
          Expanded(
            flex: 1,
            child: TextField(
              controller: hourControllers[idx],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const Text("時", style: TextStyle(fontSize: 14, color: Color.fromRGBO(147, 129, 108, 1))),
        ],
        if (q['hasMinute']) ...[
          Expanded(
            flex: 1,
            child: TextField(
              controller: minuteControllers[idx],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const Text("分", style: TextStyle(fontSize: 14, color: Color.fromRGBO(147, 129, 108, 1))),
        ],
      ]),
    );
  }

  Widget _buildChoiceQuestion(int uiIndex, Map<String, dynamic> q) {
    final answerIndex = _q1.indexOf(q);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${answerIndex + 1}. ${q['question']}",
            style: const TextStyle(fontSize: 14, color: Color.fromRGBO(147, 129, 108, 1))),
        const SizedBox(height: 4),
        ...List.generate((q['options'] as List<String>).length, (i) {
          final opt = q['options'][i];
          return Row(children: [
            Radio<String>(
              value: opt,
              groupValue: _a1[answerIndex],
              onChanged: (v) => setState(() => _a1[answerIndex] = v),
            ),
            Expanded(child: Text(opt, style: const TextStyle(fontSize: 12, color: Color.fromRGBO(147, 129, 108, 1)))),
          ]);
        }),
      ]),
    );
  }

  Widget _buildHeaderCell(String label) => SizedBox(
        height: 40,
        child: Center(child: Text(label, style: const TextStyle(fontSize: 12))),
      );

  Widget _buildRadioCell(int idx, String val) => Center(
        child: Radio<String>(
          value: val,
          groupValue: _a2[idx],
          onChanged: (v) => setState(() => _a2[idx] = v),
        ),
      );

  Future<void> _handleSubmit() async {
    final doc = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("questions")
        .doc("SleepWidget");

    // 第一部分格式化
    final Map<String, String?> formatted1 = {};
    for (var i = 0; i < 5; i++) {
      final h = hourControllers[i]!.text.trim();
      final m = minuteControllers[i]!.text.trim();
      final part1 = h.isNotEmpty ? "$h時" : "";
      final part2 = m.isNotEmpty ? "$m分" : "";
      formatted1["填空${i + 1}"] = [part1, part2].where((s) => s.isNotEmpty).join(" ");
    }
    for (var i = 5; i < _q1.length; i++) {
      formatted1["選擇${i + 1}"] = _a1[i]!;
    }

    // 第二部分格式化
    final Map<String, String?> formatted2 = {};
    for (var i = 0; i < _q2.length; i++) {
      formatted2["${i + 1}"] = _a2[i]!;
    }

    // Firestore 合併寫入
    await doc.set({
      "answers": {
        "SleepWidget": {"data": formatted1, "timestamp": Timestamp.now()},
        "Sleep2Widget": {"data": formatted2, "timestamp": Timestamp.now()},
      }
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .update({"sleepCompleted": true});

    // 同步到 MySQL
    await _sendAllToMySQL();


    if (context.mounted) {
    if (!mounted) return;
      Navigator.pushNamed(context, '/FinishWidget', arguments: widget.userId);
    }
  }


  Future<void> _sendAllToMySQL() async {
  final url = Uri.parse('http://163.13.201.85:3000/sleep');
  final now = DateTime.now();
  final date = "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";

  // 1) 先組固定欄位 & Q1 填空題（1–5）
  final Map<String, dynamic> payload = {
    'user_id': int.parse(widget.userId),
    'sleep_question_content': "睡眠品質量表",
    'sleep_test_date': date,
    'sleep_answer_1_a': int.tryParse(hourControllers[0]!.text.trim()) ?? 0,
    'sleep_answer_1_b': int.tryParse(minuteControllers[0]!.text.trim()) ?? 0,
    'sleep_answer_2':   int.tryParse(minuteControllers[1]!.text.trim()) ?? 0,
    'sleep_answer_3_a': int.tryParse(hourControllers[2]!.text.trim()) ?? 0,
    'sleep_answer_3_b': int.tryParse(minuteControllers[2]!.text.trim()) ?? 0,
    'sleep_answer_4':   int.tryParse(hourControllers[3]!.text.trim()) ?? 0,
    'sleep_answer_5':   int.tryParse(hourControllers[4]!.text.trim()) ?? 0,
  };

  // 2) Q1 的選擇題（6–10）
  for (var i = 0; i < 5; i++) {
    // _a1[5] 對應第 6 題，以此類推
    payload['sleep_answer_${6 + i}'] = _a1[5 + i]!;
  }

  // 3) Q2 的表格題（11–19）
  for (var i = 0; i < _q2.length; i++) {
    // 如果沒選，預設 'none'
    payload['sleep_answer_${11 + i}'] = _a2[i] ?? 'none';
  }

  // 4) payload 檢查：列出哪些欄位是 'none'
  final noneKeys = payload.entries
      .where((e) => e.value == 'none')
      .map((e) => e.key)
      .toList();
  if (noneKeys.isNotEmpty) {
    logger.w("⚠️ payload 中有 'none' 值: $noneKeys");
  }
  // 5) 顯示最終 payload
  logger.i("📦 最終送出 payload: $payload");

  // 6) 發 HTTP
  try {
    final resp = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: jsonEncode(payload),
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      logger.e("MySQL 同步失敗: ${resp.body}");
    }
  } catch (e) {
    logger.e("MySQL 同步例外: $e");
  }
}

}
