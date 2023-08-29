import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/empty_widget.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/ui/contact/contact_media_controller.dart';

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
  final Contact lastMessage = Get.arguments;

  late TabController tabController;
  late bool detailGroup;

  @override
  void initState() {
    detailGroup = lastMessage.group != null;
    tabController = TabController(length: detailGroup ? 3 : 2, vsync: this);
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
      appBar: Toolbar.defaultToolbar('', elevation: 0, actions: [
        if (detailGroup)
          PopupMenuButton(
            icon: ImageAsset(
              assets: 'assets/icons/ic_vert_more.png',
              color: Get.theme.iconTheme.color!,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('edit_group'.tr),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                Get.toNamed(AppRoutes.groupEdit, arguments: lastMessage.group!);
              }
            },
          ),
      ]),
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
                            detailGroup
                                ? lastMessage.group!.photo!
                                : lastMessage.profile!.photo!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detailGroup
                          ? lastMessage.group!.name!
                          : lastMessage.profile!.name!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _detailInfo(),
                    const SizedBox(height: 16),
                    if (!detailGroup)
                      StreamBuilder(
                        stream: ProfileRepository()
                            .getOnlineStatus(lastMessage.profileId),
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
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                online ? "Online" : "Offline",
                                style: const TextStyle(color: Colors.white),
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
                    if (detailGroup)
                      Container(
                        color: Get.theme.colorScheme.background,
                        width: double.infinity,
                        child: Tab(
                          icon: Text(
                            'members'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
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
          children: [
            if (detailGroup)
              GroupMembersTab(groupId: lastMessage.group!.groupId!),
            const ContactMediaTab(type: "image"),
            const ContactMediaTab(type: "file"),
          ],
        ),
      ),
    );
  }

  Widget _detailInfo() {
    if (detailGroup) {
      return GetBuilder<ContactMediaController>(
        builder: (controller) =>
            Text('${controller.profiles.length} ${'members'.tr}'),
      );
    } else {
      return FutureBuilder(
        future: ProfileRepository().loadUserStatus(lastMessage.profileId),
        builder: (context, snapshot) {
          return Text(snapshot.data ?? "");
        },
      );
    }
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

class GroupMembersTab extends StatefulWidget {
  final String groupId;

  const GroupMembersTab({super.key, required this.groupId});

  @override
  State<GroupMembersTab> createState() => _GroupMembersTabState();
}

class _GroupMembersTabState extends State<GroupMembersTab>
    with AutomaticKeepAliveClientMixin {
  final ContactMediaController controller = Get.find();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    controller.loadMembers(widget.groupId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ContactMediaController>(
      builder: (controller) {
        if (controller.loading) {
          return const Center(child: CustomIndicator());
        } else if (controller.empty) {
          return Center(child: EmptyWidget(message: 'empty_member'.tr));
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              var profile = controller.profiles[index];
              return Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            profile.photo ?? "",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            profile.name ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            itemCount: controller.profiles.length,
          );
        }
      },
    );
  }
}
