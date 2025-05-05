// sleep_combined.dart
import 'dart:convert';
import 'dart:math' as math;
import 'package:doctor_2/home/fa_question.dart';
import 'package:doctor_2/questionGroup/sleepGroup/sleepscore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class SleepWidget extends StatefulWidget {
  final String userId;
  final bool isManUser;
  const SleepWidget({super.key, required this.userId , required this.isManUser});

  @override
  State<SleepWidget> createState() => _SleepWidgetState();
}

class _SleepWidgetState extends State<SleepWidget> {
  // 第一部分：填空題 controllers & 答案
  final Map<int, TextEditingController> hourControllers = {
    for (var i = 0; i < 4; i++) i: TextEditingController()
  };
  final Map<int, TextEditingController> minuteControllers = {
    for (var i = 0; i < 5; i++) i: TextEditingController()
  };
  final List<Map<String, dynamic>> _q1 = [
    {
      "type": "fill",
      "question": "過去一個月來，您通常何時上床？",
      "index": 0,
      "hasHour": true,
      "hasMinute": true
    },
    {
      "type": "fill",
      "question": "過去一個月來，您通常多久才能入睡？",
      "index": 1,
      "hasHour": false,
      "hasMinute": true
    },
    {
      "type": "fill",
      "question": "過去一個月來，您早上通常何時起床？",
      "index": 2,
      "hasHour": true,
      "hasMinute": true
    },
    {
      "type": "fill",
      "question": "過去一個月來，您通常實際睡眠可以入睡幾小時？(這可能不同於您在床上的時間)",
      "index": 3,
      "hasHour": true,
      "hasMinute": false
    },
    //下面是選擇題
    {
      "type": "choice",
      "question": "過去一個月內，您多常服用藥物幫助入睡?(處方或非處方)",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "type": "choice",
      "question": "過去一個月內，您多常在用餐、開車或社交場合活動時感到困倦，難以保持清醒?",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "type": "choice",
      "question": "過去一個月內，保持足夠的熱情去完成事情對您來說有多大的問題?",
      "options": ["完全沒有困擾", "很少困擾", "有些困擾", "有很大的困擾"]
    },
    {
      "type": "choice",
      "question": "過去一個月來，整體而言，您覺得自己的睡眠品質如何？",
      "options": ["非常滿意", "還可以", "不滿意", "非常不滿意"]
    },
  ];
  final Map<int, String?> _a1 = {};

  // 第二部分：表格題
  final List<Map<String, dynamic>> _q2 = [
    {
      "question": "無法在 30 分鐘內入睡",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "半夜或凌晨便清醒",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "必須起來上廁所",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "無法舒適呼吸",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "大聲打呼或咳嗽",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "會覺得冷",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "覺得躁熱",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "睡覺時常會做惡夢",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
    {
      "question": "身上有疼痛",
      "options": ["從未發生", "每週少於一次", "每週一或二次", "每週三次或以上"]
    },
  ];
  final Map<int, String?> _a2 = {};

  bool get _isAllAnswered {
    // 填空題
    for (var i = 0; i < 4; i++) {
      if (_q1[i]['hasHour'] && hourControllers[i]!.text.trim().isEmpty) {
        return false;
      }
      if (_q1[i]['hasMinute'] && minuteControllers[i]!.text.trim().isEmpty) {
        return false;
      }
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
         if (widget.isManUser) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FaQuestionWidget(
          userId: widget.userId,
          isManUser: true,
        ),
      ),
    );
  } else {
    Navigator.pushReplacementNamed(
      context,
      '/QuestionWidget',
      arguments: {
        'userId': widget.userId,
        'isManUser': false,
      },
    );
  }
},
        child: Scaffold(
          body: Container(
            color: const Color.fromRGBO(233, 227, 213, 1),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        return _buildFillQuestion(q, base);
                      } else {
                        return _buildChoiceQuestion(i, q, base);
                      }
                    }),

                    const Divider(
                        height: 32, thickness: 1, color: Colors.brown),

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
                            if (widget.isManUser) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FaQuestionWidget(
          userId: widget.userId,
          isManUser: true,
        ),
      ),
    );
  } else {
    Navigator.pushReplacementNamed(
      context,
      '/QuestionWidget',
      arguments: {
        'userId': widget.userId,
        'isManUser': false,
      },
    );
  }
},
                          child: Transform.rotate(
                            angle: math.pi,
                            child: Image.asset('assets/images/back.png',
                                width: w * 0.15),
                          ),
                        ),
                        if (_isAllAnswered)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              backgroundColor: Colors.brown.shade400,
                            ),
                            onPressed: _handleSubmit,
                            child: Text("提交完成",
                                style: TextStyle(
                                    fontSize: base * 0.045,
                                    color: Colors.white)),
                          ),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget _buildFillQuestion(Map<String, dynamic> q, double base) {
    final idx = q['index'] as int;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text(
            "${idx + 1}. ${q['question']}",
            style: TextStyle(
                fontSize: base * 0.045,
                color: Color.fromRGBO(147, 129, 108, 1)),
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
          Text("時",
              style: TextStyle(
                  fontSize: base * 0.045,
                  color: Color.fromRGBO(147, 129, 108, 1))),
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
          Text("分",
              style: TextStyle(
                  fontSize: base * 0.045,
                  color: Color.fromRGBO(147, 129, 108, 1))),
        ],
      ]),
    );
  }

  Widget _buildChoiceQuestion(
      int uiIndex, Map<String, dynamic> q, double base) {
    final answerIndex = _q1.indexOf(q);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${answerIndex + 1}. ${q['question']}",
            style: TextStyle(
                fontSize: base * 0.035,
                color: Color.fromRGBO(147, 129, 108, 1))),
        const SizedBox(height: 4),
        ...List.generate((q['options'] as List<String>).length, (i) {
          final opt = q['options'][i];
          return Row(children: [
            Radio<String>(
              value: opt,
              groupValue: _a1[answerIndex],
              onChanged: (v) => setState(() => _a1[answerIndex] = v),
            ),
            Expanded(
                child: Text(opt,
                    style: TextStyle(
                        fontSize: base * 0.035,
                        color: Color.fromRGBO(147, 129, 108, 1)))),
          ]);
        }),
      ]),
    );
  }

  Future<void> _handleSubmit() async {
    final collectionName = widget.isManUser ? "Man_users" : "users";

    logger.i("👤 提交者 userId: ${widget.userId}");

    final doc = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId)
        .collection("questions")
        .doc("SleepWidget");

    final formatted1 = <String, String>{};
    for (var i = 0; i < 4; i++) {
      final h = hourControllers[i]!.text.trim();
      final m = minuteControllers[i]!.text.trim();
      final part1 = h.isNotEmpty ? "$h時" : "";
      final part2 = m.isNotEmpty ? "$m分" : "";
      formatted1["填空${i + 1}"] =
          [part1, part2].where((s) => s.isNotEmpty).join(" ");
    }

    for (var i = 4; i < _q1.length; i++) {
      formatted1["選擇${i + 1}"] = _a1[i]!;
    }

    // 第二部分格式化
    final Map<String, String?> formatted2 = {};
    for (var i = 0; i < _q2.length; i++) {
      formatted2["${i + 1}"] = _a2[i]!;
    }

    final subsleepScore = _calculateSubjectiveSleepQualityScore();
    formatted1["主觀睡眠分數"] = subsleepScore.toString();

    final sleepDifficulty = _calculateSleepDifficultyScore();
    formatted1["入睡困難分數"] = sleepDifficulty.toString();

    final durationScore = _calculateSleepDurationScore();
    formatted1["睡眠持續時間分數"] = durationScore.toString();

    final efficiencyScore = _calculateSleepEfficiencyScore();
    formatted1["睡眠效率分數"] = efficiencyScore.toString();

    final disturbanceScore = _calculateSleepDisturbanceScore();
    formatted1["睡眠干擾分數"] = disturbanceScore.toString();

    final medicationScore = _calculateSleepMedicationScore();
    formatted1["藥物使用分數"] = medicationScore.toString();

    final daytimeScore = _calculateSleepDaytimeFunctionScore();
    formatted1["日間功能分數"] = daytimeScore.toString();

    final sleeptotal = _calculateSleepTotalScore();
    formatted1["總分"] = sleeptotal.toString();

// ✅ DEBUG log 檢查
    logger.i("📤 最終要上傳的 formatted1 結果：$formatted1");
    // Firestore 合併寫入
    await doc.set({
      "answers": {
        "SleepWidget": {"data": formatted1, "timestamp": Timestamp.now()},
        "Sleep2Widget": {"data": formatted2, "timestamp": Timestamp.now()},
      }
    }, SetOptions(merge: true));
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId.toString())
        .update({"sleepCompleted": true});

    // 同步到 MySQL
    await _sendAllToMySQL();

    if (context.mounted) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Sleepscore(
            userId: widget.userId,
            totalScore: sleeptotal,
            isManUser: widget.isManUser,
            scoreMap: {
              "主觀睡眠品質分數": subsleepScore,
              "入睡困難分數": sleepDifficulty,
              "睡眠持續時間分數": durationScore,
              "睡眠效率分數": efficiencyScore,
              "睡眠干擾分數": disturbanceScore,
              "藥物使用分數": medicationScore,
              "日間功能分數": daytimeScore,
            }, 
          ),
        ),
      );
    }
  }

  Future<void> _sendAllToMySQL() async {
    final url = Uri.parse('http://163.13.201.85:3000/sleep');
    final now = DateTime.now();
    final date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // 1) 先組固定欄位 & Q1 填空題（1–5）
    final Map<String, dynamic> payload = {
      'user_id': int.parse(widget.userId),
      'sleep_question_content': "睡眠品質量表",
      'sleep_test_date': date,
      'sleep_answer_1_a':
          int.tryParse(hourControllers[0]?.text.trim() ?? '') ?? 0,
      'sleep_answer_1_b':
          int.tryParse(minuteControllers[0]?.text.trim() ?? '') ?? 0,
      'sleep_answer_2':
          int.tryParse(minuteControllers[1]?.text.trim() ?? '') ?? 0,
      'sleep_answer_3_a':
          int.tryParse(hourControllers[2]?.text.trim() ?? '') ?? 0,
      'sleep_answer_3_b':
          int.tryParse(minuteControllers[2]?.text.trim() ?? '') ?? 0,
      'sleep_answer_4':
          int.tryParse(hourControllers[3]?.text.trim() ?? '') ?? 0,
      'sleep_score_subjective_quality': _calculateSubjectiveSleepQualityScore(),
    };

    // 2) Q1 的選擇題（6–10）
    for (var i = 4; i < _q1.length; i++) {
      payload['sleep_answer_${i + 1}'] = _a1[i] ?? 'none';
    }

    // 3) Q2 的表格題（11–19）
    for (var i = 0; i < _q2.length; i++) {
      // 如果沒選，預設 'none'
      payload['sleep_answer_${9 + i}'] = _a2[i] ?? 'none';
    }

    payload['sleep_score_subjective_quality'] =
        _calculateSubjectiveSleepQualityScore();
    payload['sleep_score_sleep_difficulty'] = _calculateSleepDifficultyScore();
    payload['sleep_score_duration'] = _calculateSleepDurationScore();
    payload['sleep_score_efficiency'] = _calculateSleepEfficiencyScore();
    payload['sleep_score_disturbance'] = _calculateSleepDisturbanceScore();
    payload['sleep_score_medication'] = _calculateSleepMedicationScore();
    payload['sleep_score_daytime_function'] =
        _calculateSleepDaytimeFunctionScore();
    payload['sleep_score_total'] = _calculateSleepTotalScore();
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
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        logger.e("MySQL 同步失敗: ${resp.body}");
      }
    } catch (e) {
      logger.e("MySQL 同步例外: $e");
    }
  }

  Widget _buildSecondChoiceQuestion(
      int i, Map<String, dynamic> q, double base) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${i + 1}.  ${q['question']}",
            style: TextStyle(
                fontSize: base * 0.035,
                color: Color.fromRGBO(147, 129, 108, 1))),
        const SizedBox(height: 4),
        ...List.generate((q['options'] as List<String>).length, (j) {
          final opt = q['options'][j];
          return Row(children: [
            Radio<String>(
              value: opt,
              groupValue: _a2[i],
              onChanged: (v) => setState(() => _a2[i] = v),
            ),
            Expanded(
                child: Text(opt,
                    style: TextStyle(
                        fontSize: base * 0.035,
                        color: Color.fromRGBO(147, 129, 108, 1)))),
          ]);
        }),
      ]),
    );
  }

  int _calculateSubjectiveSleepQualityScore() {
    const mapping = {
      '非常滿意': 0,
      '還可以': 1,
      '不滿意': 2,
      '非常不滿意': 3,
    };

    final answer = _a1[7]; // 第一部分第 8 題（index 7）

    return mapping[answer] ?? 0; // 預設給 0 分（避免 null）
  }

  int _calculateSleepDifficultyScore() {
    // 第 2 題分鐘
    final sleepMinutes = int.tryParse(hourControllers[1]!.text.trim()) ?? 0;

    // 計算第 2 題分數
    int score2 = 0;
    if (sleepMinutes <= 15) {
      score2 = 0;
    } else if (sleepMinutes <= 30) {
      score2 = 1;
    } else if (sleepMinutes <= 59) {
      score2 = 2;
    } else {
      score2 = 3;
    }

    // 第 9 題答案文字
    final q9 = _a2[0]; // 因為 sleep_answer_9 對應 _a2[0]

    const mappingQ9 = {
      '從未發生': 0,
      '每週少於一次': 1,
      '每週一或二次': 2,
      '每週三次或以上': 3,
    };

    final score9 = mappingQ9[q9] ?? 0;

    // 總分
    final total = score2 + score9;

    // 對應最終分數
    if (total == 0) return 0;
    if (total <= 2) return 1;
    if (total <= 4) return 2;
    return 3;
  }

  int _calculateSleepDurationScore() {
    final raw = hourControllers[3]!.text.trim(); // 第 4 題：睡眠時間（小時）
    final hours = int.tryParse(raw) ?? 0;

    if (hours >= 7) return 0;
    if (hours >= 6) return 1;
    if (hours >= 5) return 2;
    return 3;
  }

  int _calculateSleepEfficiencyScore() {
    final sleepHour =
        int.tryParse(hourControllers[3]!.text.trim()) ?? 0; // 第4題：實際睡眠時間
    final bedHour = int.tryParse(_a1[0] ?? '') ?? 0; // 第1題：上床時間
    final wakeHour = int.tryParse(_a1[2] ?? '') ?? 0; // 第3題：起床時間

    // 計算「躺床時間」
    int totalTimeInBed;
    if (wakeHour < bedHour) {
      totalTimeInBed = (24 - bedHour) + wakeHour;
    } else {
      totalTimeInBed = wakeHour - bedHour;
    }

    if (totalTimeInBed == 0) return 3; // 避免除以 0 的錯誤

    double efficiency = sleepHour / totalTimeInBed * 100;

    if (efficiency >= 85) return 0;
    if (efficiency >= 75) return 1;
    if (efficiency >= 65) return 2;
    return 3;
  }

  int _calculateSleepDisturbanceScore() {
    const scoreMap = {
      '從未發生': 0,
      '每週少於一次': 1,
      '每週一或二次': 2,
      '每週三次或以上': 3,
    };

    int total = 0;

    // 題號 10~17 -> 對應 _a2[1]~_a2[8]
    for (int i = 1; i <= 8; i++) {
      final answer = _a2[i];
      total += scoreMap[answer] ?? 0;
    }

    // 對應最終得分轉換
    if (total == 0) return 0;
    if (total <= 8) return 1;
    if (total <= 16) return 2;
    return 3;
  }

  int _calculateSleepMedicationScore() {
    const mapping = {
      '從未發生': 0,
      '每週少於一次': 1,
      '每週一或二次': 2,
      '每週三次或以上': 3,
    };

    final answer = _a1[4];
    return mapping[answer] ?? 0;
  }

  int _calculateSleepDaytimeFunctionScore() {
    const mapping6 = {
      '從未發生': 0,
      '每週少於一次': 1,
      '每週一或二次': 2,
      '每週三次或以上': 3,
    };

    const mapping7 = {
      '完全沒有困擾': 0,
      '有一點困擾': 1,
      '有中等程度困擾': 2,
      '有很大的困擾': 3,
    };

    final score6 = mapping6[_a1[5]] ?? 0;
    final score7 = mapping7[_a1[6]] ?? 0;

    final avg = (score6 + score7) / 2;
    return avg.ceil();
  }

  int _calculateSleepTotalScore() {
    return _calculateSubjectiveSleepQualityScore() +
        _calculateSleepDifficultyScore() +
        _calculateSleepDurationScore() +
        _calculateSleepEfficiencyScore() +
        _calculateSleepDisturbanceScore() +
        _calculateSleepMedicationScore() +
        _calculateSleepDaytimeFunctionScore();
  }
}
