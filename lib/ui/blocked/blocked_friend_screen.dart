import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/l10n/app_localizations.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/blocked/blocked_friend_controller.dart';

class BlockedFriendScreen extends ConsumerWidget {
  const BlockedFriendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(blockedFriendControllerProvider);

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.blocked_friend,
      ),
      body: controller.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ImageAsset(
                    assets: 'assets/icons/ic_profile_not_found.png',
                    size: 80,
                  ),
                  Text(AppLocalizations.of(context)!.empty_blocked_friend),
                ],
              ),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) =>
                  _BlockedFriendItem(profile: data[index]),
              itemCount: data.length,
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
        error: (_, _) =>
            Center(child: Text(AppLocalizations.of(context)!.something_wrong)),
        loading: () => const Center(child: CustomIndicator()),
      ),
    );
  }
}

class _BlockedFriendItem extends StatelessWidget {
  final Profile profile;

  const _BlockedFriendItem({required this.profile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppPages.chatting,
        queryParameters: {
          "chatId": profile.chatId,
          "profileId": profile.uid,
          "username": profile.name,
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(profile.photo ?? "", width: 40, height: 40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(profile.status ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
