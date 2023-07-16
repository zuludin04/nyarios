import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/storage_services.dart';
import 'model/chat.dart';
import 'model/last_message.dart';
import 'model/profile.dart';

class NyariosRepository {
  final CollectionReference profileReference =
      FirebaseFirestore.instance.collection('profile');
  final CollectionReference lastMessageReference =
      FirebaseFirestore.instance.collection('lastMessage');
  final CollectionReference roomReference =
      FirebaseFirestore.instance.collection('room');

  Stream<List<LastMessage>> loadUsersLastMessages() async* {
    var lastMessageStream = FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('sendDatetime', descending: true)
        .snapshots();

    var lastMessages = <LastMessage>[];

    await for (var snapshot in lastMessageStream) {
      for (var doc in snapshot.docs) {
        var lastMessage = LastMessage.fromMap(doc.data());
        var profile = await loadSingleProfile(lastMessage.receiverId);
        lastMessage.name = profile.name;
        lastMessage.photo = profile.photo;
        lastMessages.clear();
        lastMessages.add(lastMessage);
      }
      yield lastMessages;
    }
  }

  Future<Profile> loadSingleProfile(String? uid) async {
    var profiles =
        await FirebaseFirestore.instance.collection('profile').doc(uid).get();
    return Profile.fromMap(profiles.data()!);
  }

  Future<List<LastMessage>> loadLastMessages() async {
    var lastMessages = await FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('sendDatetime', descending: true)
        .get();

    var list = lastMessages.docs.map((e) async {
      LastMessage lastMessage = LastMessage.fromMap(e.data());
      var profile = await loadSingleProfile(lastMessage.receiverId);
      lastMessage.name = profile.name;
      lastMessage.photo = profile.photo;
      return lastMessage;
    }).toList();

    return Future.wait(list);
  }

  Future<List<Profile>> loadAllProfiles() async {
    var lastMessages = await FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .get();

    if (lastMessages.size == 0) {
      var profiles = await FirebaseFirestore.instance
          .collection('profile')
          .where('id', isNotEqualTo: StorageServices.to.userId)
          .get();

      return profiles.docs.map((e) => Profile.fromMap(e.data())).toList();
    } else {
      var profiles = await FirebaseFirestore.instance
          .collection('profile')
          .where('id', isNotEqualTo: StorageServices.to.userId)
          .get();

      var list = profiles.docs.map((e) async {
        var profile = Profile.fromMap(e.data());
        var pro = await _lastMessageReceiver(profile);
        return pro;
      }).toList();

      return Future.wait(list);
    }
  }

  Future<Profile> _lastMessageReceiver(Profile profile) async {
    var lastMessage = await FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .get();

    var roomId = lastMessage.docs.where((element) {
      var uid = profile.uid ?? "";
      return element['receiverId'] == uid;
    }).toList();

    if (roomId.isNotEmpty) {
      // profile.roomId = roomId[0]['roomId'];
    } else {
      // profile.roomId = null;
    }

    return profile;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadUserChatsByRoomId(
    String? roomId,
  ) {
    return FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .snapshots();
  }

  Future<List<Chat>> loadChats(String? roomId) async {
    var chats = await FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs.map((e) => Chat.fromMap(e.data(), "")).toList();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOnlineStatus(String? uid) {
    return FirebaseFirestore.instance
        .collection('profile')
        .doc(uid)
        .snapshots();
  }

  Stream<Profile> loadStreamProfile(String uid) async* {
    var profile =
        FirebaseFirestore.instance.collection('profile').doc(uid).snapshots();
    yield* profile.map((event) => Profile.fromMap(event.data()!));
  }

  void updateOnlineStatus(bool status) async {
    var exist = await checkIfUserExist(StorageServices.to.userId);
    if (exist) {
      FirebaseFirestore.instance
          .collection('profile')
          .doc(StorageServices.to.userId)
          .update({'visibility': status});
    }
  }

  void sendNewMessage(
    String? roomId,
    String message,
    String type,
    String url,
    String fileSize,
  ) {
    CollectionReference newMessage = FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages');

    Chat chat = Chat(
      message: message,
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      senderId: StorageServices.to.userId,
      type: type,
      url: url,
      fileSize: fileSize,
    );

    newMessage.add(chat.toMap());
  }

  Future<void> batchDelete(
      String roomId, List<Chat> chatMessages, Profile profile) async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages');

    for (var message in chatMessages) {
      messages.doc(message.messageId).delete();
    }

    var updatedMessages = await loadChats(roomId);
    var selectedMessage = updatedMessages[updatedMessages.length - 1];
    updateLastMessage(true, true, profile, selectedMessage.message!, roomId,
        sendDateTime: selectedMessage.sendDatetime);
    updateLastMessage(false, true, profile, selectedMessage.message!, roomId,
        sendDateTime: selectedMessage.sendDatetime);
  }

  void updateLastMessage(
    bool fromSender,
    bool update,
    Profile profile,
    String message,
    String roomId, {
    int? sendDateTime,
  }) {
    if (update) {
      FirebaseFirestore.instance
          .collection('lastMessage')
          .doc(fromSender ? StorageServices.to.userId : profile.uid)
          .collection('receiver')
          .doc(fromSender ? profile.uid : StorageServices.to.userId)
          .update({
        'message': message,
        'sendDatetime': sendDateTime ?? DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      FirebaseFirestore.instance
          .collection('lastMessage')
          .doc(fromSender ? StorageServices.to.userId : profile.uid)
          .collection('receiver')
          .doc(fromSender ? profile.uid : StorageServices.to.userId)
          .set({
        'message': message,
        'receiverId': fromSender ? profile.uid : StorageServices.to.userId,
        'roomId': roomId,
        'sendDatetime': DateTime.now().millisecondsSinceEpoch,
        'block': false,
      });
    }
  }

  Future<bool> checkIfUserExist(String userId) async {
    var doc = await profileReference.doc(userId).get();
    return doc.exists;
  }

  Future<String?> loadUserStatus(String? userId) async {
    var collection = FirebaseFirestore.instance.collection('profile');
    var doc = await collection.doc(userId).get();
    return doc.data()?['status'];
  }

  Future<void> updateProfile(
    String profileId,
    String value,
    bool updateName,
  ) async {
    var updateData = updateName ? {'name': value} : {'status': value};
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profileId)
        .update(updateData);
  }

  Future<void> updateImageProfile(String profileId, String url) async {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profileId)
        .update({'photo': url});
  }
}
