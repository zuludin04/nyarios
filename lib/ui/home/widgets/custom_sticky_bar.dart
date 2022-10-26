import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import 'action_menu_item.dart';

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
              ActionMenuItem(
                icon: Icons.search,
                onTap: () => Get.toNamed(
                  AppRoutes.search,
                  arguments: {'type': 'contacts', 'roomId': '', 'user': ''},
                ),
              ),
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
