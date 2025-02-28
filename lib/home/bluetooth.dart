import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class BluetoothWidget extends StatefulWidget {
  const BluetoothWidget({super.key});

  @override
  BluetoothWidgetState createState() => BluetoothWidgetState();
}

class BluetoothWidgetState extends State<BluetoothWidget> {
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  String stepCount = "--";

  @override
  void initState() {
    super.initState();
    checkBluetoothStatus();
    scanDevices();
  }

  void checkBluetoothStatus() async {
    bool isSupported = await FlutterBluePlus.isSupported; // ✅ 使用 isSupported
    if (!isSupported) {
      logger.e("此設備不支援藍牙");
      return;
    }
  }

  void scanDevices() async {
    try {
      await FlutterBluePlus.startScan(); // ✅ 移除 `settings` 參數
    } catch (e) {
      logger.e("掃描藍牙設備時發生錯誤: $e");
    }

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      discoverServices(device);
    } catch (e) {
      logger.e("連接設備時發生錯誤: $e");
    }
  }

  void discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.read) {
            List<int> value = await characteristic.read();
            setState(() {
              stepCount = value.toString();
            });
          }
        }
      }
    } catch (e) {
      logger.e("讀取服務時發生錯誤: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('藍牙手環步數統計')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanDevices,
            child: const Text('掃描藍牙設備'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].platformName.isNotEmpty
                      ? devicesList[index].platformName
                      : '未知設備'),
                  subtitle: Text(devicesList[index].remoteId.toString()),
                  onTap: () => connectToDevice(devicesList[index]),
                );
              },
            ),
          ),
          Text('當前步數: $stepCount', style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
