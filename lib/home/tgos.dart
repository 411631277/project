import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TgosMapPage extends StatefulWidget {
  const TgosMapPage({super.key});

  @override
  State<TgosMapPage> createState() => _TgosMapPageState();
}

class _TgosMapPageState extends State<TgosMapPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // ✅ 啟用 JS
      ..loadRequest(Uri.parse("https://map.tgos.tw/TGOSCloudMap"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TGOS 地圖")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
