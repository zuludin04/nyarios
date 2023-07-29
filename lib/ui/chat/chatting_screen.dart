import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../core/widgets/toolbar.dart';
import '../../data/model/chat.dart';
import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';
import 'widgets/chat_item.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final chatRepo = ChatRepository();
  final contactRepo = ContactRepository();
  final TextEditingController _messageEditingController =
      TextEditingController();

  LastMessage lastMassage = Get.arguments;

  List<Chat> selectedChat = [];
  bool selectionMode = false;
  String uploadIndicator = '0';
  bool upload = false;
  late bool alreadyAdded;
  late bool blocked;

  @override
  void initState() {
    alreadyAdded = true;
    blocked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        selectedChat.isEmpty
            ? lastMassage.profile?.name ?? ""
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
        uid: lastMassage.profile?.uid,
        onTapTitle: () => Get.toNamed(
          AppRoutes.contactDetail,
          arguments: lastMassage,
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
                      PopupMenuItem(
                        value: 2,
                        child: Text(blocked ? 'unblock'.tr : 'block'.tr),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Get.toNamed(
                          AppRoutes.contactDetail,
                          arguments: lastMassage,
                        );
                        break;
                      case 1:
                        Get.toNamed(
                          AppRoutes.search,
                          arguments: {
                            'type': 'chats',
                            'roomId': lastMassage.roomId,
                            'user': lastMassage.profile?.name,
                          },
                        );
                        break;
                      case 2:
                        setState(() {
                          blocked = !blocked;
                        });
                        contactRepo.changeBlockStatus(
                            lastMassage.profile?.uid, blocked);
                        break;
                    }
                  },
                )
              ]
            : _selectedChatActions(),
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
          Visibility(
            visible: !alreadyAdded,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!blocked)
                    _friendNotAddedAction(
                      () {
                        contactRepo.saveNewFriend(lastMassage.profile!,
                            lastMassage.roomId!, true);
                        setState(() {
                          alreadyAdded = !alreadyAdded;
                        });
                      },
                      Icons.add,
                      'Add Friend',
                    ),
                  _friendNotAddedAction(
                    () {
                      setState(() {
                        blocked = !blocked;
                      });
                      contactRepo.changeBlockStatus(
                          lastMassage.profile?.uid, blocked);
                    },
                    Icons.block_rounded,
                    blocked ? 'Unblock' : 'Block',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream:
                  chatRepo.loadUserChatsByRoomId(lastMassage.roomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('something_went_wrong'.tr));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomIndicator());
                }

                return _buildChatMessages(snapshot.data!.docs
                    .map((e) => Chat.fromMap(e.data(), e.id))
                    .toList());
              },
            ),
          ),
          blocked
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text(
                      'User is Blocked',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
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
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
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
                                cursorColor: const Color(0xffb3404a),
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
                                Get.bottomSheet(
                                  SizedBox(
                                    height: 100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _pickFileMenu(
                                            'File', Icons.attach_file),
                                        _pickFileMenu('Gallery', Icons.image),
                                      ],
                                    ),
                                  ),
                                  backgroundColor:
                                      Get.theme.colorScheme.background,
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
                          color: Color(0xffb3404a),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
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
            color: Color(0xffb3404a),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _messageDate(chat.sendDatetime),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
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

  Widget _friendNotAddedAction(Function() onTap, IconData icon, String title) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 5),
          Text(title),
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
          chatRepo
              .batchDelete(lastMassage.roomId!, selectedChat,
                  lastMassage.profile!)
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
        : lastMassage.profile?.name;
    return "[$date] $user: ${chat.message}\n";
  }

  void _sendMessage(
    String message,
    String type, {
    String url = "",
    String fileSize = "",
  }) async {
    Chat chat = Chat(
      message: message,
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      senderId: StorageServices.to.userId,
      type: type,
      url: url,
      fileSize: fileSize,
    );

    chatRepo.updateLastMessage(true, lastMassage.profile!.uid!, message);
    chatRepo.updateLastMessage(false, lastMassage.profile!.uid!, message);

    chatRepo.sendNewMessage(lastMassage.roomId, chat);
  }

  void _pickImage(bool fromGallery) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      var file = File(pickedFile.path);
      var storage = FirebaseStorage.instance.ref();
      var uploadImage = storage
          .child('nyarios/images/${pickedFile.name}')
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
                .child('nyarios/images/${pickedFile.name}')
                .getDownloadURL();
            var fileSize = await getFileSize(file);
            _sendMessage(pickedFile.name, 'image',
                url: url, fileSize: fileSize);
            setState(() {
              upload = false;
            });
            break;
        }
      });
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      var storage = FirebaseStorage.instance.ref();
      var uploadImage = storage
          .child('nyarios/files/${file.path.split("/").last}')
          .putFile(File(file.path));

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
                .child('nyarios/files/${file.path.split("/").last}')
                .getDownloadURL();
            var fileSize = await getFileSize(file);
            _sendMessage(result.files.single.name, 'file',
                url: url, fileSize: fileSize);
            setState(() {
              upload = false;
            });
            break;
        }
      });
    }
  }

  Future<String> getFileSize(File file) async {
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  void listenDocumentChange() {
    var lastMessage = FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .doc(lastMassage.profile!.uid)
        .snapshots();

    lastMessage.listen((event) {
      var message = event.data()!['message'];
      debugPrint('current message $message');
    });
  }
}
