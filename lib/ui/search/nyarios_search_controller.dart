import 'package:get/get.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';

import '../../data/model/chat.dart';
import '../../data/model/last_message.dart';

class NyariosSearchController extends GetxController {
  final repository = ChatRepository();
  final contactRepo = ContactRepository();

  String type = Get.arguments['type'];
  String roomId = Get.arguments['roomId'];
  String user = Get.arguments['user'];

  String term = '';

  var filterLastMessage = <LastMessage>[].obs;
  var lastMessages = <LastMessage>[].obs;

  var filterChat = <Chat>[].obs;
  var chats = <Chat>[].obs;

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
              element.profileName!.toLowerCase().contains(term.toLowerCase()))
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
      filterChat.value = filter;
    } else {
      filterChat.value = chats;
      this.term = '';
    }
  }

  void loadLastMessages() async {
    var lastMessages = await contactRepo.loadSavedFriends();
    filterLastMessage.value = lastMessages;
    this.lastMessages.value = lastMessages;
  }

  void loadChats() async {
    var chats = await repository.loadChats(roomId);
    filterChat.value = chats;
    this.chats.value = chats;
  }
}
