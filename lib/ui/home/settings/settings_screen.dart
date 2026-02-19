import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
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

    return provider.when(
      data: (data) => SettingsList(
        physics: const BouncingScrollPhysics(),
        lightTheme: SettingsThemeData(
          titleTextColor: Theme.of(context).textTheme.titleSmall!.color!,
          settingsListBackground: Theme.of(context).colorScheme.surface,
        ),
        darkTheme: SettingsThemeData(
          titleTextColor: Theme.of(context).textTheme.titleSmall!.color!,
          settingsListBackground: Theme.of(context).colorScheme.surface,
        ),
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                leading: data.profile?.photo == null
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
                          data.profile!.photo!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                title: Text(data.profile?.name ?? "-"),
                description: Text(data.profile?.status ?? "-"),
                onPressed: (context) => context.pushNamed(AppPages.profileEdit),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.qr_code),
                leading: ImageAsset(
                  assets: 'assets/icons/ic_qr_code.png',
                  color: Theme.of(context).iconTheme.color!,
                ),
                onPressed: (context) =>
                    context.pushNamed(AppPages.qrCodeProfile),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.common),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.theme),
                leading: ImageAsset(
                  assets: 'assets/icons/ic_dark_mode.png',
                  color: Theme.of(context).iconTheme.color!,
                ),
                onPressed: (context) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _ThemeSelectorSheet(
                      mode: data.themeMode,
                      onSelectTheme: (mode) {
                        ref
                            .read(settingsProviderProvider.notifier)
                            .changeTheme(mode);
                      },
                    ),
                  );
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.language),
                leading: ImageAsset(
                  assets: 'assets/icons/ic_language.png',
                  color: Theme.of(context).iconTheme.color!,
                ),
                onPressed: (context) => context.pushNamed(AppPages.language),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.privacy),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.blocked_friend),
                leading: ImageAsset(
                  assets: 'assets/icons/ic_empty_profile.png',
                  color: Theme.of(context).iconTheme.color!,
                ),
                onPressed: (context) =>
                    context.pushNamed(AppPages.contactBlock),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.other),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.rating),
                leading: ImageAsset(
                  assets: 'assets/icons/ic_star.png',
                  color: Theme.of(context).iconTheme.color!,
                ),
                onPressed: (context) {},
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.share),
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
                title: Text(AppLocalizations.of(context)!.logout),
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
      ),
      error: (_, _) => SizedBox(),
      loading: () => SizedBox(),
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

class _ThemeSelectorSheet extends ConsumerWidget {
  final ThemeMode mode;
  final Function(ThemeMode) onSelectTheme;

  const _ThemeSelectorSheet({required this.mode, required this.onSelectTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(settingsProviderProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.system),
          leading: Icon(
            Icons.check,
            color: provider.value!.themeMode == ThemeMode.system
                ? Theme.of(context).iconTheme.color
                : Colors.transparent,
          ),
          onTap: () => onSelectTheme(ThemeMode.system),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.dark),
          leading: Icon(
            Icons.check,
            color: provider.value!.themeMode == ThemeMode.dark
                ? Theme.of(context).iconTheme.color
                : Colors.transparent,
          ),
          onTap: () => onSelectTheme(ThemeMode.dark),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.light),
          leading: Icon(
            Icons.check,
            color: provider.value!.themeMode == ThemeMode.light
                ? Theme.of(context).iconTheme.color
                : Colors.transparent,
          ),
          onTap: () => onSelectTheme(ThemeMode.light),
        ),
      ],
    );
  }
}
