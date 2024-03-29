import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/model/group.dart';
import 'package:nyarios/data/repositories/group_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ChatRepository {
  final CollectionReference chatReference =
      FirebaseFirestore.instance.collection('chat');

  final ProfileRepository profileRepository = ProfileRepository();
  final GroupRepository groupRepository = GroupRepository();

  Stream<QuerySnapshot<Map<String, dynamic>>> loadRecentChat() async* {
    yield* chatReference
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('lastMessageSent', descending: true)
        .snapshots();
  }

  Future<List<Chat>> loadUserRecentChat() async {
    var results = await chatReference
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .where('type', isEqualTo: 'dm')
        .get();
    var recent = results.docs.map((e) async {
      var chat = Chat.fromMap(e.data());
      var profile = await profileRepository.loadSingleProfile(chat.profileId);
      chat.profile = profile;
      return chat;
    }).toList();
    return Future.wait(recent);
  }

  void updateRecentChat(bool fromSender, Chat lastMessage) {
    chatReference
        .doc(fromSender ? StorageServices.to.userId : lastMessage.profileId)
        .collection('receiver')
        .doc(fromSender ? lastMessage.profileId : StorageServices.to.userId)
        .set(lastMessage.toMap(fromSender));
  }

  Future<void> updateGroupRecentChat(Group group, Chat chat) async {
    for (var element in group.members!) {
      await chatReference
          .doc(element)
          .collection('receiver')
          .doc(group.groupId)
          .set(chat.toMapGroup());
    }
  }

  Future<void> deleteGroupChat(String groupId) async {
    await chatReference
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .doc(groupId)
        .delete();
  }
}
