import 'package:nyarios/domain/model/profile.dart';

class QrCodeProfileState {
  final String userId;
  final String chatId;
  final Profile? profile;
  final bool showProfileDialog;
  final bool successLoadContact;

  QrCodeProfileState({
    this.userId = "",
    this.chatId = "",
    this.profile,
    this.showProfileDialog = false,
    this.successLoadContact = false,
  });

  QrCodeProfileState copyWith({
    String? userId,
    String? chatId,
    Profile? profile,
    bool? showProfileDialog,
    bool? successLoadContact,
  }) {
    return QrCodeProfileState(
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      profile: profile ?? this.profile,
      showProfileDialog: showProfileDialog ?? this.showProfileDialog,
      successLoadContact: successLoadContact ?? this.successLoadContact,
    );
  }
}
