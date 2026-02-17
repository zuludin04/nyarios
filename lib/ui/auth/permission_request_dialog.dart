import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/services/permission_service.dart';
import 'package:nyarios/domain/model/permission_item.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestDialog extends StatefulWidget {
  final Function() onPermissionAccepted;

  const PermissionRequestDialog({
    super.key,
    required this.onPermissionAccepted,
  });

  @override
  State<PermissionRequestDialog> createState() =>
      _PermissionRequestDialogState();
}

class _PermissionRequestDialogState extends State<PermissionRequestDialog> {
  int currentIndex = 0;

  final _service = PermissionService();
  final List<PermissionItem> permissions = [
    PermissionItem(
      title: "Camera Access",
      description:
          "Allow access to your camera so you can take profile photos and share moments.",
      permission: Permission.camera,
    ),
    PermissionItem(
      title: "Microphone Access",
      description:
          "Allow microphone access for voice messages and video calls.",
      permission: Permission.microphone,
    ),
    PermissionItem(
      title: "Notifications",
      description: "Enable notifications so you never miss messages and calls.",
      permission: Permission.notification,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final item = permissions[currentIndex];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Icon(_getIcon(item.permission), size: 100),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () async {
              await _handlePermission(item.permission);

              if (currentIndex < permissions.length - 1) {
                setState(() {
                  currentIndex++;
                });
              } else {
                if (context.mounted) {
                  widget.onPermissionAccepted();
                  context.pop();
                }
              }
            },
            child: Text(
              currentIndex == permissions.length - 1 ? "Finish" : "Continue",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              if (currentIndex < permissions.length - 1) {
                setState(() {
                  currentIndex++;
                });
              } else {
                if (context.mounted) context.pop();
              }
            },
            child: const Text("Skip"),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePermission(Permission permission) async {
    final status = await _service.request(permission);

    if (status.isPermanentlyDenied && mounted) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "Please enable permission from settings to continue.",
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _service.openSettings();
                if (mounted) context.pop();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
    }
  }

  IconData _getIcon(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return Icons.camera_alt;
      case Permission.microphone:
        return Icons.mic;
      case Permission.notification:
        return Icons.notifications;
      default:
        return Icons.security;
    }
  }
}
