import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../routes/app_pages.dart';
import 'widgets/custom_sticky_bar.dart';
import 'widgets/last_message_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = ChatRepository();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.contactFriend),
        child: const ImageAsset(assets: 'assets/icons/ic_new_message.png'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(delegate: CustomStickyBar(), pinned: true),
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
                        const Icon(Icons.speaker_notes_off, size: 80),
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
      ),
    );
  }
}
