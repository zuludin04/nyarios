import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/chat.dart';
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

  Future<void> saveChatRoom(String profileId) async {
    final user = await localRepo.getUserProfile();
    final chatRepo = ref.watch(chatRepositoryProvider);
    final date = DateTime.now();
    final chat = Chat(
      isGroup: false,
      title: '',
      participants: [user.userId!, profileId],
      createdBy: user.userId!,
      createdAt: date.toIso8601String(),
      lastMessage: LastMessage(text: '', senderId: '', createdAt: ''),
    );

    await chatRepo.saveNewChat(chat);

    state = AsyncData(
      state.value!.copyWith(showProfileDialog: false, successLoadContact: true),
    );
  }
}
