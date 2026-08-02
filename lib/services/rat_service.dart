import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RATService extends ChangeNotifier {
  bool isConnected = false;
  String peerId = '';
  String deviceInfo = '';
  bool isLoading = false;
  WebSocketChannel? _channel;

  RATService() {
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final info = await DeviceInfoPlugin().androidInfo;
    deviceInfo = '''
Model: ${info.model}
Brand: ${info.brand}
Android: ${info.version.release}
SDK: ${info.version.sdkInt}
''';
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    final perms = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.location,
      Permission.manageExternalStorage,
    ];
    await perms.request();
    notifyListeners();
  }

  void connect(String id) {
    isLoading = true;
    notifyListeners();
    // Simulate connection
    Future.delayed(const Duration(seconds: 2), () {
      peerId = id;
      isConnected = true;
      isLoading = false;
      notifyListeners();
    });
  }

  void disconnect() {
    isConnected = false;
    peerId = '';
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    notifyListeners();
  }

  void sendCommand(String type, [String? value]) {
    if (!isConnected) return;
    print('📤 Sent: $type ${value ?? ''}');
  }
}
