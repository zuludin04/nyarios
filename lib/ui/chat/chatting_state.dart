import 'package:nyarios/domain/model/local_user.dart';
import 'package:nyarios/domain/model/message.dart';

class ChattingState {
  final List<Message> messages;
  final Map<String, double> uploadProgress;
  final String status;
  final bool isSelectMode;
  final LocalUser? user;

  const ChattingState({
    this.messages = const [],
    this.uploadProgress = const {},
    this.status = 'pending',
    this.isSelectMode = false,
    this.user,
  });

  ChattingState copyWith({
    List<Message>? messages,
    Map<String, double>? uploadProgress,
    String? status,
    bool? isSelectMode,
    LocalUser? user,
  }) {
    return ChattingState(
      messages: messages ?? this.messages,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      status: status ?? this.status,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      user: user ?? this.user,
    );
  }
}
