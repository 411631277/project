import 'package:doctor_2/home/webview.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:async';

import 'package:doctor_2/services/robot/robot_api.dart';

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

  late final RobotApi _robotApi;

  // ✅ 可取消的串流訂閱（修掉 setState after dispose 的關鍵）
  StreamSubscription<String>? _robotSub;

  bool _isRequestInFlight = false;

  /// 第一組快速回覆
  final List<String> _quickReplies = [
    "媽媽手冊",
    "產後初期注意事項",
    "母乳哺育相關問題",
    "父親知識資訊",
    "其他"
  ];

  /// 第二組快速回覆
  final List<String> _secondCardReplies = [
    "寶寶母乳需求量",
    "促進乳汁分泌方法",
    "親餵與瓶餵的優缺點",
    "哺乳期間的飲食禁忌",
    "母乳餵養的正確姿勢與技巧"
  ];

  final List<String> _manualReplies = [
    "媽媽手冊-產前篇",
    "媽媽手冊-產後篇",
  ];

  final List<int> _secondCardAfterIndexes = [];
  final List<int> _manualCardAfterIndexes = [];

  @override
  void initState() {
    super.initState();

    _robotApi = RobotApi(apiUrl: "http://163.13.202.126:8000/query");

    _messages.add({
      'sender': 'chatgpt',
      'text': '你好，請問有需要幫助什麼嗎？',
    });
  }

  @override
  void dispose() {
    _robotSub?.cancel();
    _robotApi.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _sendMessage(
    String userInput, {
    bool sendToBackend = true,
    bool manualVisible = true,
  }) async {
    if (userInput.trim().isEmpty) return;
    _messageController.clear();

    if (!sendToBackend) {
      if (!mounted) return;
      setState(() {
        _messages.add({'sender': 'user', 'text': userInput});
        _messages.add({'sender': 'chatgpt', 'text': '下列是有關其他衛教資訊'});
        _secondCardAfterIndexes.add(_messages.length);
      });
      _scrollToBottom();
      return;
    }

    if (!manualVisible) {
      if (!mounted) return;
      setState(() {
        _messages.add({'sender': 'user', 'text': userInput});
        _messages.add({'sender': 'chatgpt', 'text': '下列是有關媽媽手冊的資訊'});
        _manualCardAfterIndexes.add(_messages.length);
      });
      _scrollToBottom();
      return;
    }

    // ✅ 送出新問題：取消上一個串流（避免疊加 + 避免 setState after dispose）
    await _robotSub?.cancel();
    _robotSub = null;

    if (!mounted) return;
    setState(() {
      _isRequestInFlight = true;
      _messages.add({'sender': 'user', 'text': userInput});
      _messages.add({'sender': 'chatgpt', 'text': '正在思考...'});
    });
    _scrollToBottom();

    String buffer = '';

    _robotSub = _robotApi
        .queryStream(
          message: userInput,
          userId: widget.userId,
          isManUser: widget.isManUser,
        )
        .listen(
      (chunk) {
        buffer += chunk;
        if (!mounted) return;
        setState(() {
          _messages.last['text'] = buffer;
        });
        _scrollToBottom();
      },
      onError: (e) {
        logger.e("Robot 發送/串流錯誤: $e");
        if (!mounted) return;
        setState(() {
          _messages.last['text'] = '發生錯誤，請稍後再試。';
          _isRequestInFlight = false;
        });
      },
      onDone: () {
        if (!mounted) return;
        setState(() {
          _isRequestInFlight = false;
        });
      },
      cancelOnError: true,
    );
  }

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
                onPressed: _isRequestInFlight
                    ? null
                    : () {
                        if (text.trim() == "其他") {
                          _sendMessage(text, sendToBackend: false);
                        } else if (text.trim() == "媽媽手冊") {
                          _sendMessage(text, manualVisible: false);
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = (message['sender'] == 'user');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                              child: _buildMessageText(message['text'] ?? ''),
                            ),
                          ),
                        ],
                      ),

                      if (index == 0) _buildQuickReplyCards(_quickReplies),

                      if (_secondCardAfterIndexes.contains(index + 1))
                        _buildQuickReplyCards(_secondCardReplies),

                      if (_manualCardAfterIndexes.contains(index + 1))
                        _buildQuickReplyCards(_manualReplies),
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
                      onSubmitted: _isRequestInFlight ? null : _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.brown),
                    onPressed: _isRequestInFlight
                        ? null
                        : () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageText(String rawText) {
    final cleanedText = cleanTextForLinkify(rawText);

    return Linkify(
      text: cleanedText,
      onOpen: (link) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url: link.url),
          ),
        );
      },
    );
  }

  String cleanTextForLinkify(String rawText) {
    return rawText.replaceAllMapped(
      RegExp(r'\((https?:\/\/[^\s()]+)\)'),
      (match) => match.group(1) ?? '',
    );
  }
}
