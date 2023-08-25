import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/core/widgets/custom_indicator.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/ui/group/controllers/group_member_pick_controller.dart';
import 'package:nyarios/ui/group/widgets/group_member_item.dart';

class GroupMemberPickScreen extends StatefulWidget {
  const GroupMemberPickScreen({super.key});

  @override
  State<GroupMemberPickScreen> createState() => _GroupMemberPickScreenState();
}

class _GroupMemberPickScreenState extends State<GroupMemberPickScreen> {
  var controller = Get.find<GroupMemberPickController>();

  String source = Get.arguments['source'] ?? "create";
  Group group = Get.arguments['group'] ?? Group();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('pick_member'.tr, elevation: 0),
      floatingActionButton: Visibility(
        visible: controller.selectedMembers.isNotEmpty,
        child: FloatingActionButton(
          onPressed: () {
            controller.addGroupMembers(group);
          },
          child: const Icon(Icons.check),
        ),
      ),
      body: FutureBuilder<List<Contact>>(
        future: controller.contactRepo.loadContacts(false),
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
                GetBuilder<GroupMemberPickController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.selectedMembers.isNotEmpty,
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
                                  profile: controller.selectedMembers[index],
                                  onRemoveMember: (profile) {
                                    controller.addRemoveMember(true, profile);
                                  },
                                ),
                              );
                            },
                            itemCount: controller.selectedMembers.length,
                          ),
                        ),
                      ),
                    );
                  },
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
          controller.addRemoveMember(false, profile!);
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
