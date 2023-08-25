import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/group/widgets/group_member_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class GroupCreateScreen extends StatefulWidget {
  const GroupCreateScreen({super.key});

  @override
  State<GroupCreateScreen> createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {
  final _groupRepo = GroupRepository();
  final _groupTitleController = TextEditingController();
  File? _imageFile;
  List<Profile> members = [
    Profile(
      name: StorageServices.to.userName,
      photo: StorageServices.to.userImage,
      uid: StorageServices.to.userId,
    ),
  ];

  bool upload = false;
  String uploadIndicator = '0';

  @override
  void dispose() {
    _groupTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('create_group'.tr, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(false),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _imageFile == null
                        ? Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/group.png'),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              _imageFile!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _groupTitleController,
                    decoration: InputDecoration(hintText: 'group_name'.tr),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'member'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () async {
                        var result = await Get.toNamed(
                            AppRoutes.groupMemberPick,
                            arguments: {'source': 'create'});
                        if (result != null) {
                          if (result is Profile) {
                            members.add(result);
                            setState(() {});
                          }
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black38),
                            ),
                            child: const Icon(Icons.add),
                          ),
                          const SizedBox(height: 4),
                          Text('add_member'.tr, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  } else {
                    return GroupMemberItem(
                      profile: members[index - 1],
                      onRemoveMember: (profile) {
                        members.remove(profile);
                        setState(() {});
                      },
                    );
                  }
                },
                itemCount: members.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var chatId = const Uuid().v4();
          var group = Group(
            name: _groupTitleController.text,
            members: members.map((e) => e.uid!).toList(),
            chatId: chatId,
            adminId: StorageServices.to.userId,
          );

          if (_imageFile != null) {
            _createGroup(group, _imageFile!);
          } else {
            var file = await getImageFileFromAssets();
            _createGroup(group, file);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void _createGroup(Group group, File file) {
    var storage = FirebaseStorage.instance.ref();
    var uploadImage = storage
        .child(
            'nyarios/group/${_groupTitleController.text.removeAllWhitespace}.jpg')
        .putFile(file);

    setState(() {
      upload = true;
    });

    uploadImage.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.running:
          final progress = event.bytesTransferred / event.totalBytes;
          setState(() {
            uploadIndicator = (progress * 100).toStringAsFixed(0);
          });
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
              .child(
                  'nyarios/group/${_groupTitleController.text.removeAllWhitespace}.jpg')
              .getDownloadURL();
          group.photo = url;
          _groupRepo.createGroupChat(group).then((value) async {
            await _updateGroupRecentMessage(group);
            Get.back();
          });
          break;
      }
    });
  }

  Future<void> _updateGroupRecentMessage(Group group) async {
    var repo = ChatRepository();

    var chat = Chat(
      profileId: group.groupId,
      lastMessage:
          '${StorageServices.to.userName} created group "${group.name}"',
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: group.chatId,
      type: 'group',
    );

    await repo.updateGroupRecentChat(group, chat);
  }

  void _pickImage(bool fromGallery) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<File> getImageFileFromAssets() async {
    final byteData = await rootBundle.load('assets/group.png');

    final file = File('${(await getTemporaryDirectory()).path}/group.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
