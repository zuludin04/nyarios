import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
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
                  dataModuleShape: QrDataModuleShape.circle,
                  color: Get.theme.colorScheme.onPrimary,
                ),
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
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
              _qrActions('copy_link'.tr, 'assets/icons/ic_copy.png', () {
                Clipboard.setData(const ClipboardData(text: ""));
                Get.rawSnackbar(message: "copy_clipboard".tr);
              }),
              _qrActions('share'.tr, 'assets/icons/ic_share.png', () {
                SharePlus.instance.share(
                  ShareParams(text: 'check out my website https://example.com'),
                );
              }),
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
                  ImageAsset(
                    assets: 'assets/icons/ic_qr_scan.png',
                    color: Get.theme.iconTheme.color!,
                  ),
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

  Widget _qrActions(String title, String icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ImageAsset(assets: icon, color: Get.theme.iconTheme.color!),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
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
          android: AndroidOptions(aspectTolerance: 0.00, useAutoFocus: true),
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
                        var roomId = const Uuid().v4();
                        var contact = Contact(
                          profileId: profile.uid!,
                          alreadyFriend: true,
                          blocked: false,
                          chatId: roomId,
                        );
                        repo.saveContact(contact, profile.uid!);

                        Get.toNamed(
                          AppRoutes.chatting,
                          arguments: {'contact': contact, 'type': 'dm'},
                        );
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
