import 'package:flutter/material.dart';
import 'package:nyarios/ui/settings/settings_screen.dart';

import '../chat/chatting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
            SliverToBoxAdapter(
              child: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemBuilder: (context, index) => _storyItem(),
                  itemCount: 1,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _chatItem(context),
                childCount: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _storyItem() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            border: Border.all(color: Colors.blue, width: 2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Add Story')
      ],
    );
  }

  Widget _chatItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChattingScreen()),
        );
      },
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
                    children: const [
                      Text(
                        'Zulfikar Mauludin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hallo',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '22 Sep 2022',
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Icon(Icons.check, size: 16),
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
      color: const Color(0xfff7f7f7),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
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
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
