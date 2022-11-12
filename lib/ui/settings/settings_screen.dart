import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/nyarios_repository.dart';
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
                leading: const ProfileStreamWidget(type: 1),
                title: const ProfileStreamWidget(type: 2),
                description: const ProfileStreamWidget(type: 3),
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

class ProfileStreamWidget extends StatelessWidget {
  final int type;

  const ProfileStreamWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NyariosRepository().loadStreamProfile(StorageServices.to.userId),
      builder: (context, snapshot) {
        if (type == 1) {
          return snapshot.data?.photo == null
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    snapshot.data!.photo!,
                    width: 50,
                    height: 50,
                  ),
                );
        } else {
          return Text(
            type == 2
                ? snapshot.data?.name ?? "-"
                : snapshot.data?.status ?? "-",
          );
        }
      },
    );
  }
}
