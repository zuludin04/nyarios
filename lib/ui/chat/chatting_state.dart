import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/message.dart';

class ChattingState {
  final List<Message> messages;
  final String status;
  final bool isSelectMode;
  final LocalUser? user;

  const ChattingState({
    this.messages = const [],
    this.status = 'pending',
    this.isSelectMode = false,
    this.user,
  });

  ChattingState copyWith({
    List<Message>? messages,
    String? status,
    bool? isSelectMode,
    LocalUser? user,
  }) {
    return ChattingState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      user: user ?? this.user,
    );
  }
}
