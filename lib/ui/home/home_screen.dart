import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/contact.dart';
import '../../data/nyarios_repository.dart';
import '../../routes/app_pages.dart';
import 'widgets/chat_contact_item.dart';
import 'widgets/custom_sticky_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = NyariosRepository();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.profile),
        child: const Icon(Icons.edit),
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
              stream: repository.loadUserContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('something_went_wrong'.tr)),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('loading'.tr)),
                  );
                }

                if (snapshot.data!.size == 0) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('empty_message'.tr)),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ChatContactItem(
                      contact: Contact.fromMap(
                        snapshot.data!.docs[index].data(),
                      ),
                    ),
                    childCount: snapshot.data!.docs.length,
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
