import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/storage_services.dart';
import 'model/chat.dart';
import 'model/profile.dart';

class NyariosRepository {
  final CollectionReference profileReference =
      FirebaseFirestore.instance.collection('profile');
  final CollectionReference lastMessageReference =
      FirebaseFirestore.instance.collection('lastMessage');
  final CollectionReference roomReference =
      FirebaseFirestore.instance.collection('room');

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
