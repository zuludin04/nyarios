import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/toolbar.dart';
import '../../services/storage_services.dart';
import '../language/language_setting_screen.dart';

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
      appBar: Toolbar.defaultToolbar(context, "settings".tr),
      body: SettingsList(
        physics: const BouncingScrollPhysics(),
        lightTheme: const SettingsThemeData(
          titleTextColor: Color.fromRGBO(251, 127, 107, 1),
        ),
        sections: [
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
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LanguageSettingScreen()),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('other'.tr),
            tiles: [
              SettingsTile(
                title: Text('rating'.tr),
                leading: const Icon(Icons.star),
                onPressed: (context) {
                  try {
                    launchUrl(Uri.parse(""));
                  } on PlatformException catch (_) {
                    launchUrl(Uri.parse(""));
                  } finally {
                    launchUrl(Uri.parse(""));
                  }
                },
              ),
              SettingsTile(
                title: Text('share'.tr),
                leading: const Icon(Icons.share),
                onPressed: (context) {
                  Share.share("");
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
