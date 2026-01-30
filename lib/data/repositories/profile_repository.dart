import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/services/storage_services.dart';

class ProfileRepository {
  final FirebaseFirestore firestore;

  ProfileRepository({required this.firestore});

  Future<void> saveUserProfile(Profile profile) async {
    var exist = await checkIfUserExist(profile.uid!);
    if (!exist) {
      var id = await getIncrementedId();
      var userId = id + 1;
      profile.id = userId;
      updateIncrementedId(userId);
      firestore.collection("profile").doc(profile.uid).set(profile.toMap());

      StorageServices.to.userId = profile.uid ?? "";
      StorageServices.to.userName = profile.name ?? "";
      StorageServices.to.email = profile.email ?? "";
      StorageServices.to.userImage = profile.photo ?? "";
      StorageServices.to.id = userId;
    } else {
      var userProfile = await loadSingleProfile(profile.uid);
      StorageServices.to.userId = userProfile.uid ?? "";
      StorageServices.to.userName = userProfile.name ?? "";
      StorageServices.to.email = userProfile.email ?? "";
      StorageServices.to.userImage = userProfile.photo ?? "";
      StorageServices.to.id = userProfile.id ?? 0;
    }
  }

  Future<bool> checkIfUserExist(String userId) async {
    var doc = await firestore.collection("profile").doc(userId).get();
    return doc.exists;
  }

  Future<Profile> loadSingleProfile(String? uid) async {
    var ref = await firestore.collection("profile").doc(uid).get();
    return Profile.fromMap(ref.data()!);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOnlineStatus(String? uid) {
    return firestore.collection("profile").doc(uid).snapshots();
  }

  Stream<Profile> loadStreamProfile(String uid) async* {
    var profile = firestore.collection("profile").doc(uid).snapshots();
    yield* profile.map((event) => Profile.fromMap(event.data()!));
  }

  Future<void> updateImageProfile(String profileId, String url) async {
    firestore.collection("profile").doc(profileId).update({'photo': url});
  }

  Future<void> updateOnlineStatus(bool status) async {
    var exist = await checkIfUserExist(StorageServices.to.userId);
    if (exist) {
      firestore.collection("profile").doc(StorageServices.to.userId).update({
        'visibility': status,
      });
    }
  }

  Future<String?> loadUserStatus(String? userId) async {
    var collection = firestore.collection("profile");
    var doc = await collection.doc(userId).get();
    return doc.data()?['status'];
  }

  Future<void> updateProfile(
    String profileId,
    String value,
    bool updateName,
  ) async {
    var updateData = updateName ? {'name': value} : {'status': value};
    firestore.collection("profile").doc(profileId).update(updateData);
  }

  Future<int> getIncrementedId() async {
    var collection = firestore.collection('incrementedId');
    var doc = await collection.doc('FvmJzscRcjO4J9AFFPEe').get();
    return doc.data()!['id'];
  }

  Future<void> updateIncrementedId(int id) async {
    firestore.collection('incrementedId').doc('FvmJzscRcjO4J9AFFPEe').set({
      'id': id,
    });
  }
}
