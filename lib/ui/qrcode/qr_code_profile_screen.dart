import 'package:another_flushbar/flushbar.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/data_chat.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/qrcode/qr_code_profile_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeProfileScreen extends ConsumerWidget {
  const QrCodeProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(qrCodeProfileControllerProvider);
    final controller = ref.watch(qrCodeProfileControllerProvider.notifier);

    ref.listen(qrCodeProfileControllerProvider, (prev, next) {
      if (next.value!.showProfileDialog) {
        _showProfileDialog(context, next.value!.profile!, () {
          controller.saveChatRoom(next.value!.profile!.uid!);
        });
      } else if (next.value!.successLoadContact) {
        context.pushNamed(
          AppPages.chatting,
          extra: DataChat(
            chatId: next.value!.contact!.chatId,
            profileId: next.value!.profile!.uid!,
            username: next.value!.profile!.name!,
            photo: next.value!.profile!.photo!,
          ),
        );
      }
    });

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.qr_code,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: asyncData.when(
                data: (data) => QrImageView(
                  data: data.userId,
                  version: QrVersions.auto,
                  size: 200,
                  padding: const EdgeInsets.all(16),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                error: (_, _) => SizedBox(),
                loading: () => SizedBox(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.scan_qr_message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _qrActions(
                context,
                AppLocalizations.of(context)!.copy_link,
                'assets/icons/ic_copy.png',
                () {
                  Clipboard.setData(const ClipboardData(text: ""));
                  Flushbar(
                    message: AppLocalizations.of(context)!.copy_clipboard,
                  ).show(context);
                },
              ),
              _qrActions(
                context,
                AppLocalizations.of(context)!.share,
                'assets/icons/ic_share.png',
                () {
                  SharePlus.instance.share(
                    ShareParams(
                      text: 'check out my website https://example.com',
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                _scan((profileId) => controller.loadProfile(profileId)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.4),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageAsset(
                    assets: 'assets/icons/ic_qr_scan.png',
                    color: Theme.of(context).iconTheme.color!,
                  ),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.scan_qr_code),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrActions(
    BuildContext context,
    String title,
    String icon,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ImageAsset(assets: icon, color: Theme.of(context).iconTheme.color!),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  Future<void> _scan(Function(String) onScanComplete) async {
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
        onScanComplete(result.rawContent);
      }
    } on PlatformException catch (e) {
      var message = e.code == BarcodeScanner.cameraAccessDenied
          ? 'The user did not grant the camera permission!'
          : 'Unknown error: $e';
      debugPrint(message);
    }
  }

  void _showProfileDialog(
    BuildContext context,
    Profile profile,
    Function() onSaveContact,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                profile.photo!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Text(profile.name ?? ""),
            Text(profile.status ?? "", style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  context.pop();
                  onSaveContact();
                },
                child: Text(AppLocalizations.of(context)!.add_friend),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
