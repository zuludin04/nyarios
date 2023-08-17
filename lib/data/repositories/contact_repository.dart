import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/contact.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/services/storage_services.dart';

class ContactRepository {
  final CollectionReference contactReference =
      FirebaseFirestore.instance.collection('contact');

  ProfileRepository profileRepository = ProfileRepository();

  Future<void> saveContact(Contact contact, String profileId) async {
    contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .set(contact.toMap());
  }

  Future<bool> checkIfContactExist(String userId) async {
    var doc = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<Contact?> loadSingleContact(String? profileId) async {
    var ref = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .get();

    return ref.data() == null ? null : Contact.fromJson(ref.data()!);
  }

  Future<void> changeBlockStatus(String? profileId, bool blocked) async {
    contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .update({'blocked': blocked});
  }

  Future<List<Contact>> loadContacts(bool blocked) async {
    var results = await contactReference
        .doc(StorageServices.to.userId)
        .collection('friends')
        .where('alreadyFriend', isEqualTo: true)
        .where('blocked', isEqualTo: blocked)
        .get();

    var contacts = results.docs.map((e) async {
      var profileId = e.data()['profileId'];
      var profile = await profileRepository.loadSingleProfile(profileId);
      return Contact.fromMap(e.data(), profile);
    }).toList();

    return Future.wait(contacts);
  }
}
