import 'package:nyarios/data/sources/firebase/firebase_contact_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/domain/model/contact.dart';

class ContactRepository {
  final FirebaseContactSource contactSource;
  final SharedLocalSource localSource;

  const ContactRepository({
    required this.contactSource,
    required this.localSource,
  });

  Future<void> saveContact(String? userId, Contact contact) async {
    await contactSource.saveContact(userId, contact);
  }

  Future<List<Contact>> loadContacts(String status) async {
    final user = await localSource.getUserProfile();
    final contacts = await contactSource.loadContacts(user.userId, status);
    return contacts;
  }

  Future<void> changeContactStatus(String? otherUserId, String status) async {
    final user = await localSource.getUserProfile();
    await contactSource.changeContactStatus(user.userId, otherUserId, status);
  }

  Future<Contact?> loadSingleContact(String? profileId) async {
    final user = await localSource.getUserProfile();
    final contact = await contactSource.loadSingleContact(
      profileId,
      user.userId,
    );
    return contact;
  }
}
