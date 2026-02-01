import 'package:nyarios/domain/model/message.dart';

class ContactDetailState {
  final List<Message> mediaMessages;
  final List<Message> docMessages;
  final String? userStatus;
  final bool isOnline;

  const ContactDetailState({
    this.mediaMessages = const [],
    this.docMessages = const [],
    this.userStatus = "-",
    this.isOnline = false,
  });

  ContactDetailState copyWith({
    List<Message>? mediaMessages,
    List<Message>? docMessages,
    String? userStatus,
    bool? isOnline,
  }) {
    return ContactDetailState(
      mediaMessages: mediaMessages ?? this.mediaMessages,
      docMessages: docMessages ?? this.docMessages,
      userStatus: userStatus ?? this.userStatus,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
