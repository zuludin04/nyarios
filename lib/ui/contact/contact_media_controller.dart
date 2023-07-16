import 'package:get/get.dart';

import '../../data/model/chat.dart';
import '../../data/model/profile.dart';
import '../../data/nyarios_repository.dart';

class ContactMediaController extends GetxController {
  final Profile profile = Get.arguments;
  final repository = NyariosRepository();

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
