import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> request(Permission permission) async {
    return await permission.request();
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}