  import 'dart:convert';
import 'package:http/http.dart' as http;

class TgosPoi {
  final String name;
  final double lat;
  final double lng;
  TgosPoi({required this.name, required this.lat, required this.lng});
}

class TgosService {
  Future<List<TgosPoi>> searchPlaces(String keyword) async {
    // 假設 Tgos API URL 為 https://api.tgos.tw/poi?keyword=...
    final url = Uri.parse('https://api.tgos.tw/poi?keyword=$keyword');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 假設回傳 JSON 結構: { "results": [ { "name": "...", "lat": 25.0, "lng": 121.0 }, ... ] }
      final List results = data['results'] ?? [];
      return results.map((item) {
        return TgosPoi(
          name: item['name'],
          lat: (item['lat'] as num).toDouble(),
          lng: (item['lng'] as num).toDouble(),
        );
      }).toList();
    } else {
      throw Exception('Tgos API error: ${response.statusCode}');
    }
  }
}
