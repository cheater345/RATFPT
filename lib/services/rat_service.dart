import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RATService extends ChangeNotifier {
  bool isConnected = false;
  String peerId = '';
  String deviceInfo = '';
  bool isLoading = false;
  RTCPeerConnection? peerConnection;
  RTCDataChannel? dataChannel;

  RATService() {
    _loadDeviceInfo();
    _initWebRTC();
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

  Future<void> _initWebRTC() async {
    // Initialize WebRTC
    await WebRTC.initialize();
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
    notifyListeners();
  }

  void sendCommand(String type, [String? value]) {
    if (!isConnected) return;
    // In a real app, send via dataChannel
    print('📤 Sent: $type ${value ?? ''}');
  }
}
