import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/qrcode/qr_code_profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qr_code_profile_controller.g.dart';

@riverpod
class QrCodeProfileController extends _$QrCodeProfileController {
  late final ProfileRepository profileRepo;
  late final ContactRepository contactRepo;
  late final SharedLocalRepository localRepo;

  @override
  Future<QrCodeProfileState> build() async {
    localRepo = ref.watch(sharedLocalRepositoryProvider);
    profileRepo = ref.watch(profileRepositoryProvider);
    contactRepo = ref.watch(contactRepositoryProvider);

    final user = await localRepo.getUserProfile();

    return QrCodeProfileState(userId: user.userId ?? "");
  }

  Future<void> loadProfile(String profileId) async {
    final profile = await profileRepo.loadSingleProfile(profileId);
    state = AsyncData(
      state.value!.copyWith(profile: profile, showProfileDialog: true),
    );
  }

  Future<void> saveContact(String profileId, String roomId) async {
    final user = await localRepo.getUserProfile();

    var contact = Contact(
      profileId: profileId,
      alreadyFriend: true,
      blocked: false,
      chatId: roomId,
    );
    await contactRepo.saveContact(contact, profileId, user.userId);
    await contactRepo.saveContact(contact, profileId, user.userId);

    state = AsyncData(
      state.value!.copyWith(
        contact: contact,
        showProfileDialog: false,
        successLoadContact: true,
      ),
    );
  }
}
