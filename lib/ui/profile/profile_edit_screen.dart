import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/nyarios_repository.dart';
import '../../services/storage_services.dart';
import 'widgets/profile_info_widget.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('profile'.tr),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream:
              NyariosRepository().loadStreamProfile(StorageServices.to.userId),
          builder: (context, snapshot) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: snapshot.data?.photo == null
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        )
                      : ClipRRect(
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
                ProfileInfoWidget(
                  icon: Icons.person,
                  title: 'name'.tr,
                  data: snapshot.data?.name ?? "-",
                ),
                ProfileInfoWidget(
                  icon: Icons.info_outline,
                  title: 'Status',
                  data: snapshot.data?.status ?? "-",
                ),
                ProfileInfoWidget(
                  icon: Icons.email,
                  title: 'E-Mail',
                  data: snapshot.data?.email ?? "-",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
