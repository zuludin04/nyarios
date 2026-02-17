import 'package:permission_handler/permission_handler.dart';

class PermissionItem {
  final String title;
  final String description;
  final Permission permission;

  PermissionItem({
    required this.title,
    required this.description,
    required this.permission,
  });
}
