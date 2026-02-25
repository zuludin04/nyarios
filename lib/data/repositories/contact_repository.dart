import 'package:nyarios/data/sources/firebase/firebase_contact_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/contact_remote_source.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/profile.dart';

class ContactRepository {
  final FirebaseContactSource contactSource;
  final SharedLocalSource localSource;
  final ContactRemoteSource remoteSource;

  const ContactRepository({
    required this.contactSource,
    required this.localSource,
    required this.remoteSource,
  });

  Future<void> saveContact(String? userId, Contact contact) async {
    await contactSource.saveContact(userId, contact);
  }

  Future<List<Profile>> loadContacts(String status) async {
    final user = await localSource.getUserProfile();
    final contacts = await remoteSource.getContactByStatus(
      user.userId!,
      status,
    );
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
