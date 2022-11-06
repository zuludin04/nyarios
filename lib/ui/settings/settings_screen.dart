import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../core/widgets/toolbar.dart';
import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = StorageServices.to.darkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar("settings".tr),
      body: SettingsList(
        physics: const BouncingScrollPhysics(),
        lightTheme: const SettingsThemeData(
          titleTextColor: Color.fromRGBO(251, 127, 107, 1),
        ),
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    StorageServices.to.userImage,
                    width: 50,
                    height: 50,
                  ),
                ),
                title: Text(StorageServices.to.userName),
                description: Text(StorageServices.to.userStatus),
                onPressed: (context) => Get.toNamed(AppRoutes.profileEdit),
              )
            ],
          ),
          SettingsSection(
            title: Text("common".tr),
            tiles: [
              SettingsTile.switchTile(
                activeSwitchColor: const Color(0xfffb7f6b),
                initialValue: darkMode,
                onToggle: (value) {
                  Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  StorageServices.to.darkMode = value;
                  setState(() {
                    darkMode = value;
                  });
                },
                title: Text("dark_mode".tr),
                leading: const Icon(Icons.dark_mode),
              ),
              SettingsTile(
                title: Text('language'.tr),
                leading: const Icon(Icons.language),
                onPressed: (context) => Get.toNamed(AppRoutes.language),
              ),
            ],
          ),
          SettingsSection(
            title: Text('other'.tr),
            tiles: [
              SettingsTile(
                title: Text('rating'.tr),
                leading: const Icon(Icons.star),
                onPressed: (context) {},
              ),
              SettingsTile(
                title: Text('share'.tr),
                leading: const Icon(Icons.share),
                onPressed: (context) {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
