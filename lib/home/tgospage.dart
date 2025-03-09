import 'package:flutter/material.dart';
import 'package:doctor_2/services/tgos.dart';

class TgosTestPage extends StatefulWidget {
  const TgosTestPage({super.key});

  @override
  State<TgosTestPage> createState() => _TgosTestPageState();
}

class _TgosTestPageState extends State<TgosTestPage> {
  final _tgosService = TgosService();
  List<TgosPoi> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tgos 測試')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // 範例：搜尋關鍵字 "便利商店"
              try {
                final results = await _tgosService.searchPlaces('便利商店');
                setState(() {
                  _searchResults = results;
                });
              } catch (e) {
                print('Tgos search error: $e');
              }
            },
            child: const Text('查詢便利商店'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final poi = _searchResults[index];
                return ListTile(
                  title: Text(poi.name),
                  subtitle: Text('(${poi.lat}, ${poi.lng})'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
