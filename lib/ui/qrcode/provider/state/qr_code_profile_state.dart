import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/profile.dart';

part 'qr_code_profile_state.freezed.dart';

@freezed
class QrCodeProfileState with _$QrCodeProfileState {
  const factory QrCodeProfileState.initial() = Initial;
  const factory QrCodeProfileState.loading() = Loading;
  const factory QrCodeProfileState.successLoadProfile(Profile profile) =
      SuccessLoadProfile;
  const factory QrCodeProfileState.successSaveContact(Contact contact) =
      SuccessSaveContact;
}
