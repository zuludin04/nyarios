import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../data/nyarios_repository.dart';
import '../../routes/app_pages.dart';
import 'widgets/custom_sticky_bar.dart';
import 'widgets/last_message_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = NyariosRepository();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.contactFriend),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              delegate: CustomStickyBar(),
              pinned: true,
            ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       const SizedBox(height: 20),
            //       Container(
            //         height: 90,
            //         padding: const EdgeInsets.symmetric(horizontal: 12),
            //         child: ListView.builder(
            //           itemBuilder: (context, index) => _storyItem(),
            //           itemCount: 1,
            //           scrollDirection: Axis.horizontal,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            StreamBuilder(
              stream: repository.loadUsersLastMessages(),
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

                if (snapshot.data!.isEmpty) {
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
                    (context, index) =>
                        LastMessageItem(lastMessage: snapshot.data![index]),
                    childCount: snapshot.data!.length,
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
