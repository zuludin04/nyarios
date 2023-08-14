import 'dart:io';
import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../core/widgets/custom_indicator.dart';
import '../../core/widgets/toolbar.dart';
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
  final messageRepo = MessageRepository();
  final TextEditingController _messageEditingController =
      TextEditingController();

  Contact contact = Get.arguments['contact'];
  String type = Get.arguments['type'];

  List<Message> selectedChat = [];
  bool selectionMode = false;
  String uploadIndicator = '0';
  bool upload = false;

  bool alreadyAdded = true;
  bool blocked = false;

  @override
  void initState() {
    loadFriendBlockStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        selectedChat.isEmpty
            ? type == 'dm'
                ? contact.profile?.name ?? ""
                : contact.group?.name ?? ""
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
        uid: contact.profileId,
        onTapTitle: () => Get.toNamed(
          AppRoutes.contactDetail,
          arguments: contact,
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
                      if (type != 'dm')
                        const PopupMenuItem(
                          value: 3,
                          child: Text('Add Member'),
                        ),
                      PopupMenuItem(
                        value: 1,
                        child: Text('search'.tr),
                      ),
                      if (type == 'dm')
                        PopupMenuItem(
                          value: 2,
                          child: Text(blocked ? 'unblock'.tr : 'block'.tr),
                        ),
                      if (type != 'dm')
                        const PopupMenuItem(
                          value: 4,
                          child: Text('Leave Group'),
                        ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Get.toNamed(
                          AppRoutes.contactDetail,
                          arguments: contact,
                        );
                        break;
                      case 1:
                        Get.toNamed(
                          AppRoutes.search,
                          arguments: {
                            'type': 'chats',
                            'roomId': contact.chatId,
                            'user': type == 'dm'
                                ? contact.profile?.name ?? ""
                                : contact.group?.name ?? "",
                          },
                        );
                        break;
                      case 2:
                        setState(() {
                          blocked = !blocked;
                        });
                        contactRepo.changeBlockStatus(
                            contact.profileId, blocked);
                        break;
                      case 3:
                        Get.toNamed(AppRoutes.groupMemberPick, arguments: {
                          'source': 'add',
                          'group': contact.group,
                        });
                        break;
                      case 4:
                        Chat chat = Chat(
                          profileId: contact.group?.groupId,
                          lastMessage:
                              '${StorageServices.to.userName} left group',
                          lastMessageSent:
                              DateTime.now().millisecondsSinceEpoch,
                          chatId: contact.chatId,
                          type: type,
                        );
                        chatRepo
                            .updateGroupRecentChat(contact.group!, chat)
                            .then((value) async {
                          contact.group!.members!
                              .remove(StorageServices.to.userId);
                          await GroupRepository().updateGroupMember(
                              contact.group!.groupId!, contact.group!.members!);
                          await chatRepo.deleteGroupChat(contact.group!.groupId!);
                          Get.back();
                        });
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
              color: Get.theme.colorScheme.background,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!blocked)
                    _friendNotAddedAction(
                      () {
                        var contact = Contact(
                          profileId: this.contact.profileId,
                          chatId: this.contact.chatId,
                          blocked: blocked,
                          alreadyFriend: true,
                        );
                        contactRepo.saveContact(
                            contact, this.contact.profileId!);
                        setState(() {
                          alreadyAdded = !alreadyAdded;
                        });
                      },
                      Icons.add,
                      'add_friend'.tr,
                    ),
                  _friendNotAddedAction(
                    () {
                      setState(() {
                        blocked = !blocked;
                      });
                      contactRepo.changeBlockStatus(contact.profileId, blocked);
                    },
                    Icons.block_rounded,
                    blocked ? 'unblock'.tr : 'block'.tr,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: messageRepo.loadChatMessages(contact.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('something_went_wrong'.tr));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomIndicator());
                }

                return _buildChatMessages(snapshot.data!.docs
                    .map((e) => Message.fromMap(e.data()))
                    .toList());
              },
            ),
          ),
          blocked
              ? Container(
                  color: Get.theme.colorScheme.background,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'user_blocked'.tr,
                      style: const TextStyle(
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

  Widget _buildChatMessages(List<Message> chats) {
    return GroupedListView<Message, DateTime>(
      physics: const BouncingScrollPhysics(),
      elements: chats,
      order: GroupedListOrder.DESC,
      reverse: true,
      floatingHeader: true,
      useStickyGroupSeparators: true,
      groupBy: (Message chat) {
        var date = DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!);
        return DateTime(date.year, date.month, date.day);
      },
      groupHeaderBuilder: _createGroupHeader,
      itemBuilder: (_, Message chat) => ChatItem(
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

  Widget _createGroupHeader(Message chat) {
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
          Icon(icon, size: 32),
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
          // chatRepo
          //     .batchDelete(
          //         contact.roomId!, selectedChat, contact.profile!)
          //     .then((value) {
          //   setState(() {
          //     selectedChat.clear();
          //     selectionMode = false;
          //   });
          // });
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

  String _copiedMessage(Message chat) {
    var date = DateFormat("MM/dd, hh:mm a")
        .format(DateTime.fromMillisecondsSinceEpoch(chat.sendDatetime!));
    var user = chat.chatId == StorageServices.to.userId
        ? StorageServices.to.userName
        : type == 'dm'
            ? contact.profile?.name ?? ""
            : contact.group?.name ?? "";
    return "[$date] $user: ${chat.message}\n";
  }

  void _sendMessage(
    String message,
    String type, {
    String url = "",
    String fileSize = "",
  }) async {
    Message newMessage = Message(
      message: message,
      type: type,
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      url: url,
      fileSize: fileSize,
      profileId: StorageServices.to.userId,
      chatId: contact.chatId!,
    );

    Chat chat = Chat(
      profileId: this.type == 'dm' ? contact.profileId : contact.group?.groupId,
      lastMessage: message,
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: contact.chatId,
      type: this.type,
    );

    if (this.type == 'dm') {
      chatRepo.updateRecentChat(true, chat);
      chatRepo.updateRecentChat(false, chat);
    } else {
      chatRepo.updateGroupRecentChat(contact.group!, chat);
    }

    messageRepo.sendNewMessage(newMessage);
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

  void loadFriendBlockStatus() async {
    var contact = await contactRepo.loadSingleContact(this.contact.profileId);
    setState(() {
      blocked = contact?.blocked ?? false;
      alreadyAdded = contact?.alreadyFriend ?? false;
    });
  }
}
