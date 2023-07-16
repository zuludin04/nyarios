import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/profile.dart';

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
}
