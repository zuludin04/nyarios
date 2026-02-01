import 'package:flutter_riverpod/legacy.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/ui/qrcode/provider/state/qr_code_profile_state.dart';

class QrCodeProfileNotifier extends StateNotifier<QrCodeProfileState> {
  final ProfileRepository profileRepo;
  final ContactRepository contactRepo;

  QrCodeProfileNotifier({required this.profileRepo, required this.contactRepo})
    : super(const QrCodeProfileState.initial());

  Future<void> loadProfile(String profileId) async {
    final profile = await profileRepo.loadSingleProfile(profileId);
    state = QrCodeProfileState.successLoadProfile(profile);
  }

  Future<void> saveContact(String profileId, String roomId) async {
    var contact = Contact(
      profileId: profileId,
      alreadyFriend: true,
      blocked: false,
      chatId: roomId,
    );
    contactRepo.saveContact(contact, profileId);
    await contactRepo.saveContact(contact, profileId);
    state = QrCodeProfileState.successSaveContact(contact);
  }
}
