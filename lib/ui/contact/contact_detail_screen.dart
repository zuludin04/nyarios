import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

import '../../core/widgets/toolbar.dart';
import '../../services/storage_services.dart';
import 'contact_media_tab.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen>
    with SingleTickerProviderStateMixin {
  final LastMessage lastMessage = Get.arguments;

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('', elevation: 0),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                color: Get.theme.colorScheme.background,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: StorageServices.to.darkMode
                                  ? Colors.white24
                                  : Colors.black26,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            lastMessage.profile!.photo!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lastMessage.profile!.name!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder(
                      future: ProfileRepository()
                          .loadUserStatus(lastMessage.profile!.uid),
                      builder: (context, snapshot) {
                        return Text(snapshot.data ?? "");
                      },
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder(
                      stream: ProfileRepository()
                          .getOnlineStatus(lastMessage.profile!.uid),
                      builder: (context, snapshot) {
                        bool online =
                            snapshot.data?.data()?["visibility"] ?? false;
                        return Visibility(
                          visible: snapshot.connectionState ==
                                  ConnectionState.active &&
                              online,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              online ? "Online" : "Offline",
                              style: TextStyle(
                                color: StorageServices.to.darkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverPersistentHeaderDelegateImpl(
                tabBar: TabBar(
                  padding: const EdgeInsets.all(0),
                  labelPadding: const EdgeInsets.all(0),
                  labelColor: const Color(0xffb3404a),
                  indicatorColor: const Color(0xffb3404a),
                  unselectedLabelColor: const Color(0xffBDBDBD),
                  controller: tabController,
                  tabs: [
                    Container(
                      color: Get.theme.colorScheme.background,
                      width: double.infinity,
                      child: Tab(
                        icon: Text(
                          'media'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Container(
                      color: Get.theme.colorScheme.background,
                      width: double.infinity,
                      child: Tab(
                        icon: Text(
                          'docs'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            ContactMediaTab(type: "image"),
            ContactMediaTab(type: "file"),
          ],
        ),
      ),
    );
  }
}

class SliverPersistentHeaderDelegateImpl
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverPersistentHeaderDelegateImpl({
    required this.tabBar,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
