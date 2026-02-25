import 'dart:async';

import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/chat/chatting_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chatting_provider.g.dart';

@riverpod
class ChattingAsyncController extends _$ChattingAsyncController {
  late final ChatRepository chatRepo;
  late final ContactRepository contactRepo;
  late final SharedLocalRepository localRepo;

  StreamSubscription<List<Message>>? messageSub;

  @override
  FutureOr<ChattingState> build(String? chatId, String? profileId) async {
    chatRepo = ref.read(chatRepositoryProvider);
    contactRepo = ref.read(contactRepositoryProvider);
    localRepo = ref.read(sharedLocalRepositoryProvider);

    state = const AsyncData(ChattingState());

    final user = await localRepo.getUserProfile();
    final contact = await contactRepo.loadSingleContact(profileId);

    messageSub = chatRepo.streamChatMessages(chatId).listen((message) {
      final current = state.value!;
      state = AsyncData(
        current.copyWith(
          messages: _mergeWithUploading(current, message),
          status: contact?.status,
          user: user,
        ),
      );
    });

    ref.onDispose(() {
      messageSub?.cancel();
    });

    return const ChattingState();
  }

  List<Message> _mergeWithUploading(
    ChattingState current,
    List<Message> remote,
  ) {
    final uploading = current.messages.where((m) => m.isUploading).toList();
    return [...remote, ...uploading];
  }

  Future<void> sendMessage(
    String message,
    String type,
    String chatId,
    String ownerUserId,
    String fileSize,
  ) async {
    await chatRepo.sendMessage(
      chatId,
      type,
      message,
      "-",
      ownerUserId,
      fileSize,
    );
  }

  Future<void> changeContactStatus(String? profileId, String status) async {
    await contactRepo.changeContactStatus(profileId, status);
    state = AsyncData(state.value!.copyWith(status: status));
  }

  Future<void> selectMessage(String messageId) async {
    final current = state.value!;
    final selectedMessages = current.messages.map((e) {
      if (e.messageId == messageId) {
        e.isSelected = true;
      }
      return e;
    }).toList();
    state = AsyncData(
      current.copyWith(messages: selectedMessages, isSelectMode: true),
    );
  }

  void clearSelectedChat() {
    final current = state.value!;
    final selectedMessages = current.messages.map((e) {
      e.isSelected = false;
      return e;
    }).toList();
    state = AsyncData(
      current.copyWith(messages: selectedMessages, isSelectMode: false),
    );
  }

  Future<void> clearMessages(String chatId) async {
    final current = state.value!;
    final selectedMessages = current.messages.where((e) {
      return e.isSelected;
    }).toList();
    await chatRepo.deleteMessages(chatId, selectedMessages);
    clearSelectedChat();
  }

  Future<String> createCallConversation({
    required String channelName,
    required String type,
    required String receiverUserId,
  }) async {
    final repo = ref.watch(callRepositoryProvider);
    final token = await repo.createCall(type, receiverUserId, channelName);
    return token;
  }

  String getNameCopy(String messageUserId, String username) {
    final current = state.value!;
    final name = current.user!.userId == messageUserId
        ? username
        : current.user!.userName!;
    return name;
  }
}
