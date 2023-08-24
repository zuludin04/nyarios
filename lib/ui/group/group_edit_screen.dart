import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
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
      appBar: Toolbar.defaultToolbar('Group'.tr),
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
                        Get.bottomSheet(GroupEditBottomSheet(
                          initialValue: group.name!,
                          groupId: group.groupId!,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.group,
                              size: 28,
                              color: Get.theme.iconTheme.color,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Name', style: Get.textTheme.bodySmall),
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
            repository.updateImageGroup(group.groupId!, url);
            break;
        }
      });
    }
  }
}

class ImageProfile extends StatelessWidget {
  final String? url;
  final Function() onTap;

  const ImageProfile({super.key, required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: InkWell(
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
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        url!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          left: 100,
          right: 0,
          bottom: 0,
          child: Icon(Icons.edit, color: Get.theme.iconTheme.color),
        ),
      ],
    );
  }
}
