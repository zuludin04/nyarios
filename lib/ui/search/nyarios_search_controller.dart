import 'package:get/get.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';

import '../../data/model/chat.dart';

class NyariosSearchController extends GetxController {
  final repository = MessageRepository();
  final contactRepo = ContactRepository();

  String type = Get.arguments['type'];
  String roomId = Get.arguments['roomId'];
  String user = Get.arguments['user'];

  String term = '';

  var filterLastMessage = <Chat>[].obs;
  var lastMessages = <Chat>[].obs;

  var filterChat = <Message>[].obs;
  var chats = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (type == 'lastMessage') {
      loadLastMessages();
    } else {
      loadChats();
    }
  }

  void searchLastMessage(String term) {
    if (term.isNotEmpty) {
      var filter = lastMessages
          .where((element) =>
              element.profile!.name!.toLowerCase().contains(term.toLowerCase()))
          .toList();
      filterLastMessage.value = filter;
    } else {
      filterLastMessage.value = lastMessages;
    }
  }

  void searchChat(String term) {
    this.term = term;

    if (term.isNotEmpty) {
      var filter = chats
          .where((element) =>
              element.message!.toLowerCase().contains(term.toLowerCase()))
          .toList();
      // filterChat.value = filter;
    } else {
      // filterChat.value = chats;
      this.term = '';
    }
  }

  void loadLastMessages() async {
    var lastMessages = <Chat>[];
    filterLastMessage.value = lastMessages;
    this.lastMessages.value = lastMessages;
  }

  void loadChats() async {
    var chats = await repository.loadChats(roomId);
    // filterChat.value = chats;
    // this.chats.value = chats;
  }
}
