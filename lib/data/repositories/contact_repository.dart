import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/model/friend.dart';
import 'package:nyarios/data/model/last_message.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ContactRepository {
  final CollectionReference contactReference =
      FirebaseFirestore.instance.collection('contact');
  ProfileRepository profileRepository = ProfileRepository();

  Future<void> saveContact(Contact contact, String profileId) async {
    var exist = await checkIfContactExist(profileId);
    if (!exist) {
      contactReference
          .doc(StorageServices.to.userId)
          .collection('friends')
          .doc(profileId)
          .set(contact.toMap());
    }
  }

  Future<bool> checkIfContactExist(String userId) async {
    var doc = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<List<Contact>> loadContacts() async {
    var results = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .where('alreadyFriend', isEqualTo: true)
        .where('blocked', isEqualTo: false)
        .get();

    return results.docs.map((e) => Contact.fromMap(e.data())).toList();
  }

  Future<List<LastMessage>> loadSavedFriends() async {
    var lastMessages = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .where('alreadyAdded', isEqualTo: true)
        .get();

    var list = lastMessages.docs.map((e) async {
      var profileId = e.data()['profileId'];
      var profile = await profileRepository.loadSingleProfile(profileId);
      var friend = await loadSingleFriend(profileId);
      return LastMessage();
    }).toList();

    return Future.wait(list);
  }

  Future<Friend?> loadSingleFriend(String? uid) async {
    var ref = await FirebaseFirestore.instance
        .collection('contact')
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(uid)
        .get();
    return ref.data() == null ? null : Friend.fromMap(ref.data()!);
  }

  Future<void> changeBlockStatus(String? profileId, bool blocked) async {
    contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .update({
      'blocked': blocked,
    });
  }

  Future<List<LastMessage>> loadBlockedUser() async {
    var lastMessages = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .where('blocked', isEqualTo: true)
        .get();

    var list = lastMessages.docs.map((e) async {
      var profileId = e.data()['profileId'];
      var profile = await profileRepository.loadSingleProfile(profileId);
      var friend = await loadSingleFriend(profileId);
      return LastMessage();
    }).toList();

    return Future.wait(list);
  }
}
