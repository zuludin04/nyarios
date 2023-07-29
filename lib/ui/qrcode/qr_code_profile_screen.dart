import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class QrCodeProfileScreen extends StatelessWidget {
  const QrCodeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar("qr_code".tr),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Get.theme.colorScheme.onPrimary),
              ),
              child: QrImageView(
                data: StorageServices.to.userId,
                version: QrVersions.auto,
                size: 200,
                padding: const EdgeInsets.all(16),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Get.theme.colorScheme.onPrimary,
                ),
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('scan_qr_message'.tr, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _qrActions('copy_link'.tr, Icons.copy),
              _qrActions('share'.tr, Icons.share_outlined),
              _qrActions('save'.tr, Icons.download),
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
                border: Border.all(
                  color: Get.theme.colorScheme.onPrimary.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner),
                  const SizedBox(width: 8),
                  Text('scan_qr_code'.tr),
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
          future: ProfileRepository().loadSingleProfile(barcode),
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
                      onPressed: () async {
                        Get.back();
                        var repo = ContactRepository();
                        var profile = snapshot.data!;
                        var friend = await repo.loadSingleFriend(profile.uid);
                        if (friend == null) {
                          var roomId = const Uuid().v4();
                          repo.saveNewFriend(profile, roomId, true);
                          repo.saveNewFriend(profile, roomId, false);
                          var lastMessage =
                              LastMessage(profile: profile, roomId: roomId);
                          Get.toNamed(AppRoutes.chatting,
                              arguments: lastMessage);
                        } else {
                          var lastMessage = LastMessage(
                              profile: profile, roomId: friend.roomId);
                          Get.toNamed(AppRoutes.chatting,
                              arguments: lastMessage);
                        }
                      },
                      child: Text('add_friend'.tr),
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
