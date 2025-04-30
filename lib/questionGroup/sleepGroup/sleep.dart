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
    {"type":"fill","question":"過去一個月來，您通常實際睡眠可以入睡幾小時？(這可能不同於您在床上的時間)","index":3,"hasHour":true,"hasMinute":false},
    //下面是選擇題
    {"type":"choice","question":"過去一個月內，您多常服用藥物幫助入睡?(處方或非處方)","options":["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"type":"choice","question":"過去一個月內，您多常在用餐、開車或社交場合活動時感到困倦，難以保持清醒?","options":["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"type":"choice","question":"過去一個月內，保持足夠的熱情去完成事情對您來說有多大的問題?","options":["完全沒有問擾","很少困擾","有些困擾","有很大的困擾"]},
    {"type":"choice","question":"過去一個月來，整體而言，您覺得自己的睡眠品質如何？","options":["非常滿意","還可以","不滿意","非常不滿意"]},

  ];
  final Map<int, String?> _a1 = {};

  // 第二部分：表格題
    final List<Map<String, dynamic>> _q2 = [
    {"question": "無法在 30 分鐘內入睡", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "半夜或凌晨便清醒", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "必須起來上廁所", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "無法舒適呼吸", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "大聲打呼或咳嗽", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "會覺得冷", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "覺得躁熱", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "睡覺時常會做惡夢", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
    {"question": "身上有疼痛", "options": ["從未發生","每週少於一次","每週一或二次","每週三次或以上"]},
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
   for (var i = 0; i < _q2.length; i++) {
      if ((_a2[i] ?? '').isEmpty) return false;
    }
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
final h = MediaQuery.of(context).size.height;
final base = math.min(w, h); 
    return PopScope(
canPop: false,
// ignore: deprecated_member_use
onPopInvoked: (didPop) {
Navigator.pushReplacementNamed(
context,
'/QuestionWidget',
arguments: widget.userId, //如果有需要才加
);
},
child: Scaffold(
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ==== 第一部分 ==== //
            Text(
              "睡眠評估問卷",
              style: TextStyle(
              fontSize: base * 0.05,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_q1.length, (i) {
              final q = _q1[i];
              if (q['type'] == 'fill') {
                return _buildFillQuestion(q ,base);
              } else {
                return _buildChoiceQuestion(i, q , base);
              }
            }),

            const Divider(height: 32, thickness: 1, color: Colors.brown),

            // ==== 第二部分 ==== //
            Text(
              "在過去一個月內，以下哪些因素讓您難以入眠、保持睡眠或影響睡眠品質?",
              style: TextStyle(
                fontSize: base * 0.05,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(147, 129, 108, 1),
              ),
            ),
            const SizedBox(height: 8),
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: List.generate(_q2.length, (i) {
    return _buildSecondChoiceQuestion(i, _q2[i], base);
  }),
),

            const SizedBox(height: 24),
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          '/QuestionWidget',
          arguments: widget.userId,
        );
      },
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
        child: Text("提交完成", style: TextStyle(fontSize: base * 0.045, color: Colors.white)),
      ),
  ],
),

          ]),
        ),
      ),
    ));
  }

  Widget _buildFillQuestion(Map<String, dynamic> q , double base) {
    final idx = q['index'] as int;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text(
            "${idx + 1}. ${q['question']}",
            style:  TextStyle(fontSize: base*0.045, color: Color.fromRGBO(147, 129, 108, 1)),
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
           Text("時", style: TextStyle(fontSize: base*0.045, color: Color.fromRGBO(147, 129, 108, 1))),
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
           Text("分", style: TextStyle(fontSize: base*0.045, color: Color.fromRGBO(147, 129, 108, 1))),
        ],
      ]),
    );
  }

  Widget _buildChoiceQuestion(int uiIndex, Map<String, dynamic> q , double base) {
    final answerIndex = _q1.indexOf(q);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${answerIndex + 1}. ${q['question']}",
            style:  TextStyle(fontSize: base*0.035, color: Color.fromRGBO(147, 129, 108, 1))),
        const SizedBox(height: 4),
        ...List.generate((q['options'] as List<String>).length, (i) {
          final opt = q['options'][i];
          return Row(children: [
            Radio<String>(
              value: opt,
              groupValue: _a1[answerIndex],
              onChanged: (v) => setState(() => _a1[answerIndex] = v),
            ),
            Expanded(child: Text(opt, style:  TextStyle(fontSize: base*0.035, color: Color.fromRGBO(147, 129, 108, 1)))),
          ]);
        }),
      ]),
    );
  }


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
 Widget _buildSecondChoiceQuestion(int i, Map<String, dynamic> q, double base) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${i + 1}.  ${q['question']}",
            style: TextStyle(fontSize: base * 0.035, color: Color.fromRGBO(147, 129, 108, 1))),
        const SizedBox(height: 4),
        ...List.generate((q['options'] as List<String>).length, (j) {
          final opt = q['options'][j];
          return Row(children: [
            Radio<String>(
              value: opt,
              groupValue: _a2[i],
              onChanged: (v) => setState(() => _a2[i] = v),
            ),
            Expanded(child: Text(opt, style: TextStyle(fontSize: base * 0.035, color: Color.fromRGBO(147, 129, 108, 1)))),
          ]);
        }),
      ]),
    );
  }
}
