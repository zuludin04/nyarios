import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/toolbar.dart';
import '../../services/storage_services.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('profile'.tr),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  StorageServices.to.userImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _profileInfoWidget(
              Icons.person,
              'name'.tr,
              StorageServices.to.userName,
            ),
            _profileInfoWidget(
              Icons.info_outline,
              'Status',
              StorageServices.to.userStatus,
            ),
            _profileInfoWidget(
              Icons.email,
              'E-Mail',
              'zmauludin04@gmail.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoWidget(IconData icon, String title, String data) {
    return Padding(
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
    );
  }
}
