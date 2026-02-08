import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/data/repositories/recent_chat_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/recent_chat.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/qrcode/qr_code_profile_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qr_code_profile_controller.g.dart';

@riverpod
class QrCodeProfileController extends _$QrCodeProfileController {
  late final ProfileRepository profileRepo;
  late final ContactRepository contactRepo;
  late final SharedLocalRepository localRepo;
  late final RecentChatRepository recentChatRepo;

  @override
  Future<QrCodeProfileState> build() async {
    localRepo = ref.watch(sharedLocalRepositoryProvider);
    profileRepo = ref.watch(profileRepositoryProvider);
    contactRepo = ref.watch(contactRepositoryProvider);
    recentChatRepo = ref.watch(recentChatRepositoryProvider);

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
    final profile = state.value!.profile!;
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

    final chatId = await chatRepo.saveNewChat(chat);
    await _saveContact(
      chatId: chatId,
      status: 'pending',
      userId: myUser.userId!,
      docId: friendUserId,
    );
    await _createRecentChat(
      userId: friendUserId,
      chatId: chatId,
      title: myUser.userName!,
      iconUrl: myUser.userImage!,
      profileId: myUser.userId!,
    );

    await _saveContact(
      chatId: chatId,
      status: 'friend',
      userId: friendUserId,
      docId: myUser.userId!,
    );
    await _createRecentChat(
      userId: myUser.userId!,
      chatId: chatId,
      title: profile.name!,
      iconUrl: profile.photo!,
      profileId: profile.uid!,
    );

    state = AsyncData(
      state.value!.copyWith(showProfileDialog: false, successLoadContact: true),
    );
  }

  Future<void> _saveContact({
    required String chatId,
    required String status,
    required String userId,
    required String docId,
  }) async {
    final contact = Contact(
      userId: userId,
      chatId: chatId,
      status: status,
      createdAt: DateTime.now().toIso8601String(),
    );
    await contactRepo.saveContact(docId, contact);
  }

  Future<void> _createRecentChat({
    required String userId,
    required String chatId,
    required String title,
    required String iconUrl,
    required String profileId,
  }) async {
    final recentChat = RecentChat(
      chatId: chatId,
      profileId: profileId,
      isGroup: false,
      title: title,
      iconUrl: iconUrl,
      lastMessage: "",
      lastMessageSenderId: "",
      lastMessageAt: "",
      unreadCount: 0,
    );

    await recentChatRepo.createRecentChat(userId, recentChat);
  }
}
