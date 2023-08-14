import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

import '../../../data/model/chat.dart';
import '../../../routes/app_pages.dart';

class LastMessageItem extends StatelessWidget {
  final Chat lastMessage;

  const LastMessageItem({super.key, required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.chatting, arguments: {
          'contact': Contact.fromLastMessage(lastMessage),
          'type': lastMessage.type,
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                _imageRecentChat(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _nameRecentChat(),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage.lastMessage ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_lastMessageDate(lastMessage.lastMessageSent)),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _imageRecentChat() {
    return StreamBuilder(
      stream: lastMessage.type == 'dm'
          ? ProfileRepository().loadStreamProfile(lastMessage.profileId!)
          : GroupRepository().loadStreamGroup(lastMessage.profileId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          var imageUrl = '';
          if (lastMessage.type == 'dm') {
            var profile = snapshot.data as Profile;
            lastMessage.profile = profile;
            imageUrl = profile.photo!;
          } else {
            var group = snapshot.data as Group;
            lastMessage.group = group;
            imageUrl = group.photo!;
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  Widget _nameRecentChat() {
    return StreamBuilder(
      stream: lastMessage.type == 'dm'
          ? ProfileRepository().loadStreamProfile(lastMessage.profileId!)
          : GroupRepository().loadStreamGroup(lastMessage.profileId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          var name = '';
          if (lastMessage.type == 'dm') {
            var profile = snapshot.data as Profile;
            name = profile.name!;
          } else {
            var group = snapshot.data as Group;
            name = group.name!;
          }
          return Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          );
        }
      },
    );
  }

  String _lastMessageDate(int? datetime) {
    var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
    var today = DateTime.now();

    if (date.day == today.day) {
      return DateFormat("hh:mm a").format(date).toLowerCase();
    } else if ((today.day - date.day) == 1) {
      return "yesterday".tr;
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }
}
