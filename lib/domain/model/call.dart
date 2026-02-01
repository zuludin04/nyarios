import 'package:nyarios/domain/model/profile.dart';

class Call {
  int? callDate;
  String? callId;
  String? profileId;
  String? status;
  String? type;
  bool? isAccepted;

  Profile? profile;

  Call({
    this.callDate,
    this.callId,
    this.profileId,
    this.status,
    this.type,
    this.isAccepted,
    this.profile,
  });

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callDate: map['callDate'],
      callId: map['callId'],
      profileId: map['profileId'],
      status: map['status'],
      type: map['type'],
      isAccepted: map['isAccepted'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['callDate'] = callDate;
    map['callId'] = callId;
    map['profileId'] = profileId;
    map['status'] = status;
    map['type'] = type;
    map['isAccepted'] = isAccepted;
    return map;
  }
}
