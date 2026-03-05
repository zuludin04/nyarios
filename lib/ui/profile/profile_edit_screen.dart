import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/ui/profile/profile_edit_controller.dart';
import 'package:nyarios/ui/profile/widgets/profile_info_widget.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileEditControllerProvider);

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.profile,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: provider.when(
              data: (data) => Column(
                children: [
                  const SizedBox(height: 16),
                  Center(child: ImageProfile(url: data.photo)),
                  const SizedBox(height: 32),
                  ProfileInfoWidget(
                    icon: 'assets/icons/ic_profile.png',
                    title: AppLocalizations.of(context)!.name,
                    data: data.name ?? "-",
                    onUpdateProfile: (value) {
                      ref
                          .read(profileEditControllerProvider.notifier)
                          .updateProfileName(value);
                    },
                  ),
                  ProfileInfoWidget(
                    icon: 'assets/icons/ic_status.png',
                    title: 'Status',
                    data: data.status ?? "-",
                    onUpdateProfile: (value) {
                      ref
                          .read(profileEditControllerProvider.notifier)
                          .updateProfileStatus(value);
                    },
                  ),
                  ProfileInfoWidget(
                    icon: 'assets/icons/ic_email.png',
                    title: 'E-Mail',
                    data: data.email ?? "-",
                    onUpdateProfile: (value) {},
                  ),
                ],
              ),
              error: (_, _) => SizedBox(),
              loading: () => SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageProfile extends StatelessWidget {
  final String? url;

  const ImageProfile({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: url == null || url == ""
          ? Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            )
          : Image.network(url!, width: 100, height: 100, fit: BoxFit.cover),
    );
  }
}
