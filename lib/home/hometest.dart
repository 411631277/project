import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const StepCounterApp());
}

class StepCounterApp extends StatelessWidget {
  const StepCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StepCounterScreen(),
    );
  }
}

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  late Stream<StepCount> stepCountStream;
  int _currentSteps = 0;
  int _dailyOffset = 0;
  String _lastDate = "";

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    _lastDate = prefs.getString('lastDate') ?? today;
    int savedOffset = prefs.getInt('dailyOffset') ?? 0;
    int savedSteps = prefs.getInt('lastRawSteps') ?? 0;

    // 如果已換日，記錄前一天資料
    if (_lastDate != today && savedSteps > 0) {
      int yesterdaySteps = savedSteps - savedOffset;
      if (yesterdaySteps >= 0) {
        Map<String, int> history = await _loadStepHistory();
        history[_lastDate] = yesterdaySteps;
        await prefs.setString('stepHistory', jsonEncode(history));
      }
      _dailyOffset = savedSteps;
      _lastDate = today;
      await prefs.setString('lastDate', today);
      await prefs.setInt('dailyOffset', _dailyOffset);
    } else {
      _dailyOffset = savedOffset;
    }

    stepCountStream = Pedometer.stepCountStream;
    stepCountStream.listen(
      (event) => _onStepCount(event.steps),
      onError: (error) => setState(() => _currentSteps = 0),
    );
  }

  Future<Map<String, int>> _loadStepHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('stepHistory');
    if (jsonString == null) return {};
    Map<String, dynamic> map = jsonDecode(jsonString);
    return map.map((key, value) => MapEntry(key, value as int));
  }

  int get _todaySteps => max(0, _currentSteps - _dailyOffset);

  void _onStepCount(int steps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 第一次啟動，或新的一天，自動初始化 offset
    if (_lastDate != today || !prefs.containsKey('dailyOffset')) {
      _dailyOffset = steps;
      _lastDate = today;
      await prefs.setInt('dailyOffset', _dailyOffset);
      await prefs.setString('lastDate', _lastDate);
    } else {
      _dailyOffset = prefs.getInt('dailyOffset') ?? 0;
      _lastDate = prefs.getString('lastDate') ?? today;
    }

    setState(() {
      _currentSteps = steps;
    });

    print("📌 原始步數：$steps");
    print("📌 儲存的 dailyOffset：$_dailyOffset");
  }

  void _showHistoryDialog() async {
    Map<String, int> history = await _loadStepHistory();
    if (!mounted) return;

    // 日期排序
    var sortedKeys = history.keys.toList()..sort();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("歷史步數"),
        content: history.isEmpty
            ? const Text("目前沒有紀錄")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    sortedKeys.map((k) => Text("$k：${history[k]} 步")).toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("關閉"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('計步器'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '今日步數：$_todaySteps',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _showHistoryDialog,
              child: const Text("查看歷史紀錄"),
            ),
          ],
        ),
      ),
    );
  }
}
