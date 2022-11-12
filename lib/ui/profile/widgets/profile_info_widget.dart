import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_edit_bottom_sheet.dart';

class ProfileInfoWidget extends StatelessWidget {
  final IconData icon;
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
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title, style: Get.textTheme.caption),
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
