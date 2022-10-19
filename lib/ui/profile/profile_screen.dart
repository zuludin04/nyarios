import 'package:flutter/material.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/model/profile.dart';
import '../../data/nyarios_repository.dart';
import 'widgets/profile_item.dart';

class ProfileScreen extends StatelessWidget {
  final repository = NyariosRepository();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('Profile'),
      body: FutureBuilder<List<Profile>>(
        future: repository.loadAllProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
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
