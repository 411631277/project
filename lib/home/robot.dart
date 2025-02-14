import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RobotWidget extends StatefulWidget {
  const RobotWidget({super.key});

  @override
  State<RobotWidget> createState() => _RobotWidgetState();
}

class _RobotWidgetState extends State<RobotWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String apiUrl = "180.176.211.159:8000/static/index.html"; // 聊天記錄

  @override
  void initState() {
    super.initState();
    // 頁面初始化時，ChatGPT 自動發送初始訊息
    _messages.add({'sender': 'chatgpt', 'text': '你好，請問有需要幫助什麼嗎?'});
  }

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'text': message}); // 用戶訊息
      });

      try {
        // 發送 API 請求
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'question': message}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final reply = data['answer'] ?? '抱歉，我不太明白您的問題。';

          // 更新 ChatGPT 的回應
          setState(() {
            _messages.add({'sender': 'chatgpt', 'text': reply});
          });
        } else {
          // API 錯誤處理
          setState(() {
            _messages.add({'sender': 'chatgpt', 'text': '抱歉，系統出現了一些問題。'});
          });
        }
      } catch (e) {
        // 網路錯誤處理
        setState(() {
          _messages.add({'sender': 'chatgpt', 'text': '無法連接到服務器，請稍後再試。'});
        });
      }

      // 清空輸入框
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(233, 227, 213, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Robot",
          style: TextStyle(color: Colors.brown),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(233, 227, 213, 1),
        child: Column(
          children: [
            // 顯示聊天內容
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'user';
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      // 如果是 ChatGPT，顯示機器人圖片
                      if (!isUser)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'assets/images/Robot.png', // 替換為你的機器人圖片路徑
                            width: 30,
                            height: 30,
                          ),
                        ),
                      // 訊息氣泡
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
                            message['text']!,
                            softWrap: true, // 確保文字自動換行
                            style: TextStyle(
                              fontSize: 14,
                              color: isUser ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 輸入框
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.white,
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
                    onPressed: () => _sendMessage(_messageController.text),
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
