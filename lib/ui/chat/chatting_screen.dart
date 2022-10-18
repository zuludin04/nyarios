import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:uuid/uuid.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/chat.dart';
import '../../data/profile.dart';
import 'chat_item.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _messageEditingController =
      TextEditingController();

  Profile profile = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        "Zulfikar Mauludin",
        subtitle: "Online",
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('view_contact'.tr),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('room')
                  .doc(profile.roomId)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var chat = Chat.fromMap(snapshot.data!.docs[index].data());
                    return ChatItem(chat: chat);
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Get.theme.colorScheme.surface,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 1,
                        spreadRadius: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageEditingController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'message'.tr,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          cursorColor: const Color.fromRGBO(251, 127, 107, 1),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            builder: (context) => Container(
                              color: Colors.white,
                              height: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _pickFileMenu('File', Icons.attach_file),
                                  _pickFileMenu('Gallery', Icons.image),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: () {
                          _pickImage(false);
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (_messageEditingController.text.isNotEmpty) {
                    _sendMessage(_messageEditingController.text, 'text');
                    _messageEditingController.clear();
                  }
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(251, 127, 107, 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.send),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickFileMenu(String title, IconData icon) {
    return InkWell(
      onTap: () async {
        Get.back();
        if (title == 'Gallery') {
          _pickImage(true);
        } else {
          _pickFile();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(title.toLowerCase().tr),
        ],
      ),
    );
  }

  void _sendMessage(String message, String type) async {
    if (profile.roomId == null) {
      // create new room
      var roomId = const Uuid().v4();

      var collection = FirebaseFirestore.instance.collection('contacts');
      collection
          .doc(StorageServices.to.userId)
          .collection('receiver')
          .doc(profile.uid)
          .set({
        'message': message,
        'name': profile.name,
        'receiverId': profile.uid,
        'roomId': roomId,
        'photo': profile.photo,
        'send_datetime': '18 Oct 2022',
      });

      CollectionReference newMessage = FirebaseFirestore.instance
          .collection('room')
          .doc(roomId)
          .collection('messages');

      Chat chat = Chat(
          message: message,
          sendDatetime: '14 Oct 2022',
          senderId: StorageServices.to.userId,
          type: type);

      newMessage.add(chat.toMap());
    } else {
      var collection = FirebaseFirestore.instance.collection('contacts');
      collection
          .doc(StorageServices.to.userId)
          .collection('receiver')
          .doc(profile.uid)
          .update({'message': message});

      CollectionReference newMessage = FirebaseFirestore.instance
          .collection('room')
          .doc(profile.roomId)
          .collection('messages');

      Chat chat = Chat(
          message: message,
          sendDatetime: '14 Oct 2022',
          senderId: StorageServices.to.userId,
          type: type);

      newMessage.add(chat.toMap());
    }
  }

  void _pickImage(bool fromGallery) async {
    final file = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    var storage = FirebaseStorage.instance.ref();
    var uploadImage = storage.child(file!.path).putFile(File(file.path));

    uploadImage.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.running:
          final progress = 100.0 * (event.bytesTransferred / event.totalBytes);
          debugPrint("Upload is $progress% complete.");
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
          var url = await storage.child(file.path).getDownloadURL();
          _sendMessage(url, 'image');
          break;
      }
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    File file = File(result!.files.single.path!);
    var storage = FirebaseStorage.instance.ref();
    var uploadImage = storage.child(file.path).putFile(File(file.path));

    uploadImage.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.running:
          final progress = 100.0 * (event.bytesTransferred / event.totalBytes);
          debugPrint("Upload is $progress% complete.");
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
          // var url = await storage.child(file.path).getDownloadURL();
          _sendMessage(result.files.single.name, 'file');
          break;
      }
    });
  }
}
