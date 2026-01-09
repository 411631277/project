import 'dart:convert';
import 'package:doctor_2/home/webview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:async';

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
  StreamSubscription<String>? _sseSub;
  Completer<void>? _sseCompleter;
  bool _isDisposed = false;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final String apiUrl = "http://163.13.202.126:8000/query";

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

  /// 用來記錄「何時顯示第二組快速回覆」的位置
  final List<int> _secondCardAfterIndexes = [];
  final List<int> _manualCardAfterIndexes = [];
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
    if (!mounted || _isDisposed) return;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}


void _safeSetState(VoidCallback fn) {
  if (!mounted || _isDisposed) return;
  setState(fn);
}

  /// 發送訊息給後端或顯示「其他資訊」
  Future<void> _sendMessage(String userInput,
      {bool sendToBackend = true, bool manualVisible = true}) async {
    if (userInput.trim().isEmpty) return;

    _messageController.clear();

    if (!sendToBackend) {
      _safeSetState(() {
        _messages.add({'sender': 'user', 'text': userInput});
        _messages.add({'sender': 'chatgpt', 'text': '下列是有關其他衛教資訊'});
        _secondCardAfterIndexes.add(_messages.length);
      });
      _scrollToBottom();
      return;
    }

    if (!manualVisible) {
      _safeSetState(() {
        _messages.add({'sender': 'user', 'text': userInput});
        _messages.add({'sender': 'chatgpt', 'text': '下列是有關媽媽手冊的資訊'});
        _manualCardAfterIndexes.add(_messages.length);
      });
      _scrollToBottom();
      return;
    }

    _safeSetState(() {
      _messages.add({'sender': 'user', 'text': userInput});
      _messages.add({'sender': 'chatgpt', 'text': '正在思考...'}); // 立即顯示
    });
    _scrollToBottom();

    try {
      final request = http.Request("POST", Uri.parse(apiUrl));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'message': userInput,
        'user_id': widget.userId,
        'is_man_user': widget.isManUser,
      });

      final response = await request.send();

      if (response.statusCode == 200) {
String buffer = '';

// ✅ 先取消前一次 SSE（避免連按多次）
await _sseSub?.cancel();
_sseCompleter = Completer<void>();

_sseSub = response.stream
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .listen((line) {
  if (_isDisposed) return;

  if (line.startsWith("data: ")) {
    final jsonPart = line.replaceFirst("data: ", "");
    if (jsonPart.trim() == "[DONE]") {
      _sseCompleter?.complete();
      return;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(jsonPart);
      final chunk = data['data'] ?? '';
      buffer += chunk;

      _safeSetState(() {
        if (_messages.isNotEmpty) {
          _messages.last['text'] = buffer;
        }
      });
      _scrollToBottom();
    } catch (e) {
      logger.e("解析失敗: $e");
    }
  }
}, onDone: () {
  _sseCompleter?.complete();
}, onError: (e) {
  logger.e("SSE錯誤: $e");
  _safeSetState(() {
    if (_messages.isNotEmpty) {
      _messages.last['text'] = '發生錯誤，請稍後再試。';
    }
  });
});

// ✅ 等待 SSE 結束；如果你返回上一頁，dispose() 會 complete，不會卡住
await _sseCompleter!.future;
      } else {
        _safeSetState(() {
          _messages.last['text'] = '伺服器錯誤，請稍後再試。';
        });
      }
    } catch (e) {
      logger.e("發送錯誤: $e");
      _safeSetState(() {
        _messages.last['text'] = '無法連接到伺服器，請檢查網路或稍後再試。';
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
void dispose() {
  _isDisposed = true;
  _sseSub?.cancel();
  _sseCompleter?.complete(); // 避免 await 卡住
  _messageController.dispose();
  _scrollController.dispose();
  super.dispose();
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
                              child: _buildMessageText(
                                message['text'] ?? '',
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

  Widget _buildMessageText(String rawText) {
    String cleanedText = cleanTextForLinkify(rawText);

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
