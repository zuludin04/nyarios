import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/home/settings/settings_provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
      brightness: Brightness.light,
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
              onPressed: (context) => context.pushNamed(AppPages.profileEdit),
            ),
            SettingsTile(
              title: Text('QR Code'),
              leading: ImageAsset(
                assets: 'assets/icons/ic_qr_code.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) => context.pushNamed(AppPages.qrCodeProfile),
            ),
          ],
        ),
        SettingsSection(
          title: Text("Common"),
          tiles: [
            SettingsTile.switchTile(
              activeSwitchColor: const Color(0xfffb7f6b),
              initialValue: false,
              onToggle: (value) {},
              title: Text("Dark Mode"),
              leading: ImageAsset(
                assets: 'assets/icons/ic_dark_mode.png',
                color: Theme.of(context).iconTheme.color!,
              ),
            ),
            SettingsTile(
              title: Text('Language'),
              leading: ImageAsset(
                assets: 'assets/icons/ic_language.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) => context.pushNamed(AppPages.language),
            ),
          ],
        ),
        SettingsSection(
          title: Text("Privacy"),
          tiles: [
            SettingsTile(
              title: Text('Blocked Friend'),
              leading: ImageAsset(
                assets: 'assets/icons/ic_empty_profile.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) => context.pushNamed(AppPages.contactBlock),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Other'),
          tiles: [
            SettingsTile(
              title: Text('Rating'),
              leading: ImageAsset(
                assets: 'assets/icons/ic_star.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) {},
            ),
            SettingsTile(
              title: Text('Share'),
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
              title: Text('Logout'),
              leading: ImageAsset(
                assets: 'assets/icons/ic_logout.png',
                color: Theme.of(context).iconTheme.color!,
              ),
              onPressed: (context) async {
                await signOut();
                if (context.mounted) {
                  context.go(AppPages.signIn);
                }
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
