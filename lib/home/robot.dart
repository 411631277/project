import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter/gestures.dart';

final Logger logger = Logger();

class RobotWidget extends StatefulWidget {
  final String userId;
  final bool isManUser;

  const RobotWidget({
    super.key,
    required this.userId,
    required this.isManUser,
  });

  @override
  State<RobotWidget> createState() => _RobotWidgetState();
}

/// 允許滑鼠拖曳滾動
class MouseDraggableScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _RobotWidgetState extends State<RobotWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final String apiUrl = "http://163.13.202.126:8000/query";

  /// 第一組快速回覆
  final List<String> _quickReplies = [
    "產科住院環境資訊",
    "母乳哺餵的好處",
    "產後衛教部分",
    "其他"
  ];

  /// 第二組快速回覆
  final List<String> _secondCardReplies = [
    "媽媽手冊-產前篇",
    "媽媽手冊-產後篇",
    "父親衛教資訊",
    "寶寶母乳需求量&促進乳汁分泌方法",
  ];

  /// 用來記錄「何時顯示第二組快速回覆」的位置
  final List<int> _secondCardAfterIndexes = [];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'sender': 'chatgpt',
      'text': '你好，請問有需要幫助什麼嗎？',
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 發送訊息給後端或顯示「其他資訊」
  Future<void> _sendMessage(String userInput, {bool sendToBackend = true}) async {
    if (userInput.trim().isEmpty) return;

    _messageController.clear();

    // 如果使用者點選「其他」，則不送後端，直接顯示第二組選項
    if (!sendToBackend) {
      setState(() {
        _messages.add({'sender': 'user', 'text': userInput});
        _messages.add({'sender': 'chatgpt', 'text': '以下是其他資訊'});
        _secondCardAfterIndexes.add(_messages.length); 
        // 記錄在這個位置之後，顯示第二組快速回覆
      });
      _scrollToBottom();
      return;
    }

    // 正常送給後端
    setState(() {
      _messages.add({'sender': 'user', 'text': userInput});
      _messages.add({'sender': 'chatgpt', 'text': '🤖 正在思考...'});
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': userInput,
          'user_id': widget.userId,
          'is_man_user': widget.isManUser,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _messages.last['text'] = decodedResponse["answer"] ?? "🤖 無法取得回應";
        });
      } else {
        setState(() {
          _messages.last['text'] = '⚠️ 伺服器錯誤，請稍後再試。';
        });
      }
    } catch (e) {
      setState(() {
        _messages.last['text'] = '⚠️ 無法連接到伺服器，請檢查網路或稍後再試。';
      });
    }
    _scrollToBottom();
  }

  /// 建立快速回覆按鈕群組
  Widget _buildQuickReplyCards(List<String> replies) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10, left: 40),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: replies.map((text) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  if (text.trim() == "其他") {
                    _sendMessage(text, sendToBackend: false);
                  } else {
                    _sendMessage(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 238, 239),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontSize: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(text, textAlign: TextAlign.center),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("孕母助理小美", style: TextStyle(color: Colors.brown)),
        backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = (message['sender'] == 'user');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isUser)
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                'assets/images/Robot.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue.shade100
                                    : Colors.brown.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message['text'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // **第一則訊息後顯示 _quickReplies**
                      if (index == 0) _buildQuickReplyCards(_quickReplies),

                      // **在 _secondCardAfterIndexes 指定位置後顯示 _secondCardReplies**
                      if (_secondCardAfterIndexes.contains(index + 1))
                        _buildQuickReplyCards(_secondCardReplies),
                    ],
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "輸入訊息",
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.brown),
                    onPressed: () {
                      _sendMessage(_messageController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
