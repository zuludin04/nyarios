import 'package:get/get.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';

class NyariosSearchController extends GetxController {
  final repository = MessageRepository();
  final chatRepo = ChatRepository();
  final contactRepo = ContactRepository();

  String type = Get.arguments['type'];
  String roomId = Get.arguments['roomId'];
  String user = Get.arguments['user'];

  String term = '';

  var filterRecentChat = <Chat>[].obs;
  var recentChats = <Chat>[].obs;

  var filterMessage = <Message>[].obs;
  var messages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (type == 'lastMessage') {
      loadRecentChat();
    } else {
      loadMessages();
    }
  }

  void searchLastMessage(String term) {
    this.term = term;

    if (term.isNotEmpty) {
      var filter = recentChats
          .where((element) =>
              element.profile!.name!.toLowerCase().contains(term.toLowerCase()))
          .toList();
      filterRecentChat.value = filter;
    } else {
      filterRecentChat.value = recentChats;
      this.term = '';
    }
  }

  void searchChat(String term) {
    this.term = term;

    if (term.isNotEmpty) {
      var filter = messages
          .where((element) =>
              element.message!.toLowerCase().contains(term.toLowerCase()))
          .toList();
      filterMessage.value = filter;
    } else {
      filterMessage.value = messages;
      this.term = '';
    }
  }

  void loadRecentChat() async {
    var recent = await chatRepo.loadUserRecentChat();
    filterRecentChat.value = recent;
    recentChats.value = recent;
  }

  void loadMessages() async {
    var chats = await repository.loadMessages(roomId);
    filterMessage.value = chats;
    messages.value = chats;
  }
}
