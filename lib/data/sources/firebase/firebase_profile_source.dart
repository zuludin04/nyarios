import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/profile.dart';

final firebaseProfileSourceProvider = Provider<FirebaseProfileSource>((ref) {
  final firestore = firestoreProvider(ref);
  final auth = firebaseAuthProvider(ref);
  return FirebaseProfileSource(firestore: firestore, auth: auth);
});

class FirebaseProfileSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const FirebaseProfileSource({required this.firestore, required this.auth});

  Future<void> saveUserProfile(Profile profile) async {
    firestore.collection("profile").doc(profile.uid).set(profile.toMap());
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

  Future<Profile?> loadSingleProfile(String? uid) async {
    var ref = await firestore.collection("profile").doc(uid).get();
    if (ref.data() == null) {
      return null;
    } else {
      return Profile.fromMap(ref.data()!);
    }
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

  Future<void> updateOnlineStatus(bool status, String? userId) async {
    var exist = await checkIfUserExist(userId);
    if (exist) {
      firestore.collection("profile").doc(userId).update({
        'visibility': status,
      });
    }
  }

  Future<void> updateProfile(
    String? profileId,
    String value,
    bool updateName,
  ) async {
    var updateData = updateName ? {'name': value} : {'status': value};
    firestore.collection("profile").doc(profileId).update(updateData);
  }

  Future<String?> loadFcmToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    final token = await firebaseMessaging.getToken();
    return token;
  }
}
