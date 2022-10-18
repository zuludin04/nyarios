import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/profile.dart';
import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('Profile'),
      body: FutureBuilder<List<Profile>>(
        future: _loadProfileContact(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView.builder(
            itemBuilder: (context, index) =>
                _profileItem(snapshot.data![index]),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }

  Widget _profileItem(Profile profile) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.chatting, arguments: profile),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    profile.photo ?? "",
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<List<Profile>> _loadProfileContact() async {
    var contacts = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .get();

    if (contacts.size == 0) {
      var profiles = await FirebaseFirestore.instance
          .collection('profile')
          .where('id', isNotEqualTo: StorageServices.to.userId)
          .get();

      return profiles.docs.map((e) => Profile.fromMap(e.data())).toList();
    } else {
      var profiles = await FirebaseFirestore.instance
          .collection('profile')
          .where('id', isNotEqualTo: StorageServices.to.userId)
          .get();

      var list = profiles.docs.map((e) async {
        var profile = Profile.fromMap(e.data());
        var pro = await _contactReceiver(profile);
        return pro;
      }).toList();

      return Future.wait(list);
    }
  }

  Future<Profile> _contactReceiver(Profile profile) async {
    var contact = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .get();

    var roomId = contact.docs.where((element) {
      var uid = profile.uid ?? "";
      return element['receiverId'] == uid;
    }).toList();

    if (roomId.isNotEmpty) {
      profile.roomId = roomId[0]['roomId'];
    } else {
      profile.roomId = null;
    }

    return profile;
  }
}
