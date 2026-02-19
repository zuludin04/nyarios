import 'package:nyarios/data/sources/firebase/firebase_chat_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/notification_remote_source.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final FirebaseChatSource chatSource;
  final SharedLocalSource localSource;
  final NotificationRemoteSource notificationSource;
  final FirebaseProfileSource profileSource;

  const ChatRepository({
    required this.chatSource,
    required this.localSource,
    required this.notificationSource,
    required this.profileSource,
  });

  Future<String> saveNewChat(Chat chat) async {
    return chatSource.saveNewChat(chat);
  }

  Future<void> sendMessage(
    String chatId,
    String type,
    String text,
    String replyTo,
    String receiverUserId,
  ) async {
    final user = await localSource.getUserProfile();
    final messageId = const Uuid().v4();
    final message = Message(
      messageId: messageId,
      chatId: chatId,
      senderProfileId: user.userId ?? "",
      type: type,
      text: text,
      replyToMessageId: replyTo,
      createdAt: DateTime.now().toIso8601String(),
    );
    await chatSource.sendChatMessage(message);

    final profile = await profileSource.loadSingleProfile(receiverUserId);

    await notificationSource.sendMessageNotification(
      uid: receiverUserId,
      name: profile!.name!,
      image: profile.photo!,
      chatId: chatId,
    );
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
