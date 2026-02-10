import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/recent_chat.dart';

class SearchState {
  final List<Message> messageResult;
  final List<RecentChat> chatResult;

  const SearchState({
    this.messageResult = const [],
    this.chatResult = const [],
  });

  SearchState copyWith({
    List<Message>? messageResult,
    List<RecentChat>? chatResult,
  }) {
    return SearchState(
      messageResult: messageResult ?? this.messageResult,
      chatResult: chatResult ?? this.chatResult,
    );
  }
}
