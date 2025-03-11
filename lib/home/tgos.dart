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
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tgos Map')),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          _webViewController = controller;
          // 1. 載入本地 tgos_map.html
          final htmlContent =
              await rootBundle.loadString('assets/tgos_map.html');
          // 2. 轉成 data URI 後載入
          _webViewController.loadUrl(
            Uri.dataFromString(
              htmlContent,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString(),
          );
        },

        // (選用) JS 傳回 Flutter
        javascriptChannels: {
          JavascriptChannel(
            name: 'SendMessageChannel',
            onMessageReceived: (JavascriptMessage message) {
              debugPrint("JS says: ${message.message}");
              // 您可在這裡解析 message，更新 Flutter UI
            },
          ),
        },
      ),
    );
  }
}
