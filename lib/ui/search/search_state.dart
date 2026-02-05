import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';

class SearchState {
  final List<Message> messageResult;
  final List<Chat> chatResult;
  final String userId;

  const SearchState({
    this.messageResult = const [],
    this.chatResult = const [],
    this.userId = "",
  });

  SearchState copyWith({
    List<Message>? messageResult,
    List<Chat>? chatResult,
    String? userId,
  }) {
    return SearchState(
      messageResult: messageResult ?? this.messageResult,
      chatResult: chatResult ?? this.chatResult,
      userId: userId ?? this.userId,
    );
  }
}
