import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/contact.dart';

final firebaseContactSourceProvider = Provider<FirebaseContactSource>((ref) {
  final firestore = firestoreProvider(ref);
  return FirebaseContactSource(firestore: firestore);
});

class FirebaseContactSource {
  final FirebaseFirestore firestore;

  const FirebaseContactSource({required this.firestore});

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

  Future<Contact?> loadSingleContact(String? profileId, String? userId) async {
    var ref = await firestore
        .collection('contact')
        .doc(userId)
        .collection('items')
        .doc(profileId)
        .get();

    return ref.data() == null ? null : Contact.fromMap(ref.data()!);
  }
}
