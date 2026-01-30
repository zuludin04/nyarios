import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/home/settings/settings_provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool darkMode = StorageServices.to.darkMode;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(settingsProviderProvider);

    return SettingsList(
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
              leading: provider.when(
                data: (profile) => profile.photo == null
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
                          profile.photo!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                error: (_, _) => SizedBox(),
                loading: () => SizedBox(),
              ),
              title: provider.when(
                data: (profile) => Text(profile.name ?? "-"),
                error: (_, _) => SizedBox(),
                loading: () => SizedBox(),
              ),
              description: provider.when(
                data: (profile) => Text(profile.status ?? "-"),
                error: (_, _) => SizedBox(),
                loading: () => SizedBox(),
              ),
              onPressed: (context) => Get.toNamed(AppRoutes.profileEdit),
            ),
            SettingsTile(
              title: Text('qr_code'.tr),
              leading: ImageAsset(
                assets: 'assets/icons/ic_qr_code.png',
                color: Theme.of(context).iconTheme.color!,
              ),
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
              leading: ImageAsset(
                assets: 'assets/icons/ic_dark_mode.png',
                color: Theme.of(context).iconTheme.color!,
              ),
            ),
            SettingsTile(
              title: Text('language'.tr),
              leading: ImageAsset(
                assets: 'assets/icons/ic_language.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) => Get.toNamed(AppRoutes.language),
            ),
          ],
        ),
        SettingsSection(
          title: Text("privacy".tr),
          tiles: [
            SettingsTile(
              title: Text('blocked_friend'.tr),
              leading: ImageAsset(
                assets: 'assets/icons/ic_empty_profile.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) => Get.toNamed(AppRoutes.contactBlock),
            ),
          ],
        ),
        SettingsSection(
          title: Text('other'.tr),
          tiles: [
            SettingsTile(
              title: Text('rating'.tr),
              leading: ImageAsset(
                assets: 'assets/icons/ic_star.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) {},
            ),
            SettingsTile(
              title: Text('share'.tr),
              leading: ImageAsset(
                assets: 'assets/icons/ic_share.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) {},
            ),
          ],
        ),
        SettingsSection(
          tiles: [
            SettingsTile(
              title: Text('logout'.tr),
              leading: ImageAsset(
                assets: 'assets/icons/ic_logout.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) async {
                await signOut();
                Get.offAllNamed(AppRoutes.signIn);
              },
            ),
          ],
        ),
      ],
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
