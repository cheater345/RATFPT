import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rat_service.dart';
import 'device_screen.dart';
import 'controller_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<RATService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FXTP RAT', style: TextStyle(color: Color(0xFF7c5cfc), fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Color(0xFF7c5cfc)),
            onPressed: () => service.requestPermissions(),
          ),
          IconButton(
            icon: Icon(
              service.isConnected ? Icons.wifi : Icons.wifi_off,
              color: service.isConnected ? Colors.green : Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DeviceScreen(),
          ControllerScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF0a0a12),
        selectedItemColor: const Color(0xFF7c5cfc),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Device',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Controller',
          ),
        ],
      ),
    );
  }
}
