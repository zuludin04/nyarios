import 'package:get/get.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';

import '../../data/model/chat.dart';

class ContactMediaController extends GetxController {
  final LastMessage lastMessage = Get.arguments;
  final repository = ChatRepository();

  var mediaChats = <Chat>[];
  var loading = false;
  var empty = false;

  Future<void> loadChats(String type) async {
    loading = true;

    var chats = await repository.loadChats(lastMessage.profileId);

    mediaChats = chats.where((e) => e.type == type).toList();
    empty = mediaChats.isEmpty;
    loading = false;

    update([type]);
  }
}
