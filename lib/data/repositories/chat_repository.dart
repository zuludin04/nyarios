import 'package:nyarios/data/sources/firebase/firebase_chat_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final FirebaseChatSource chatSource;
  final SharedLocalSource localSource;

  const ChatRepository({required this.chatSource, required this.localSource});

  Future<String> saveNewChat(Chat chat) async {
    return chatSource.saveNewChat(chat);
  }

  Future<void> sendMessage(
    String chatId,
    String type,
    String text,
    String replyTo,
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
  }

  Stream<List<Message>> streamChatMessages(String? chatId) {
    return chatSource.streamMessages(chatId);
  }

  Future<void> deleteMessages(String chatId, List<Message> messages) async {
    await chatSource.messagesBatchDelete(chatId, messages);
  }
}
