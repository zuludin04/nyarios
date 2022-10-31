import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/storage_services.dart';
import 'model/chat.dart';
import 'model/contact.dart';
import 'model/profile.dart';

class NyariosRepository {
  final CollectionReference profileReference =
      FirebaseFirestore.instance.collection('profile');
  final CollectionReference contactReference =
      FirebaseFirestore.instance.collection('contacts');
  final CollectionReference roomReference =
      FirebaseFirestore.instance.collection('room');

  Stream<QuerySnapshot<Map<String, dynamic>>> loadUserContacts() {
    return FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('sendDatetime', descending: true)
        .snapshots();
  }

  Future<List<Contact>> loadContacts() async {
    var contacts = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .orderBy('sendDatetime', descending: true)
        .get();

    return contacts.docs.map((e) => Contact.fromMap(e.data())).toList();
  }

  Future<List<Profile>> loadAllProfiles() async {
    var contacts = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .get();

    if (contacts.size == 0) {
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
        var pro = await _contactReceiver(profile);
        return pro;
      }).toList();

      return Future.wait(list);
    }
  }

  Future<Profile> _contactReceiver(Profile profile) async {
    var contact = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(StorageServices.to.userId)
        .collection('receiver')
        .get();

    var roomId = contact.docs.where((element) {
      var uid = profile.uid ?? "";
      return element['receiverId'] == uid;
    }).toList();

    if (roomId.isNotEmpty) {
      profile.roomId = roomId[0]['roomId'];
    } else {
      profile.roomId = null;
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
    updateRecentContact(
        true, true, profile, selectedMessage.message!, roomId, 0,
        sendDateTime: selectedMessage.sendDatetime);
    updateRecentContact(
        false, true, profile, selectedMessage.message!, roomId, 0,
        sendDateTime: selectedMessage.sendDatetime);
  }

  void updateRecentContact(
    bool fromSender,
    bool update,
    Profile profile,
    String message,
    String roomId,
    int unreadMessage, {
    int? sendDateTime,
  }) {
    if (update) {
      FirebaseFirestore.instance
          .collection('contacts')
          .doc(fromSender ? StorageServices.to.userId : profile.uid)
          .collection('receiver')
          .doc(fromSender ? profile.uid : StorageServices.to.userId)
          .update({
        'message': message,
        'sendDatetime': sendDateTime ?? DateTime.now().millisecondsSinceEpoch,
        'unreadMessage': unreadMessage
      });
    } else {
      FirebaseFirestore.instance
          .collection('contacts')
          .doc(fromSender ? StorageServices.to.userId : profile.uid)
          .collection('receiver')
          .doc(fromSender ? profile.uid : StorageServices.to.userId)
          .set({
        'message': message,
        'name': fromSender ? profile.name : StorageServices.to.userName,
        'receiverId': fromSender ? profile.uid : StorageServices.to.userId,
        'roomId': roomId,
        'photo': profile.photo,
        'sendDatetime': DateTime.now().millisecondsSinceEpoch,
        'block': false,
        'unreadMessage': unreadMessage
      });
    }
  }

  Future<bool> signInUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      var userExist = await checkIfUserExist(googleSignInAccount.id);

      StorageServices.to.alreadyLogin = true;
      StorageServices.to.userId = googleSignInAccount.id;
      StorageServices.to.userName = googleSignInAccount.displayName ?? "";
      StorageServices.to.userImage = googleSignInAccount.photoUrl ?? "";

      if (!userExist) {
        FirebaseFirestore.instance
            .collection('profile')
            .doc(googleSignInAccount.id)
            .set({
          'id': googleSignInAccount.id,
          'name': googleSignInAccount.displayName,
          'photo': googleSignInAccount.photoUrl,
          'visibility': true,
        });
      }

      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserExist(String userId) async {
    var doc = await profileReference.doc(userId).get();
    return doc.exists;
  }
}
