import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              stream: FirebaseFirestore.instance
                  .collection('contacts')
                  .doc(StorageServices.to.userId)
                  .collection('receiver')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SliverToBoxAdapter(
                      child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(child: Text("Loading"));
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _chatItem(snapshot.data!.docs[index].data()),
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

  // Widget _storyItem() {
  //   return Column(
  //     children: [
  //       Container(
  //         width: 60,
  //         height: 60,
  //         margin: const EdgeInsets.symmetric(horizontal: 8),
  //         decoration: BoxDecoration(
  //           color: Colors.lightBlue.shade100,
  //           border: Border.all(color: Colors.blue, width: 2),
  //           shape: BoxShape.circle,
  //         ),
  //         child: const Icon(
  //           Icons.add,
  //           color: Colors.blue,
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Text('add_status'.tr)
  //     ],
  //   );
  // }

  Widget _chatItem(Map<String, dynamic> map) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.chatting),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      map['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        map['message'],
                        style: TextStyle(
                          color: StorageServices.to.darkMode
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      map['send_datetime'],
                      style: TextStyle(
                        color: StorageServices.to.darkMode
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    ),
                    // const SizedBox(height: 4),
                    // const Icon(Icons.check, size: 16),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class CustomStickyBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Nyarios',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              ActionMenuItem(icon: Icons.search, onTap: () {}),
              const SizedBox(width: 12),
              ActionMenuItem(
                icon: Icons.settings,
                onTap: () => Get.toNamed(AppRoutes.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class ActionMenuItem extends StatelessWidget {
  final IconData icon;
  final Function() onTap;

  const ActionMenuItem({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
