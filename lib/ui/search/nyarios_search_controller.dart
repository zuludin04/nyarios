import 'package:get/get.dart';

import '../../data/model/chat.dart';
import '../../data/model/contact.dart';
import '../../data/nyarios_repository.dart';

class NyariosSearchController extends GetxController {
  final repository = NyariosRepository();

  String type = Get.arguments['type'];
  String roomId = Get.arguments['roomId'];
  String user = Get.arguments['user'];

  String term = '';

  var filterContact = <Contact>[].obs;
  var contacts = <Contact>[].obs;

  var filterChat = <Chat>[].obs;
  var chats = <Chat>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (type == 'contacts') {
      loadContacts();
    } else {
      loadChats();
    }
  }

  void searchContact(String term) {
    if (term.isNotEmpty) {
      var filter = contacts
          .where((element) =>
              element.name!.toLowerCase().contains(term.toLowerCase()))
          .toList();
      filterContact.value = filter;
    } else {
      filterContact.value = contacts;
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

  void loadContacts() async {
    var contacts = await repository.loadContacts();
    filterContact.value = contacts;
    this.contacts.value = contacts;
  }

  void loadChats() async {
    var chats = await repository.loadChats(roomId);
    filterChat.value = chats;
    this.chats.value = chats;
  }
}
