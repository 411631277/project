import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class RobotWidget extends StatefulWidget {
  final String userId; // 直接從外部傳入
  final bool isManUser; // 傳入是否為 manUser

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

  // 改成 userId + isManUser
  final String apiUrl = "http://180.176.211.159:8000/query";

  @override
  void initState() {
    super.initState();
    // 初始化聊天時，ChatGPT 自動發送一句話
    _messages.add({
      'sender': 'chatgpt',
      'text': '你好，請問有需要幫助什麼嗎?',
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        // 1. 加入使用者訊息
        _messages.add({'sender': 'user', 'text': message});
        // 2. 加入機器人「思考中」提示
        _messages.add({'sender': 'chatgpt', 'text': '🤖 正在思考...'});
      });

      _messageController.clear();

      try {
        // 直接使用 widget.userId + widget.isManUser
        logger.i(
            "📡 發送請求給 API: user_id=${widget.userId}, isManUser=${widget.isManUser}");

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'message': message,
            'user_id': widget.userId, // 取代 session_id
            'is_man_user': widget.isManUser, // 傳送是否 manUser
          }),
        );

        if (response.statusCode == 200) {
          // 直接處理為純文字
          final reply = utf8.decode(response.bodyBytes).trim();

          setState(() {
            // 將最後一則 "🤖 正在思考..." 改為真正回覆
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
            // 聊天內容
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
                            'assets/images/Robot.png',
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
                            softWrap: true,
                            maxLines: null,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
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
