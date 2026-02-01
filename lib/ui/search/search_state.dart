import 'package:nyarios/domain/model/chat.dart';
import 'package:nyarios/domain/model/message.dart';

class SearchState {
  final List<Message> messageResult;
  final List<Chat> chatResult;

  const SearchState({
    this.messageResult = const [],
    this.chatResult = const [],
  });

  SearchState copyWith({List<Message>? messageResult, List<Chat>? chatResult}) {
    return SearchState(
      messageResult: messageResult ?? this.messageResult,
      chatResult: chatResult ?? this.chatResult,
    );
  }
}
