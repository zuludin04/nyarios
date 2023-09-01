import 'package:nyarios/data/model/profile.dart';

class Notification {
  String? callerName;
  String? callerImage;
  String? callerUid;
  Profile? profile;
  int? callingTime;
  String? type;
  String? callId;

  Notification({
    this.callerName,
    this.callerImage,
    this.callerUid,
    this.profile,
    this.callingTime,
    this.type,
    this.callId,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      callerName: map['callerName'],
      callerImage: map['callerImage'],
      callerUid: map['callerUid'],
      profile: Profile.fromMap(map['profile']),
      callingTime: map['callingTime'],
      type: map['type'],
      callId: map['callId'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['callerImage'] = callerImage;
    map['callerName'] = callerName;
    map['callerUid'] = callerUid;
    map['profile'] = profile!.toMap();
    map['callingTime'] = callingTime;
    map['type'] = type;
    map['callId'] = callId;
    return map;
  }
}
