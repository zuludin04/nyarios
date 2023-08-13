import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';

class GroupMemberPickScreen extends StatelessWidget {
  const GroupMemberPickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = ContactRepository();

    return Scaffold(
      appBar: Toolbar.defaultToolbar('Pick Member', elevation: 0),
      body: FutureBuilder<List<Contact>>(
        future: repository.loadContacts(false),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('something_went_wrong'.tr));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 80),
                  Text('no_friend'.tr),
                ],
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) =>
                _profileFriendItem(snapshot.data![index].profile),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }

  Widget _profileFriendItem(Profile? profile) {
    return InkWell(
      onTap: () {
        Get.back(result: profile);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    profile?.photo ?? "",
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    profile?.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
