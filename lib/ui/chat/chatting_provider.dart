import 'dart:async';
import 'dart:io';

import 'package:nyarios/data/repositories/agora_repository.dart';
import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/contact_repository.dart';
import 'package:nyarios/data/repositories/message_repository.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/chat/chatting_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chatting_provider.g.dart';

@riverpod
class ChattingAsyncController extends _$ChattingAsyncController {
  late final MessageRepository messageRepo;
  late final ChatRepository chatRepo;
  late final ContactRepository contactRepo;
  late final AgoraRepository agoraRepo;
  late final SharedLocalRepository localRepo;

  StreamSubscription<List<Message>>? messageSub;

  @override
  FutureOr<ChattingState> build(String roomId, String profileId) async {
    messageRepo = ref.read(messageRepositoryProvider);
    chatRepo = ref.read(chatRepositoryProvider);
    contactRepo = ref.read(contactRepositoryProvider);
    agoraRepo = ref.read(agoraRepositoryProvider);
    localRepo = ref.read(sharedLocalRepositoryProvider);

    state = const AsyncData(ChattingState());

    final user = await localRepo.getUserProfile();
    var contact = await contactRepo.loadSingleContact(profileId, user.userId);

    messageSub = messageRepo.loadChatMessages(roomId).listen((message) {
      final current = state.value!;
      state = AsyncData(
        current.copyWith(
          messages: _mergeWithUploading(current, message),
          isAlreadyFriend: contact?.alreadyFriend,
          isBlocked: contact?.blocked,
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
    String profileId, {
    String url = "",
    String fileSize = "",
  }) async {
    final user = state.value!.user;
    Message newMessage = Message(
      message: message,
      type: type,
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      url: url,
      fileSize: fileSize,
      profileId: user?.userId,
      chatId: chatId,
    );

    Chat chat = Chat(
      profileId: profileId,
      lastMessage: message,
      lastMessageSent: DateTime.now().millisecondsSinceEpoch,
      chatId: chatId,
      type: "dm",
    );

    chatRepo.updateRecentChat(true, chat, user?.userId);
    chatRepo.updateRecentChat(false, chat, user?.userId);

    messageRepo.sendNewMessage(newMessage);
  }

  Future<void> uploadFile(
    File file,
    String path,
    String fileName,
    String chatId,
    String profileId,
    String fileSize,
  ) async {
    final uploadId = const Uuid().v4();
    final user = state.value!.user;

    final uploadingMessage = Message.uploading(
      uploadId: uploadId,
      localFile: file,
      sendDatetime: DateTime.now().millisecondsSinceEpoch,
      userId: user?.userId ?? "",
    );

    state = AsyncData(
      state.value!.copyWith(
        messages: [...state.value!.messages, uploadingMessage],
        uploadProgress: {...state.value!.uploadProgress, uploadId: 0.0},
      ),
    );

    final sub = messageRepo
        .uploadFile(path: path, fileName: fileName, file: file)
        .listen((progress) {
          state = AsyncData(
            state.value!.copyWith(
              uploadProgress: {
                ...state.value!.uploadProgress,
                uploadId: progress,
              },
            ),
          );
        });

    try {
      await sub.asFuture();

      var url = await messageRepo.getImageUrl(path: path, fileName: fileName);
      sendMessage(
        fileName,
        "image",
        chatId,
        profileId,
        url: url,
        fileSize: fileSize,
      );

      state = AsyncData(
        state.value!.copyWith(
          messages: state.value!.messages.where((e) => !e.isUploading).toList(),
          uploadProgress: {...state.value!.uploadProgress..remove(uploadId)},
        ),
      );
    } finally {
      await sub.cancel();
    }
  }

  Future<void> addToContact(String? profileId, String? chatId) async {
    var contact = Contact(
      profileId: profileId,
      chatId: chatId,
      blocked: false,
      alreadyFriend: true,
    );
    final user = state.value!.user;
    await contactRepo.saveContact(contact, profileId, user?.userId);
  }

  Future<void> blockFriend(String? profileId) async {
    final user = state.value!.user;
    await contactRepo.changeBlockStatus(profileId, true, user?.userId);
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
    await messageRepo.messagesBatchDelete(chatId, selectedMessages);
    clearSelectedChat();
  }

  Future<String> generateAgoraToken({
    required String channelName,
    required String uid,
  }) async {
    final token = await agoraRepo.loadAgoraToken(
      channel: channelName,
      uid: uid,
    );
    return token;
  }
}
