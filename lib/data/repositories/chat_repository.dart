import 'package:nyarios/data/sources/firebase/firebase_chat_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/chat_remote_source.dart';
import 'package:nyarios/data/sources/remote/notification_remote_source.dart';
import 'package:nyarios/data/sources/remote/post/chat_room_post.dart';
import 'package:nyarios/data/sources/remote/post/message_post.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final FirebaseChatSource chatSource;
  final SharedLocalSource localSource;
  final NotificationRemoteSource notificationSource;
  final FirebaseProfileSource profileSource;
  final ChatRemoteSource remoteSource;

  const ChatRepository({
    required this.chatSource,
    required this.localSource,
    required this.notificationSource,
    required this.profileSource,
    required this.remoteSource,
  });

  Future<String> saveNewChat(Chat chat) async {
    return chatSource.saveNewChat(chat);
  }

  Future<String> createChatRoom(Chat chat, String receiverProfileId) async {
    try {
      final chatPost = ChatRoomPost(
        isGroup: chat.isGroup,
        title: chat.title,
        participants: chat.participants,
        createdAt: chat.createdAt,
        senderProfileId: chat.createdBy,
        receiverProfileId: receiverProfileId,
      );

      final chatId = await remoteSource.createChatRoom(chatPost);
      return chatId;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(
    String chatId,
    String type,
    String text,
    String replyTo,
    String receiverProfileId,
    String fileSize,
  ) async {
    final user = await localSource.getUserProfile();
    final messageId = const Uuid().v4();
    final message = MessagePost(
      messageId: messageId,
      chatId: chatId,
      senderProfileId: user.userId ?? "",
      type: type,
      text: text,
      replyToMessageId: replyTo,
      createdAt: DateTime.now().toIso8601String(),
      fileSize: fileSize,
      receiverProfileId: receiverProfileId,
    );
    await remoteSource.sendMessage(message);
  }

  Stream<List<Message>> streamChatMessages(String? chatId) {
    return chatSource.streamMessages(chatId);
  }

  Future<void> deleteMessages(String chatId, List<Message> messages) async {
    await chatSource.messagesBatchDelete(chatId, messages);
  }

  Future<Chat> getChatDetail(String chatId) async {
    return chatSource.loadChatDetail(chatId);
  }

  Future<List<Message>> loadMessages(String chatId) async {
    return chatSource.loadChatMessages(chatId);
  }
}
