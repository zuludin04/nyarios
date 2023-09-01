import 'package:nyarios/data/model/profile.dart';

class Notification {
  Profile? profile;
  int? callingTime;
  String? type;
  String? callId;
  String? chatId;

  Notification({
    this.profile,
    this.callingTime,
    this.type,
    this.callId,
    this.chatId,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      profile: Profile.fromMap(map['profile']),
      callingTime: map['callingTime'],
      type: map['type'],
      callId: map['callId'],
      chatId: map['chatId'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['profile'] = profile!.toMap();
    map['callingTime'] = callingTime;
    map['type'] = type;
    map['callId'] = callId;
    map['chatId'] = chatId;
    return map;
  }
}
