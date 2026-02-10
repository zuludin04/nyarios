import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/widgets/bottom_navigation.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/routes/app_routes.dart';
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
            onPressed: () => context.pushNamed(
              AppPages.search,
              queryParameters: {
                'type': 'lastMessage',
                'roomId': '',
                'username': '',
                'userId': ''
              },
            ),
            icon: ImageAsset(
              assets: 'assets/icons/ic_search.png',
              color: Theme.of(context).iconTheme.color!,
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: selectedNav != 2,
        child: FloatingActionButton(
          onPressed: () => context.pushNamed(AppPages.contactFriend),
          child: const ImageAsset(assets: 'assets/icons/ic_new_message.png'),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedNav,
        navMenus: [
          NavMenu(label: AppLocalizations.of(context)!.chat, icon: 'ic_chat'),
          NavMenu(
            label: AppLocalizations.of(context)!.call,
            icon: 'ic_call_history',
          ),
          NavMenu(
            label: AppLocalizations.of(context)!.settings,
            icon: 'ic_settings',
          ),
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
