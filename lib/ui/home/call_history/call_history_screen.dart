import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/home/call_history/call_history_item.dart';
import 'package:nyarios/ui/home/call_history/call_history_provider.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(callHistoryProviderProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          provider.when(
            data: (items) {
              if (items.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    var call = items[index];
                    return CallHistoryItem(call: call);
                  }, childCount: items.length),
                );
              } else {
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ImageAsset(
                        assets: 'assets/icons/ic_empty_chat.png',
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.pushNamed(AppPages.contactFriend),
                        child: Text(
                          AppLocalizations.of(context)!.start_conversation,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            error: (_, _) => SliverFillRemaining(
              child: Center(
                child: Text(AppLocalizations.of(context)!.something_wrong),
              ),
            ),
            loading: () =>
                SliverFillRemaining(child: Center(child: CustomIndicator())),
          ),
        ],
      ),
    );
  }
}
