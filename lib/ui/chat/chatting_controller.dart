import 'package:get/get.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ChattingController extends GetxController {
  var contactRepo = ContactRepository();
  var chatRepo = ChatRepository();
  var messageRepo = MessageRepository();

  Contact contact = Get.arguments['contact'];
  String type = Get.arguments['type'];

  bool blocked = false;
  bool alreadyAdded = true;

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
}
