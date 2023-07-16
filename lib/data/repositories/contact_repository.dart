import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/profile.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ContactRepository {
  final CollectionReference contactReference =
      FirebaseFirestore.instance.collection('contact');
  ProfileRepository profileRepository = ProfileRepository();

  Future<void> saveNewFriend(
      Profile profile, String roomId, bool fromSender) async {
    var friend = await contactReference
        .doc(fromSender ? StorageServices.to.userId : profile.uid)
        .collection('friends')
        .doc(fromSender ? profile.uid : StorageServices.to.userId)
        .get();
    if (!friend.exists) {
      FirebaseFirestore.instance
          .collection('contact')
          .doc(fromSender ? StorageServices.to.userId : profile.uid)
          .collection('friends')
          .doc(fromSender ? profile.uid : StorageServices.to.userId)
          .set({
        'profileId': fromSender ? profile.uid : StorageServices.to.userId,
        'blocked': false,
        'alreadyAdded': fromSender,
        'roomId': roomId,
      });
    }
  }

  Future<List<Profile>> loadSavedFriends() async {
    var lastMessages = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .where('alreadyAdded', isEqualTo: true)
        .get();

    var list = lastMessages.docs.map((e) async {
      var profileId = e.data()['profileId'];
      var profile = await profileRepository.loadSingleProfile(profileId);
      return profile;
    }).toList();

    return Future.wait(list);
  }
}
