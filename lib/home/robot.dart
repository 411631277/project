import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class RobotWidget extends StatefulWidget {
  final String userId;    // 使用者ID
  final bool isManUser;   // 是否 man_users

  const RobotWidget({
    super.key,
    required this.userId,
    required this.isManUser,
  });

  @override
  State<RobotWidget> createState() => _RobotWidgetState();
}

class _RobotWidgetState extends State<RobotWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // 您的後端 API
  final String apiUrl = "http://180.176.211.159:8000/query";

  // 三個快捷選項
  final List<String> _quickReplies = ["產科住院環境資訊", "母乳哺餵的好處", "媽媽手冊-產前篇", "媽媽手冊-產後篇", "　產後衛教部分 ", "寶寶母乳需求量", "促進乳汁分泌方法", "父親衛教資訊"];

  // 🔹 用來控制「是否顯示快捷選項」
  bool _showQuickReplies = true;

  @override
  void initState() {
    super.initState();
    // 初始化：機器人先發一句話
    _messages.add({
      'sender': 'chatgpt',
      'text': '你好，請問有需要幫助什麼嗎？',
    });
  }

  /// 發送訊息給後端
  Future<void> _sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;

    // 1. 加入使用者訊息
    setState(() {
      _messages.add({'sender': 'user', 'text': userInput});
      // 加入機器人思考中...
      _messages.add({'sender': 'chatgpt', 'text': '🤖 正在思考...'});
    });

    // 清空輸入框
    _messageController.clear();

    try {
      logger.i("📡 發送請求給 API: user_id=${widget.userId}, isManUser=${widget.isManUser}");
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
        final reply = utf8.decode(response.bodyBytes).trim();

        setState(() {
          // 將最後一則「🤖 正在思考...」改為真正回覆
          _messages.last['text'] = reply.replaceAll("\\n", "\n");
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
        actions: [
    Row(
      mainAxisSize: MainAxisSize.min, 
      children: [
        const Text("提示", style: TextStyle(color: Colors.brown)),
        Switch(
          value: _showQuickReplies,
          onChanged: (bool newValue) {
            setState(() {
              _showQuickReplies = newValue;
            });
          },
        ),
      ],
    ),
  ],
),
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Column(
          children: [
            // 聊天訊息
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = (message['sender'] == 'user');
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      // 如果是機器人，就顯示機器人頭像
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
                            softWrap: true,
                            maxLines: null,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 🔹 若 _showQuickReplies 為 true，才顯示快捷按鈕
            if (_showQuickReplies)
              Container(
                color: const Color.fromRGBO(233, 227, 213, 1),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Wrap(
                  spacing: 8.0,
                  children: _quickReplies.map((text) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 240, 238, 239),
                      ),
                      onPressed: () => _sendMessage(text),
                      child: Text(text, style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),

            // 🔹 輸入欄
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
