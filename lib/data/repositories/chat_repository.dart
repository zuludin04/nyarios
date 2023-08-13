import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/chat.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ChatRepository {
  final CollectionReference chatReference =
      FirebaseFirestore.instance.collection('chat');

  final ProfileRepository profileRepository = ProfileRepository();

  Stream<List<Chat>> loadRecentChat() async* {
    var recentChatStream = chatReference
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('lastMessageSent', descending: true)
        .snapshots();

    var lastMessages = <Chat>[];

    await for (var snapshot in recentChatStream) {
      for (var doc in snapshot.docs) {
        var receiverId = doc.data()['profileId'];
        var profile = await profileRepository.loadSingleProfile(receiverId);

        var lastMessage = Chat.fromMap(doc.data(), profile);

        lastMessages.clear();
        lastMessages.add(lastMessage);
      }
      yield lastMessages;
    }
  }

  void updateRecentChat(bool fromSender, Chat lastMessage) {
    chatReference
        .doc(fromSender ? StorageServices.to.userId : lastMessage.profileId)
        .collection('receiver')
        .doc(fromSender ? lastMessage.profileId : StorageServices.to.userId)
        .set(lastMessage.toMap(fromSender));
  }
}
