import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../core/widgets/toolbar.dart';
import '../../services/storage_services.dart';
import 'widgets/profile_info_widget.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileRepository repository = ProfileRepository();
  String uploadIndicator = '0';
  bool upload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar('profile'.tr),
      body: Column(
        children: [
          Visibility(
            visible: upload,
            child: LinearPercentIndicator(
              percent: double.parse(uploadIndicator) / 100,
              progressColor: Colors.red,
              padding: const EdgeInsets.all(0),
              lineHeight: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder(
              stream: repository.loadStreamProfile(StorageServices.to.userId),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: ImageProfile(
                        url: snapshot.data?.photo,
                        onTap: () {
                          _pickImage(false);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    ProfileInfoWidget(
                      icon: Icons.person,
                      title: 'name'.tr,
                      data: snapshot.data?.name ?? "-",
                    ),
                    ProfileInfoWidget(
                      icon: Icons.info_outline,
                      title: 'Status',
                      data: snapshot.data?.status ?? "-",
                    ),
                    ProfileInfoWidget(
                      icon: Icons.email,
                      title: 'E-Mail',
                      data: snapshot.data?.email ?? "-",
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

  void _pickImage(bool fromGallery) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      var storage = FirebaseStorage.instance.ref();
      var uploadImage = storage
          .child('nyarios/profile/${StorageServices.to.userId}.jpg')
          .putFile(File(pickedFile.path));

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
                .child('nyarios/profile/${StorageServices.to.userId}.jpg')
                .getDownloadURL();
            repository.updateImageProfile(StorageServices.to.userId, url);
            StorageServices.to.userImage = url;
            setState(() {
              upload = false;
            });
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
