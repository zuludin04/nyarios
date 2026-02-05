import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/message.dart';

class ChattingState {
  final List<Message> messages;
  final Map<String, double> uploadProgress;
  final bool isAlreadyFriend;
  final bool isBlocked;
  final bool isSelectMode;
  final LocalUser? user;

  const ChattingState({
    this.messages = const [],
    this.uploadProgress = const {},
    this.isAlreadyFriend = true,
    this.isBlocked = false,
    this.isSelectMode = false,
    this.user,
  });

  ChattingState copyWith({
    List<Message>? messages,
    Map<String, double>? uploadProgress,
    bool? isAlreadyFriend,
    bool? isBlocked,
    bool? isSelectMode,
    LocalUser? user,
  }) {
    return ChattingState(
      messages: messages ?? this.messages,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isAlreadyFriend: isAlreadyFriend ?? this.isAlreadyFriend,
      isBlocked: isBlocked ?? this.isBlocked,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      user: user ?? this.user,
    );
  }
}
