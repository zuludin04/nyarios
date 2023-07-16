import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ContactRepository {
  final CollectionReference contactReference =
      FirebaseFirestore.instance.collection('contact');
  ProfileRepository profileRepository = ProfileRepository();

  Future<void> saveNewFriend(Profile profile) async {
    var friend = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profile.uid)
        .get();
    if (!friend.exists) {
      FirebaseFirestore.instance
          .collection('contact')
          .doc(StorageServices.to.userId)
          .collection('friends')
          .doc(profile.uid)
          .set({
        'profileId': profile.uid,
        'blocked': false,
        'alreadyAdded': false,
      });
    }
  }

  Future<List<Profile>> loadSavedFriends() async {
    var lastMessages = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .get();

    var list = lastMessages.docs.map((e) async {
      var profileId = e.data()['profileId'];
      var profile = await profileRepository.loadSingleProfile(profileId);
      return profile;
    }).toList();

    return Future.wait(list);
  }
}
