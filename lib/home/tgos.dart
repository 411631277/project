import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TgosMapPage extends StatefulWidget {
  const TgosMapPage({super.key});

  @override
  State<TgosMapPage> createState() => _TgosMapPageState();
}

class _TgosMapPageState extends State<TgosMapPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.tgos.tw/MapSites/EmbedMap?themeid=44752&visual=point'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TGOS 親子館 & 哺乳室地圖"),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
