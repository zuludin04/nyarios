import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/domain/model/contact.dart';

class ContactRepository {
  final FirebaseFirestore firestore;

  ContactRepository({required this.firestore});

  Future<void> saveContact(String? userId, Contact contact) async {
    await firestore
        .collection('contact')
        .doc(userId)
        .collection('items')
        .doc(contact.userId)
        .set(contact.toMap());
  }

  Future<List<Contact>> loadContacts(String? userId, String status) async {
    var results = await firestore
        .collection('contact')
        .doc(userId)
        .collection('items')
        .where('status', isEqualTo: status)
        .get();

    var contacts = results.docs.map((e) async {
      return Contact.fromMap(e.data());
    }).toList();

    return Future.wait(contacts);
  }

  Future<void> changeContactStatus(
    String? userId,
    String? otherUserId,
    String status,
  ) async {
    await firestore
        .collection('contact')
        .doc(userId)
        .collection('items')
        .doc(otherUserId)
        .update({'status': status});
  }

  Future<bool> checkIfContactExist({
    required String userId,
    required String friendId,
  }) async {
    var doc = await firestore
        .collection('contact')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .get();
    return doc.exists;
  }

  Future<Contact?> loadSingleContact(String? profileId, String? userId) async {
    var ref = await firestore
        .collection('contact')
        .doc(userId)
        .collection('friends')
        .doc(profileId)
        .get();

    return ref.data() == null ? null : Contact.fromMap(ref.data()!);
  }
}
