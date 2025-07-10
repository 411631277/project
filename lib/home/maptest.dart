import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({super.key});
  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class NamedMarker {
  final LatLng point;
  final String name;

  NamedMarker({required this.point, required this.name});
}

class _LoadingDialog extends StatefulWidget {
  const _LoadingDialog();

  @override
  State<_LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<_LoadingDialog> {
  String _dots = '.';
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dots = _dots.length == 3 ? '.' : '$_dots.';
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 16),
          Text('正在為您導航最近的地點$_dots'),
        ],
      ),
    );
  }
}

class _MapTestPageState extends State<MapTestPage> {
  final MapController _mapController = MapController();
  final List<NamedMarker> _namedMarkers = [];
  List<Marker> _markers = [];
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("親子館&哺乳室地圖"),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            tooltip: '導航最近點',
            onPressed: _getRouteToClosestMarker,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(25.033968, 121.564468),
              initialZoom: 17,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://maps.geoapify.com/v1/tile/osm-bright/{z}/{x}/{y}.png?apiKey=10ea779d8db34eb081697a85212a133a',
                subdomains: ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.app',
                retinaMode: true,
              ),
              MarkerLayer(markers: _markers),
              CurrentLocationLayer(),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 6,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _buildLegend(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final pos = await Geolocator.getCurrentPosition();
            final latLng = LatLng(pos.latitude, pos.longitude);
            _mapController.move(latLng, 18);
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('無法取得目前位置: $e')),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  //方法區
  Future<void> _loadGeoJson() async {
    final geojsonStr = await rootBundle.loadString('assets/map.json');
    final geojson = jsonDecode(geojsonStr);

    final List<Marker> markers = [];

    for (var feature in geojson['features']) {
      final coords = feature['geometry']['coordinates'];
      final props = feature['properties'];
      final lat = coords[1], lng = coords[0];
      final latLng = LatLng(lat, lng); // ✅ 先建立 LatLng
      final name = props['地點'] ?? '未知地點'; // ✅ 從 properties 取得地點名稱

      _namedMarkers.add(NamedMarker(point: latLng, name: name)); // ✅ 使用定義後的變數

      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: latLng,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    name, // 使用 name 變數
                    style: const TextStyle(fontSize: 16),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '備註：${(props['備註'] ?? '').toString().trim().isEmpty ? '無備註' : props['備註']}'),
                      const SizedBox(height: 8),
                      Text('經度：$lng'),
                      Text('緯度：$lat'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('關閉'),
                    ),
                  ],
                ),
              );
            },
            child: Image.asset(
              props['分類'] == '親子館'
                  ? 'assets/icons/icon1.jpg'
                  : 'assets/icons/icon2.png',
              width: 40,
              height: 40,
            ),
          ),
        ),
      );
    }

    setState(() => _markers = markers);
  }

  Future<void> _checkLocationPermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      perm = await Geolocator.requestPermission();
      if (perm != LocationPermission.whileInUse &&
          perm != LocationPermission.always) {
        return;
      }
    }
    //  取得目前位置並移動地圖
    final pos = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(pos.latitude, pos.longitude);
    _mapController.move(userLatLng, 18); // 放大街區級別
  }

  Future<void> _getRouteToClosestMarker() async {
    _showLoadingDialog();
    final userPos = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(userPos.latitude, userPos.longitude);

    // 🔍 從 _namedMarkers 找出最近的地點
    NamedMarker? closest;
    double shortestDistance = double.infinity;

    for (var marker in _namedMarkers) {
      final distance =
          Distance().as(LengthUnit.Meter, userLatLng, marker.point);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        closest = marker;
      }
    }

    if (closest == null) return;

    // 🧭 發送路線請求
    const orsApiKey =
        'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjAzYjk3NDdkYjBlMDQ4MzNiMzVmMjdiMTNiNGQ4YTYwIiwiaCI6Im11cm11cjY0In0=';
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/foot-walking/geojson');

    final response = await http.post(
      url,
      headers: {
        'Authorization': orsApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'coordinates': [
          [userLatLng.longitude, userLatLng.latitude],
          [closest.point.longitude, closest.point.latitude]
        ],
      }),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      final data = jsonDecode(response.body);
      final coords = data['features'][0]['geometry']['coordinates'] as List;
      final points = coords.map((c) => LatLng(c[1], c[0])).toList();

      setState(() {
        _routePoints = points;
      });

      final centerLat = (userLatLng.latitude + closest.point.latitude) / 2;
      final centerLng = (userLatLng.longitude + closest.point.longitude) / 2;
      _mapController.move(LatLng(centerLat, centerLng), 17);

      // ✅ 顯示地點名稱（來自 GeoJSON）
      _showBottomSheetWithPlaceName(closest.name);
    } else {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _showBottomSheetWithPlaceName(String placeName) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          '導航至地點：\n$placeName',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LoadingDialog(),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.9 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '圖例',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset('assets/icons/icon1.jpg', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text('親子館'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset('assets/icons/icon2.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text('哺乳室'),
            ],
          ),
        ],
      ),
    );
  }
}
