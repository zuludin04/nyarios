import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/model/profile.dart';
import '../../data/nyarios_repository.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = NyariosRepository();

    return Scaffold(
      appBar: Toolbar.defaultToolbar('profile'.tr),
      body: FutureBuilder<List<Profile>>(
        future: repository.loadAllProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('something_went_wrong'.tr));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('loading'.tr));
          }

          return ListView.builder(
            itemBuilder: (context, index) =>
                ProfileItem(profile: snapshot.data![index]),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
