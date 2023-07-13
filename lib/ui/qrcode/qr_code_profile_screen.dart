import 'package:flutter/material.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeProfileScreen extends StatelessWidget {
  const QrCodeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar("My QR Code"),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              child: QrImageView(
                data: StorageServices.to.userId,
                version: QrVersions.auto,
                size: 200,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Show or send this QR code to\nfriends to let them add you',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _qrActions('Copy Link', Icons.copy),
              _qrActions('Share', Icons.share_outlined),
              _qrActions('Save', Icons.download),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner),
                  SizedBox(width: 8),
                  Text('Scan QR Code'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrActions(String title, IconData icon) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }
}
