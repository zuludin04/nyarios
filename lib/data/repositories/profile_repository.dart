import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nyarios/domain/model/profile.dart';

class ProfileRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRepository({required this.firestore, required this.auth});

  Future<void> saveUserProfile(Profile profile) async {
    final exist = await checkIfUserExist(profile.uid!);
    final fcmToken = await loadFcmToken();
    if (!exist) {
      final id = await getIncrementedId();
      final userId = id + 1;

      profile.id = userId;
      profile.fcmToken = fcmToken;

      updateIncrementedId(userId);
      firestore.collection("profile").doc(profile.uid).set(profile.toMap());
    } else {
      final userProfile = await loadSingleProfile(profile.uid);
      await updateFcmToken(fcmToken, userProfile.uid);
    }
  }

  Future<User?> signInCredential(String? accessToken, String? idToken) async {
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    var credentialAuth = await auth.signInWithCredential(credential);
    return credentialAuth.user;
  }

  Future<bool> checkIfUserExist(String? userId) async {
    var doc = await firestore.collection("profile").doc(userId).get();
    return doc.exists;
  }

  Future<Profile> loadSingleProfile(String? uid) async {
    var ref = await firestore.collection("profile").doc(uid).get();
    return Profile.fromMap(ref.data()!);
  }

  Stream<bool> getOnlineStatus(String? uid) {
    return firestore.collection("profile").doc(uid).snapshots().map((snapshot) {
      Profile profile = Profile.fromMap(snapshot.data()!);
      return profile.visibility ?? false;
    });
  }

  Stream<Profile> loadStreamProfile(String? uid) async* {
    var profile = firestore.collection("profile").doc(uid).snapshots();
    yield* profile.map((event) => Profile.fromMap(event.data()!));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamProfiles() async* {
    var profile = firestore.collection("profile").snapshots();
    yield* profile;
  }

  Future<void> updateImageProfile(String? profileId, String url) async {
    firestore.collection("profile").doc(profileId).update({'photo': url});
  }

  Future<void> updateOnlineStatus(bool status, String? userId) async {
    var exist = await checkIfUserExist(userId);
    if (exist) {
      firestore.collection("profile").doc(userId).update({
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
    String? profileId,
    String value,
    bool updateName,
  ) async {
    var updateData = updateName ? {'name': value} : {'status': value};
    firestore.collection("profile").doc(profileId).update(updateData);
  }

  Future<void> updateFcmToken(String? token, String? profileId) async {
    var updateData = {'fcmToken': token};
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

  Future<String?> loadFcmToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    final token = await firebaseMessaging.getToken();
    return token;
  }
}
