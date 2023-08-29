import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ChattingController extends GetxController {
  var contactRepo = ContactRepository();
  var chatRepo = ChatRepository();
  var messageRepo = MessageRepository();

  Contact contact = Get.arguments['contact'];
  String type = Get.arguments['type'];

  List<Message> selectedChat = [];
  bool isSelectionMode = false;

  bool blocked = false;
  bool alreadyAdded = true;
  bool upload = false;
  String uploadProgress = "0";

  @override
  void onInit() {
    loadFriendBlockStatus();
    super.onInit();
  }

  void loadFriendBlockStatus() async {
    var contact = await contactRepo.loadSingleContact(this.contact.profileId);
    blocked = contact?.blocked ?? false;
    alreadyAdded = contact?.alreadyFriend ?? false;
    update();
  }

  void addChatToContact() async {
    var contact = Contact(
      profileId: this.contact.profileId,
      chatId: this.contact.chatId,
      blocked: blocked,
      alreadyFriend: true,
    );
    await contactRepo.saveContact(contact, this.contact.profileId!);
    alreadyAdded = !alreadyAdded;
    update();
  }

  void changeBlockStatus() async {
    blocked = !blocked;
    await contactRepo.changeBlockStatus(contact.profileId, blocked);
    update();
  }

  void sendMessage(
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

  void uploadSendFile(String path, String fileName, String fileSize, File file,
      String type) async {
    var storage = FirebaseStorage.instance.ref();
    var uploadImage = storage.child('$path/$fileName').putFile(file);

    upload = true;
    update();

    uploadImage.snapshotEvents.listen((event) async {
      switch (event.state) {
        case TaskState.running:
          final progress = event.bytesTransferred / event.totalBytes;
          uploadProgress = (progress * 100).toStringAsFixed(0);
          update();
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
          var url = await storage.child('$path/$fileName').getDownloadURL();
          sendMessage(fileName, type, url: url, fileSize: fileSize);
          upload = false;
          update();
          break;
      }
    });
  }

  Future<void> leaveAndRemoveGroup() async {
    Chat chat = Chat(
      profileId: contact.group?.groupId,
      lastMessage: '${StorageServices.to.userName} left group',
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: contact.chatId,
      type: type,
    );
    chatRepo.updateGroupRecentChat(contact.group!, chat).then((value) async {
      _addGroupInfoMessage(contact.chatId!);
      contact.group!.members!.remove(StorageServices.to.userId);
      await GroupRepository()
          .updateGroupMember(contact.group!.groupId!, contact.group!.members!);
      await chatRepo.deleteGroupChat(contact.group!.groupId!);
      Get.back();
    });
  }

  Future<void> _addGroupInfoMessage(String chatId) async {
    var repo = MessageRepository();

    Message newMessage = Message(
      message: '${StorageServices.to.userName} left group',
      type: 'info',
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      url: '',
      fileSize: '',
      profileId: StorageServices.to.userId,
      chatId: chatId,
    );

    repo.sendNewMessage(newMessage);
  }

  void selectChat(Message message) {
    if (selectedChat.contains(message)) {
      selectedChat.remove(message);
      if (selectedChat.isEmpty) {
        isSelectionMode = false;
      }
    } else {
      selectedChat.add(message);
      isSelectionMode = true;
    }
    update();
  }

  void clearSelectedChat() {
    selectedChat.clear();
    isSelectionMode = false;
    update();
  }
}
