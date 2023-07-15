import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/nyarios_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
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
            onTap: _scan,
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

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(
          strings: {
            'cancel': 'Cancel',
            'flash_on': 'Flash on',
            'flash_off': 'Flash off',
          },
          useCamera: 0,
          autoEnableFlash: false,
          android: AndroidOptions(
            aspectTolerance: 0.00,
            useAutoFocus: true,
          ),
        ),
      );

      if (result.rawContent != '') {
        _showProfileDialog(result.rawContent);
      }
    } on PlatformException catch (e) {
      var message = e.code == BarcodeScanner.cameraAccessDenied
          ? 'The user did not grant the camera permission!'
          : 'Unknown error: $e';
      debugPrint(message);
    }
  }

  void _showProfileDialog(String barcode) {
    Get.dialog(
      AlertDialog(
        content: FutureBuilder<Profile>(
          future: NyariosRepository().loadSingleProfile(barcode),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      snapshot.data!.photo!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(snapshot.data?.name ?? ""),
                  Text(
                    snapshot.data?.status ?? "",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        var profile = snapshot.data!;
                        NyariosRepository().saveNewFriend(profile);
                        Get.toNamed(AppRoutes.chatting, arguments: profile);
                      },
                      child: const Text('Add'),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
