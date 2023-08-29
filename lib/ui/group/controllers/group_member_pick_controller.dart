import 'package:get/get.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class GroupMemberPickController extends GetxController {
  var contactRepo = ContactRepository();
  var groupRepo = GroupRepository();
  var chatRepo = ChatRepository();

  var selectedMembers = <Profile>[];

  void addGroupMembers(Group group) {
    var chat = Chat(
      profileId: group.groupId,
      lastMessage: 'New group member is added',
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: group.chatId,
      type: 'group',
    );

    var members = selectedMembers.map((e) => e.uid!).toList();
    members.addAll(group.members!);
    group.members = members;

    groupRepo.updateGroupMember(group.groupId!, members).then((value) async {
      chatRepo.updateGroupRecentChat(group, chat);
      _addGroupInfoMessage(group.chatId!);
      Get.back();
    });
  }

  Future<void> _addGroupInfoMessage(String chatId) async {
    var repo = MessageRepository();

    Message newMessage = Message(
      message: 'New group member is added',
      type: 'info',
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      url: '',
      fileSize: '',
      profileId: StorageServices.to.userId,
      chatId: chatId,
    );

    repo.sendNewMessage(newMessage);
  }

  void addRemoveMember(bool remove, Profile profile) {
    if (remove) {
      selectedMembers.remove(profile);
    } else {
      selectedMembers.add(profile);
    }
    update();
  }
}
