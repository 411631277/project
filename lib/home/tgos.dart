import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
    WidgetsFlutterBinding.ensureInitialized();  // 確保 Flutter 初始化完成
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted); // 啟用 JavaScript

    // 加載本地 HTML 文件
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final htmlContent = await rootBundle.loadString('assets/tgos_map.html');
    _controller.loadRequest(
      Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TGOS 地圖"),
      ),
      body: WebViewWidget(
        controller: _controller, // 使用 WebViewController
      ),
    );
  }
}
