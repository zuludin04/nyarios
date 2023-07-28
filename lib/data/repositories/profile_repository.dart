import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/services/storage_services.dart';

class ProfileRepository {
  final CollectionReference profileReference =
      FirebaseFirestore.instance.collection('profile');

  Future<void> saveUserProfile(Profile profile) async {
    var exist = await checkIfUserExist(profile.uid!);
    if (!exist) {
      profileReference.doc(profile.uid).set(profile.toMap());
    }
  }

  Future<bool> checkIfUserExist(String userId) async {
    var doc = await profileReference.doc(userId).get();
    return doc.exists;
  }

  Future<Profile> loadSingleProfile(String? uid) async {
    var ref =
        await FirebaseFirestore.instance.collection('profile').doc(uid).get();
    return Profile.fromMap(ref.data()!);
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

  Future<void> updateImageProfile(String profileId, String url) async {
    FirebaseFirestore.instance
        .collection('profile')
        .doc(profileId)
        .update({'photo': url});
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
}