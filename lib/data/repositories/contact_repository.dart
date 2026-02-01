import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/services/storage_services.dart';

class ContactRepository {
  final FirebaseFirestore firestore;

  ContactRepository({required this.firestore});

  Future<void> saveContact(Contact contact, String? profileId) async {
    firestore
        .collection('contact')
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .set(contact.toMap());
  }

  Future<bool> checkIfContactExist(String userId) async {
    var doc = await firestore
        .collection('contact')
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<Contact?> loadSingleContact(String? profileId) async {
    var ref = await firestore
        .collection('contact')
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .get();

    return ref.data() == null ? null : Contact.fromJson(ref.data()!);
  }

  Future<void> changeBlockStatus(String? profileId, bool blocked) async {
    firestore
        .collection('contact')
        .doc(StorageServices.to.userId)
        .collection('friends')
        .doc(profileId)
        .update({'blocked': blocked});
  }

  Future<List<Contact>> loadContacts(bool blocked) async {
    var results = await firestore
        .collection('contact')
        .doc(StorageServices.to.userId)
        .collection('friends')
        .where('alreadyFriend', isEqualTo: true)
        .where('blocked', isEqualTo: blocked)
        .get();

    var contacts = results.docs.map((e) async {
      return Contact.fromJson(e.data());
    }).toList();

    return Future.wait(contacts);
  }
}
