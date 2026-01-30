import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/ui/home/recent_chat/recent_chat_provider.dart';
import 'package:nyarios/ui/home/recent_chat/recent_chat_item.dart';

class RecentChatScreen extends ConsumerWidget {
  const RecentChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(recentChatProviderProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          provider.when(
            data: (items) => SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var chat = items[index];
                return LastMessageItem(lastMessage: chat);
              }, childCount: items.length),
            ),
            error: (_, _) => SliverFillRemaining(
              child: Center(child: Text('something_went_wrong'.tr)),
            ),
            loading: () =>
                SliverFillRemaining(child: Center(child: CustomIndicator())),
          ),
        ],
      ),
    );
  }
}
