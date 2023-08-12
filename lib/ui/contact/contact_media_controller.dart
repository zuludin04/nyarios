import 'package:get/get.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/repositories/message_repository.dart';

class ContactMediaController extends GetxController {
  final Contact lastMessage = Get.arguments;
  final repository = MessageRepository();

  var mediaMessages = <Message>[];
  var loading = false;
  var empty = false;

  Future<void> loadChats(String type) async {
    loading = true;

    var chats = await repository.loadMessageMedia(lastMessage.chatId);

    mediaMessages = chats.where((e) => e.type == type).toList();
    empty = mediaMessages.isEmpty;
    loading = false;

    update([type]);
  }
}
