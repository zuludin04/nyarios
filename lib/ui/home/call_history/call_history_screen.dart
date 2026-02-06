import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/l10n/app_localizations.dart';
import 'package:nyarios/ui/home/call_history/call_history_provider.dart';
import 'package:nyarios/ui/home/call_history/call_history_item.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(callHistoryProviderProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          provider.when(
            data: (items) => SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var call = items[index];
                return CallHistoryItem(call: call);
              }, childCount: items.length),
            ),
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
