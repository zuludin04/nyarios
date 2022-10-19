import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/storage_services.dart';
import 'model/chat.dart';
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
        .snapshots();
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
        .snapshots();
  }

  void sendNewMessage(String? roomId, String message, String type) {
    CollectionReference newMessage = FirebaseFirestore.instance
        .collection('room')
        .doc(roomId)
        .collection('messages');

    Chat chat = Chat(
        message: message,
        sendDatetime: '14 Oct 2022',
        senderId: StorageServices.to.userId,
        type: type);

    newMessage.add(chat.toMap());
  }

  void updateRecentContact(
    bool fromSender,
    bool update,
    Profile profile,
    String message,
    String roomId,
  ) {
    if (update) {
      FirebaseFirestore.instance
          .collection('contacts')
          .doc(fromSender ? StorageServices.to.userId : profile.uid)
          .collection('receiver')
          .doc(fromSender ? profile.uid : StorageServices.to.userId)
          .update({'message': message});
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
        'send_datetime': '18 Oct 2022',
      });
    }
  }
}