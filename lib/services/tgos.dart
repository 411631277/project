import 'dart:convert';
import 'package:http/http.dart' as http;

/// 範例：儲存 Tgos 地點查詢 (POI) 結果的資料類別
class TgosPoi {
  final String name; // 地點名稱
  final double lat; // 緯度
  final double lng; // 經度

  TgosPoi({
    required this.name,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() => 'TgosPoi(name: $name, lat: $lat, lng: $lng)';
}

/// 負責呼叫 Tgos 後端服務的類別
class TgosService {
  /// 範例方法：依關鍵字查詢附近地點，回傳 List(tgospoi)
  /// 需依照 Tgos 官方文件，替換成實際 API URL 與參數。
  Future<List<TgosPoi>> searchPlaces(String keyword) async {
    // 1. 構建 Tgos API URL（此為示範）
    //    請務必參考 Tgos 實際 API 文件，以取得正確 endpoint、參數與金鑰
    final String tgosApiKey = 'YOUR_TGOS_API_KEY'; // 若需要金鑰，可在此帶入
    final url = Uri.parse(
      'https://api.tgos.tw/someEndpoint?keyword=$keyword&key=$tgosApiKey&otherParams=xxx',
    );

    // 2. 發送 HTTP GET 請求
    final response = await http.get(url);

    // 3. 檢查回傳狀態碼
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // 4. 解析 data，依照 Tgos 回傳 JSON 結構取出地點列表
      //    下方為「假設」結構，實際請以 Tgos 文件為準
      final List<dynamic> results = data['results'] ?? [];

      // 5. 建立 TgosPoi 清單並回傳
      return results.map((item) {
        // 假設 item 裡有 'name', 'lat', 'lng'
        return TgosPoi(
          name: item['name'],
          lat: (item['lat'] as num).toDouble(),
          lng: (item['lng'] as num).toDouble(),
        );
      }).toList();
    } else {
      // 若請求失敗，丟出例外
      throw Exception('Tgos searchPlaces failed: ${response.statusCode}');
    }
  }

  /// 範例方法：逆地理編碼 (將座標轉為地址) - 若有需要
  /// 同樣需要依照 Tgos API 文件，替換成正確 endpoint 與參數
  Future<String> reverseGeocode(double lat, double lng) async {
    final String tgosApiKey = 'YOUR_TGOS_API_KEY';
    final url = Uri.parse(
      'https://api.tgos.tw/anotherEndpoint?lat=$lat&lng=$lng&key=$tgosApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 假設回傳 JSON 有一個 'address' 欄位
      return data['address'] ?? '未知地址';
    } else {
      throw Exception('Tgos reverseGeocode failed: ${response.statusCode}');
    }
  }
}
