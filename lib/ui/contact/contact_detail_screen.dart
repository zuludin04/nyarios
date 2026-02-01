import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/contact/contact_detail_provider.dart';
import 'package:nyarios/ui/contact/contact_media_tab.dart';

class ContactDetailScreen extends ConsumerStatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  ConsumerState<ContactDetailScreen> createState() =>
      _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen>
    with SingleTickerProviderStateMixin {
  final Contact lastMessage = Get.arguments;

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
    final chatAsync = ref.watch(
      contactDetailProviderProvider(
        lastMessage.chatId!,
        lastMessage.profileId!,
      ),
    );

    return Scaffold(
      appBar: Toolbar.defaultToolbar('', elevation: 0),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                color: Get.theme.colorScheme.surface,
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
                    Text(chatAsync.value?.userStatus ?? "-"),
                    const SizedBox(height: 16),
                    chatAsync.when(
                      data: (data) => Visibility(
                        visible: data.isOnline,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Online",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      error: (_, _) => SizedBox(),
                      loading: () => SizedBox(),
                    ),
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
                      color: Get.theme.colorScheme.surface,
                      width: double.infinity,
                      child: Tab(
                        icon: Text(
                          'media'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Container(
                      color: Get.theme.colorScheme.surface,
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
          children: [
            chatAsync.when(
              data: (data) {
                return ContactMediaTab(messages: data.mediaMessages);
              },
              error: (_, _) => Text("There is Something Wrong"),
              loading: () => CircularProgressIndicator(),
            ),
            chatAsync.when(
              data: (data) => ContactMediaTab(messages: data.docMessages),
              error: (_, _) => Text("There is Something Wrong"),
              loading: () => CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverPersistentHeaderDelegateImpl
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverPersistentHeaderDelegateImpl({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
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
