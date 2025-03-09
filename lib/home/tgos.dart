import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TgosMapWithGooglePage extends StatefulWidget {
  const TgosMapWithGooglePage({super.key});

  @override
  State<TgosMapWithGooglePage> createState() => _TgosMapWithGooglePageState();
}

class _TgosMapWithGooglePageState extends State<TgosMapWithGooglePage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('附近便利商店')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(25.033964, 121.564468),
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: true, // 顯示藍點(使用者位置)
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _findNearbyStores,
              child: const Text('查詢便利商店'),
            ),
          )
        ],
      ),
    );
  }

  /// 按鈕觸發的查詢流程
  Future<void> _findNearbyStores() async {
    try {
      // 1. 取得使用者當前座標
      final position = await _determinePosition();
      final lat = position.latitude;
      final lng = position.longitude;

      // 2. 呼叫 Places API
      final results = await searchNearbyStores(lat, lng, '便利商店');

      // 3. 清空舊 Marker，建立新 Marker
      setState(() {
        _markers.clear();
        for (var item in results) {
          // 解析回傳 JSON
          final location = item['geometry']['location'];
          final storeLat = location['lat'];
          final storeLng = location['lng'];
          final storeName = item['name'] ?? '無名稱';
          final storeAddr = item['vicinity'] ?? '無地址';

          _markers.add(
            Marker(
              markerId: MarkerId('$storeName-$storeLat-$storeLng'),
              position: LatLng(storeLat, storeLng),
              infoWindow: InfoWindow(title: storeName, snippet: storeAddr),
            ),
          );
        }
      });

      // 4. 移動畫面到使用者位置
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );

    } catch (e) {
      debugPrint('搜尋錯誤: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('搜尋失敗: $e')),
      );
    }
  }

  /// 使用 geolocator 取得使用者位置
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. 檢查是否啟用定位服務
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 服務未開啟
      throw Exception('未啟用定位服務，請至設定中開啟。');
    }

    // 2. 檢查應用程式是否獲得定位權限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 使用者仍拒絕
        throw Exception('未取得定位權限');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 使用者永久拒絕
      throw Exception('定位權限被永久拒絕，無法取得位置。');
    }

    // 3. 取得目前位置
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// 呼叫 Google Places Nearby Search API
  /// 依照使用者座標 (lat, lng) 與關鍵字 (keyword) 查詢附近店家
  Future<List<Map<String, dynamic>>> searchNearbyStores(
    double lat,
    double lng,
    String keyword,
  ) async {
    // 您的 Google Maps 金鑰 (AIza...)
    const googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

    // rankby=distance -> 自動依距離排序, 不需 radius
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?keyword=$keyword'
      '&location=$lat,$lng'
      '&rankby=distance'
      '&key=$googleApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] ?? [];
      return results.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Places API error: ${response.statusCode}');
    }
  }
}

