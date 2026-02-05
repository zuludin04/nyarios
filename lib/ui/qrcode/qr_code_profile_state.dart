import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/profile.dart';

class QrCodeProfileState {
  final String userId;
  final Profile? profile;
  final Contact? contact;
  final bool showProfileDialog;
  final bool successLoadContact;

  QrCodeProfileState({
    this.userId = "",
    this.contact,
    this.profile,
    this.showProfileDialog = false,
    this.successLoadContact = false,
  });

  QrCodeProfileState copyWith({
    String? userId,
    Profile? profile,
    Contact? contact,
    bool? showProfileDialog,
    bool? successLoadContact,
  }) {
    return QrCodeProfileState(
      userId: userId ?? this.userId,
      contact: contact ?? this.contact,
      profile: profile ?? this.profile,
      showProfileDialog: showProfileDialog ?? this.showProfileDialog,
      successLoadContact: successLoadContact ?? this.successLoadContact,
    );
  }
}
