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
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/tgos_map.html');
  }

  void _searchKeyword(String keyword) {
    _controller.runJavaScript('searchByKeyword("$keyword");');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TGOS 地圖")),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.brown[50],
            child: Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: () => _searchKeyword("親子館"), child: const Text("親子館")),
                ElevatedButton(onPressed: () => _searchKeyword("育兒資源中心"), child: const Text("育兒中心")),
                ElevatedButton(onPressed: () => _searchKeyword("公園"), child: const Text("公園")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

