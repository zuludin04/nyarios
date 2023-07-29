import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/ui/contact/friend/friend_item.dart';

class ContactBlockScreen extends StatelessWidget {
  const ContactBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var repository = ContactRepository();

    return Scaffold(
      appBar: Toolbar.defaultToolbar('blocked_friend'.tr),
      body: FutureBuilder<List<LastMessage>>(
        future: repository.loadBlockedUser(),
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
                  Text('empty_blocked_friend'.tr),
                ],
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) =>
                FriendItem(lastMessage: snapshot.data![index]),
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
