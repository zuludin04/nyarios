import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/bottom_navigation.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/ui/home/call_history/call_history_screen.dart';
import 'package:nyarios/ui/home/recent_chat/recent_chat_screen.dart';
import 'package:nyarios/ui/home/settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedNav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: selectedNav != 2,
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.contactFriend),
          child: const ImageAsset(assets: 'assets/icons/ic_new_message.png'),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedNav,
        navMenus: [
          NavMenu(label: 'Chat', icon: 'ic_chat'),
          NavMenu(label: 'Call', icon: 'ic_call_history'),
          NavMenu(label: 'Settings', icon: 'ic_settings'),
        ],
        onSelectedMenu: (int index) {
          setState(() {
            selectedNav = index;
          });
        },
      ),
      body: IndexedStack(
        index: selectedNav,
        children: const [
          RecentChatScreen(),
          CallHistoryScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
