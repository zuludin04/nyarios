import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/image_asset.dart';

import 'profile_edit_bottom_sheet.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String data;

  const ProfileInfoWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title != 'E-Mail') {
          Get.bottomSheet(ProfileEditBottomSheet(
            initialValue: data,
            updateName: title == 'name'.tr,
          ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ImageAsset(
              assets: icon,
              color: Get.theme.iconTheme.color!,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title, style: Get.textTheme.bodySmall),
                  Text(data, style: Get.textTheme.titleMedium),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
