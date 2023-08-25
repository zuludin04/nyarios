import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/image_asset.dart';

import '../../../routes/app_pages.dart';

class CustomStickyBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Nyarios',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
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
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: ImageAsset(
                  assets: 'assets/icons/ic_settings.png',
                  color: Get.theme.iconTheme.color!,
                ),
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
