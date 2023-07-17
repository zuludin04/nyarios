import 'package:get/get.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';

import '../../data/model/chat.dart';
import '../../data/model/profile.dart';

class ContactMediaController extends GetxController {
  final Profile profile = Get.arguments;
  final repository = ChatRepository();

  var mediaChats = <Chat>[];
  var loading = false;
  var empty = false;

  Future<void> loadChats(String type) async {
    loading = true;

    var chats = await repository.loadChats('profile.roomId');

    mediaChats = chats.where((e) => e.type == type).toList();
    empty = mediaChats.isEmpty;
    loading = false;

    update([type]);
  }
}
