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
  late final SharedLocalRepository localRepo;

  @override
  Future<QrCodeProfileState> build() async {
    localRepo = ref.watch(sharedLocalRepositoryProvider);
    profileRepo = ref.watch(profileRepositoryProvider);

    final user = await localRepo.getUserProfile();

    return QrCodeProfileState(userId: user.userId ?? "");
  }

  Future<void> loadProfile(String profileId) async {
    final profile = await profileRepo.loadSingleProfile(profileId);
    state = AsyncData(
      state.value!.copyWith(profile: profile, showProfileDialog: true),
    );
  }

  Future<void> saveChatRoom(String friendUserId) async {
    final myUser = await localRepo.getUserProfile();
    final chatRepo = ref.watch(chatRepositoryProvider);
    final chat = Chat(
      isGroup: false,
      title: '',
      participants: [myUser.userId!, friendUserId],
      createdBy: myUser.userId!,
      createdAt: DateTime.now().toIso8601String(),
      lastMessage: LastMessage(text: '', senderId: '', createdAt: ''),
    );
    final chatId = await chatRepo.createChatRoom(chat, friendUserId);

    state = AsyncData(
      state.value!.copyWith(
        showProfileDialog: false,
        successLoadContact: true,
        chatId: chatId,
      ),
    );
  }
}
