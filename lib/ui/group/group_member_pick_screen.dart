import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/ui/group/widgets/group_member_item.dart';

class GroupMemberPickScreen extends StatefulWidget {
  const GroupMemberPickScreen({super.key});

  @override
  State<GroupMemberPickScreen> createState() => _GroupMemberPickScreenState();
}

class _GroupMemberPickScreenState extends State<GroupMemberPickScreen> {
  var repository = ContactRepository();
  var selectedMembers = <Profile>[];

  String source = Get.arguments['source'] ?? "create";
  Group group = Get.arguments['group'] ?? Group();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('Pick Member', elevation: 0),
      floatingActionButton: Visibility(
        visible: selectedMembers.isNotEmpty,
        child: FloatingActionButton(
          onPressed: () {
            var groupRepo = GroupRepository();
            var chatRepo = ChatRepository();

            var chat = Chat(
              profileId: group.groupId,
              lastMessage: 'New group member is added',
              lastMessageSent: DateTime.now().millisecondsSinceEpoch,
              chatId: group.chatId,
              type: 'group',
            );

            var members = selectedMembers.map((e) => e.uid!).toList();
            members.addAll(group.members!);
            group.members = members;

            groupRepo.addGroupMember(group.groupId!, members).then((value) {
              chatRepo.updateGroupRecentChat(group, chat);
              Get.back();
            });
          },
          child: const Icon(Icons.check),
        ),
      ),
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

          return Column(
            children: [
              if (source == 'add')
                Visibility(
                  visible: selectedMembers.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GroupMemberItem(
                              profile: selectedMembers[index],
                              onRemoveMember: (profile) {
                                setState(() {
                                  selectedMembers.remove(profile);
                                });
                              },
                            ),
                          );
                        },
                        itemCount: selectedMembers.length,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) =>
                      _profileFriendItem(snapshot.data![index].profile),
                  itemCount: snapshot.data!.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profileFriendItem(Profile? profile) {
    return InkWell(
      onTap: () {
        if (source == 'create') {
          Get.back(result: profile);
        } else {
          setState(() {
            selectedMembers.add(profile!);
          });
        }
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
