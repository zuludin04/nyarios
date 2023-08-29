import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/group/widgets/group_edit_bottom_sheet.dart';

class GroupEditScreen extends StatefulWidget {
  const GroupEditScreen({super.key});

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  final GroupRepository repository = GroupRepository();

  Group group = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('edit_group'.tr),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder(
              stream: repository.loadStreamGroup(group.groupId!),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: ImageProfile(
                        url: snapshot.data?.photo,
                        onTap: () {
                          _pickImage(false, group.name!);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(GroupEditBottomSheet(group: group));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            ImageAsset(
                              assets: 'assets/icons/ic_group_2.png',
                              color: Get.theme.iconTheme.color!,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('name'.tr,
                                      style: Get.textTheme.bodySmall),
                                  Text(
                                    snapshot.data?.name ?? "-",
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage(bool fromGallery, String imageName) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        var storage = FirebaseStorage.instance.ref();
        var uploadImage = storage
            .child('nyarios/group/${imageName.removeAllWhitespace}.jpg')
            .putFile(File(pickedFile.path));

        uploadImage.snapshotEvents.listen((event) async {
          switch (event.state) {
            case TaskState.running:
              debugPrint("Upload is running.");
              break;
            case TaskState.paused:
              debugPrint("Upload is paused.");
              break;
            case TaskState.canceled:
              debugPrint("Upload was canceled");
              break;
            case TaskState.error:
              debugPrint("Upload was error");
              break;
            case TaskState.success:
              var url = await storage
                  .child('nyarios/group/${imageName.removeAllWhitespace}.jpg')
                  .getDownloadURL();
              repository
                  .updateImageGroup(group.groupId!, url)
                  .then((value) async {
                await _updateGroupRecentMessage(group);
                await _addGroupInfoMessage(group.chatId!);
                Get.back();
              });
              break;
          }
        });
      }
    }
  }

  Future<void> _addGroupInfoMessage(String chatId) async {
    var repo = MessageRepository();

    Message newMessage = Message(
      message: '${StorageServices.to.userName} update group image',
      type: 'info',
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      url: '',
      fileSize: '',
      profileId: StorageServices.to.userId,
      chatId: chatId,
    );

    repo.sendNewMessage(newMessage);
  }

  Future<void> _updateGroupRecentMessage(Group group) async {
    var repo = ChatRepository();

    var chat = Chat(
      profileId: group.groupId,
      lastMessage: '${StorageServices.to.userName} update group image',
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: group.chatId,
      type: 'group',
    );

    await repo.updateGroupRecentChat(group, chat);
  }
}

class ImageProfile extends StatelessWidget {
  final String? url;
  final Function() onTap;

  const ImageProfile({super.key, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: url == null || url == "-"
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Image.network(
                      url!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: ImageAsset(
              assets: 'assets/icons/ic_edit.png',
              color: Get.theme.iconTheme.color!,
            ),
          ),
        ],
      ),
    );
  }
}
