import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nyarios/core/widgets/image_asset.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/l10n/app_localizations.dart';
import 'package:nyarios/ui/profile/profile_edit_provider.dart';
import 'package:nyarios/ui/profile/widgets/profile_info_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  String uploadIndicator = '0';
  bool upload = false;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileEditProviderProvider.notifier);

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.profile,
      ),
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
              stream: provider.loadStreamProfile(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: ImageProfile(
                        url: snapshot.data?.photo,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 32),
                    ProfileInfoWidget(
                      icon: 'assets/icons/ic_profile.png',
                      title: AppLocalizations.of(context)!.name,
                      data: snapshot.data?.name ?? "-",
                      onUpdateProfile: (value, isName) {
                        provider.updateProfile(value, isName);
                      },
                    ),
                    ProfileInfoWidget(
                      icon: 'assets/icons/ic_status.png',
                      title: 'Status',
                      data: snapshot.data?.status ?? "-",
                      onUpdateProfile: (value, isName) {
                        provider.updateProfile(value, isName);
                      },
                    ),
                    ProfileInfoWidget(
                      icon: 'assets/icons/ic_email.png',
                      title: 'E-Mail',
                      data: snapshot.data?.email ?? "-",
                      onUpdateProfile: (value, isName) {
                        provider.updateProfile(value, isName);
                      },
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

  void pickImage(bool fromGallery, Function(String) updateProfileImage) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      var storage = FirebaseStorage.instance.ref();
      var uploadImage = storage
          .child('nyarios/profile/.jpg')
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
                .child('nyarios/profile/.jpg')
                .getDownloadURL();
            updateProfileImage(url);
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
              color: Theme.of(context).iconTheme.color!,
            ),
          ),
        ],
      ),
    );
  }
}
