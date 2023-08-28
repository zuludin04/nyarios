import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/ui/home/widgets/last_message_item.dart';

class RecentChatNavigation extends StatelessWidget {
  const RecentChatNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = ChatRepository();

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          StreamBuilder(
            stream: repository.loadRecentChat(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('something_went_wrong'.tr)),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CustomIndicator()),
                );
              }

              if (snapshot.data!.size == 0) {
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
                        onPressed: () => Get.toNamed(AppRoutes.contactFriend),
                        child: Text('start_conversation'.tr),
                      ),
                    ],
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var data = snapshot.data!.docs[index];
                    var chat = Chat.fromMap(data.data());
                    return LastMessageItem(lastMessage: chat);
                  },
                  childCount: snapshot.data!.size,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
