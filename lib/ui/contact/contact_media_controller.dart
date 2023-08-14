import 'package:get/get.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

class ContactMediaController extends GetxController {
  final Contact lastMessage = Get.arguments;
  final repository = MessageRepository();

  var mediaMessages = <Message>[];
  var loading = false;
  var empty = false;

  var profiles = <Profile>[];

  Future<void> loadChats(String type) async {
    loading = true;

    var chats = await repository.loadMessageMedia(lastMessage.chatId);

    mediaMessages = chats.where((e) => e.type == type).toList();
    empty = mediaMessages.isEmpty;
    loading = false;

    update([type]);
  }

  Future<void> loadMembers(Group group) async {
    var repo = ProfileRepository();

    for (var element in group.members!) {
      var profile = await repo.loadSingleProfile(element);
      profiles.add(profile);
    }

    update();
  }
}
