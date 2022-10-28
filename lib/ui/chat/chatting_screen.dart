import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

import '../../core/widgets/toolbar.dart';
import '../../data/model/chat.dart';
import '../../data/model/profile.dart';
import '../../data/nyarios_repository.dart';
import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';
import 'widgets/chat_item.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final repository = NyariosRepository();
  final TextEditingController _messageEditingController =
      TextEditingController();

  Profile profile = Get.arguments;
  String? selectedRoomId;
  late int unreadMessage;

  List<Chat> selectedChat = [];
  bool selectionMode = false;

  @override
  void initState() {
    selectedRoomId = profile.roomId;
    unreadMessage = profile.unreadMessage ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        selectedChat.isEmpty
            ? profile.name ?? ""
            : "${selectedChat.length} ${"selected_chat".tr}",
        leading: selectedChat.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    selectedChat.clear();
                    selectionMode = false;
                  });
                },
                icon: const Icon(Icons.close),
              ),
        stream: true,
        uid: profile.uid,
        onTapTitle: () => Get.toNamed(
          AppRoutes.contactDetail,
          arguments: profile,
        ),
        elevation: 0,
        actions: !selectionMode
            ? [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text('view_contact'.tr),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('search'.tr),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      Get.toNamed(
                        AppRoutes.contactDetail,
                        arguments: profile,
                      );
                    } else if (value == 1) {
                      Get.toNamed(
                        AppRoutes.search,
                        arguments: {
                          'type': 'chats',
                          'roomId': selectedRoomId,
                          'user': profile.name,
                        },
                      );
                    }
                  },
                )
              ]
            : _selectedChatActions(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: repository.loadUserChatsByRoomId(selectedRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('something_went_wrong'.tr));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("loading".tr));
                }

                return _buildChatMessages(snapshot.data!.docs
                    .map((e) => Chat.fromMap(e.data(), e.id))
                    .toList());
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
                          focusNode: FocusNode(),
                          cursorColor: const Color.fromRGBO(251, 127, 107, 1),
                          textInputAction: TextInputAction.send,
                          onEditingComplete: () {},
                          onFieldSubmitted: (value) {
                            _sendMessage(value, 'text');
                            _messageEditingController.clear();
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                            expand: false,
                            context: context,
                            builder: (context) => SizedBox(
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

  Widget _buildChatMessages(List<Chat> chats) {
    return GroupedListView<Chat, DateTime>(
      physics: const BouncingScrollPhysics(),
      elements: chats,
      order: GroupedListOrder.DESC,
      reverse: true,
      floatingHeader: true,
      useStickyGroupSeparators: true,
      groupBy: (Chat chat) {
        var date = DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!);
        return DateTime(date.year, date.month, date.day);
      },
      groupHeaderBuilder: _createGroupHeader,
      itemBuilder: (_, Chat chat) => ChatItem(
        chat: chat,
        isSelected: selectedChat.contains(chat),
        onSelect: () {
          setState(() {
            if (selectedChat.contains(chat)) {
              selectedChat.remove(chat);
            } else {
              selectedChat.add(chat);
            }
            selectionMode = selectedChat.isNotEmpty;
          });
        },
        selectionMode: selectionMode,
        key: Key(chat.sendDatetime.toString()),
      ),
    );
  }

  Widget _createGroupHeader(Chat chat) {
    return SizedBox(
      height: 40,
      child: Align(
        child: Container(
          width: 120,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(251, 127, 107, 1),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _messageDate(chat.sendDatetime),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
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

  List<Widget> _selectedChatActions() {
    return [
      IconButton(
        onPressed: () {
          var messages =
              selectedChat.map((e) => _copiedMessage(e)).toList().join();
          FlutterClipboard.copy(messages).then((value) {
            Get.rawSnackbar(
                message: "${selectedChat.length} ${"messages_copied".tr}");
            setState(() {
              selectedChat.clear();
              selectionMode = false;
            });
          });
        },
        icon: const Icon(Icons.copy),
      ),
      IconButton(
        onPressed: () {
          repository
              .batchDelete(selectedRoomId!, selectedChat, profile)
              .then((value) {
            setState(() {
              selectedChat.clear();
              selectionMode = false;
            });
          });
        },
        icon: const Icon(Icons.delete),
      ),
    ];
  }

  String _messageDate(int? datetime) {
    var date = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
    var today = DateTime.now();

    if (date.day == today.day) {
      return "today".tr;
    } else if ((today.day - date.day) == 1) {
      return "yesterday".tr;
    } else {
      return DateFormat("dd MMM yyyy").format(date);
    }
  }

  String _copiedMessage(Chat chat) {
    var date = DateFormat("MM/dd, hh:mm a")
        .format(DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!));
    var user = chat.senderId == StorageServices.to.userId
        ? StorageServices.to.userName
        : profile.name;
    return "[$date] $user: ${chat.message}\n";
  }

  void _sendMessage(String message, String type, {String url = ""}) async {
    if (selectedRoomId == null) {
      // create new room
      var roomId = const Uuid().v4();
      var unread = unreadMessage += 1;

      repository.updateRecentContact(true, false, profile, message, roomId, 0);
      repository.updateRecentContact(
          false, false, profile, message, roomId, unread);

      repository.sendNewMessage(roomId, message, type, url);

      selectedRoomId = roomId;
      setState(() {});
    } else {
      var unread = unreadMessage += 1;

      repository.updateRecentContact(true, true, profile, message, '', 0);
      repository.updateRecentContact(false, true, profile, message, '', unread);

      repository.sendNewMessage(selectedRoomId, message, type, url);
    }
  }

  void _pickImage(bool fromGallery) async {
    final file = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    var storage = FirebaseStorage.instance.ref();
    var uploadImage =
        storage.child('nyarios/images/${file!.name}').putFile(File(file.path));

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
          var url = await storage
              .child('nyarios/images/${file.name}')
              .getDownloadURL();
          _sendMessage(file.name, 'image', url: url);
          break;
      }
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    File file = File(result!.files.single.path!);
    var storage = FirebaseStorage.instance.ref();
    var uploadImage = storage
        .child('nyarios/files/${file.path.split("/").last}')
        .putFile(File(file.path));

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
          var url = await storage
              .child('nyarios/files/${file.path.split("/").last}')
              .getDownloadURL();
          _sendMessage(result.files.single.name, 'file', url: url);
          break;
      }
    });
  }

  void listenDocumentChange() {
    var contact = FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .doc(profile.uid)
        .snapshots();

    contact.listen((event) {
      var message = event.data()!['message'];
      debugPrint('current message $message');
    });
  }
}
