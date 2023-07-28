import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
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
          settingsListBackground: Color(0xfff7f7f7),
        ),
        darkTheme: const SettingsThemeData(
          titleTextColor: Colors.white,
          settingsListBackground: Color(0xff252526),
        ),
        brightness: darkMode ? Brightness.dark : Brightness.light,
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                leading: const ProfileStreamWidget(type: 1),
                title: const ProfileStreamWidget(type: 2),
                description: const ProfileStreamWidget(type: 3),
                onPressed: (context) => Get.toNamed(AppRoutes.profileEdit),
              ),
              SettingsTile(
                title: const Text('My QR Code'),
                leading: const Icon(Icons.qr_code_2),
                onPressed: (context) => Get.toNamed(AppRoutes.qrCodeProfile),
              ),
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
            title: Text("privacy".tr),
            tiles: [
              SettingsTile(
                title: Text('block'.tr),
                leading: const Icon(Icons.app_blocking),
                onPressed: (context) => Get.toNamed(AppRoutes.contactBlock),
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
          ),
          SettingsSection(
            tiles: [
              SettingsTile(
                title: Text('logout'.tr),
                leading: const Icon(Icons.logout),
                onPressed: (context) async {
                  await signOut();
                  Get.offAllNamed(AppRoutes.signIn);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("error sign out");
    }
  }
}

class ProfileStreamWidget extends StatelessWidget {
  final int type;

  const ProfileStreamWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProfileRepository().loadStreamProfile(StorageServices.to.userId),
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
                    fit: BoxFit.cover,
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
