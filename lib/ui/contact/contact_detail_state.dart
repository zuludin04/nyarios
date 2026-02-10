import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/profile.dart';

class ContactDetailState {
  final List<Message> mediaMessages;
  final List<Message> docMessages;
  final Profile? profile;
  final bool isOnline;

  const ContactDetailState({
    this.mediaMessages = const [],
    this.docMessages = const [],
    this.profile,
    this.isOnline = false,
  });

  ContactDetailState copyWith({
    List<Message>? mediaMessages,
    List<Message>? docMessages,
    Profile? profile,
    bool? isOnline,
  }) {
    return ContactDetailState(
      mediaMessages: mediaMessages ?? this.mediaMessages,
      docMessages: docMessages ?? this.docMessages,
      isOnline: isOnline ?? this.isOnline,
      profile: profile ?? this.profile,
    );
  }
}
