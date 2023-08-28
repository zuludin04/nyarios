import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/bottom_navigation.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/ui/home/home_controller.dart';
import 'package:nyarios/ui/home/nav/call_history_navigation.dart';
import 'package:nyarios/ui/home/nav/recent_chat_navigation.dart';
import 'package:nyarios/ui/home/nav/settings_navigation.dart';

import '../../routes/app_pages.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text(
              'Nyarios',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(
                  AppRoutes.search,
                  arguments: {'type': 'lastMessage', 'roomId': '', 'user': ''},
                ),
                icon: ImageAsset(
                  assets: 'assets/icons/ic_search.png',
                  color: Get.theme.iconTheme.color!,
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.contactFriend),
            child: const ImageAsset(assets: 'assets/icons/ic_new_message.png'),
          ),
          bottomNavigationBar: BottomNavigation(
            currentIndex: controller.selectedIndex,
            navMenus: [
              NavMenu(label: 'Chat', icon: 'ic_chat'),
              NavMenu(label: 'Call', icon: 'ic_call_history'),
              NavMenu(label: 'Settings', icon: 'ic_settings'),
            ],
            onSelectedMenu: controller.changeNavIndex,
          ),
          body: IndexedStack(
            index: controller.selectedIndex,
            children: const [
              RecentChatNavigation(),
              CallHistoryNavigation(),
              SettingsNavigation(),
            ],
          ),
        );
      },
    );
  }
}
