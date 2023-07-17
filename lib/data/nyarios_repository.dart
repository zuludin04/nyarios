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
