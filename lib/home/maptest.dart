import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapTestPage extends StatefulWidget {
  const MapTestPage({super.key});
  @override
  State<MapTestPage> createState() => _MapTestPageState();
}

class _MapTestPageState extends State<MapTestPage> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
    _checkLocationPermission();
  }

  Future<void> _loadGeoJson() async {
    final geojsonStr = await rootBundle.loadString('assets/map.json');
    final geojson = jsonDecode(geojsonStr);

    final List<Marker> markers = [];

    for (var feature in geojson['features']) {
      final coords = feature['geometry']['coordinates'];
      final props = feature['properties'];
      final lat = coords[1], lng = coords[0];

      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(lat, lng),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    props['地點'] ?? '未知地點',
                    style: const TextStyle(fontSize: 16), // 🔹 地點字體縮小
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

    // ✅ 取得目前位置並移動地圖
    final pos = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(pos.latitude, pos.longitude);
    _mapController.move(userLatLng, 17); // 放大街區級別
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Map v6.2.1")),
      body: FlutterMap(
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final pos = await Geolocator.getCurrentPosition();
            final latLng = LatLng(pos.latitude, pos.longitude);
            _mapController.move(latLng, 17);
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
}
