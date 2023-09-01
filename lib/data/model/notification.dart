import 'package:nyarios/data/model/profile.dart';

class Notification {
  String? callerName;
  String? callerImage;
  Profile? profile;
  int? callingTime;
  String? type;

  Notification({
    this.callerName,
    this.callerImage,
    this.profile,
    this.callingTime,
    this.type,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      callerName: map['callerName'],
      callerImage: map['callerImage'],
      profile: Profile.fromMap(map['profile']),
      callingTime: map['callingTime'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['callerImage'] = callerImage;
    map['callerName'] = callerName;
    map['profile'] = profile!.toMap();
    map['callingTime'] = callingTime;
    map['type'] = type;
    return map;
  }
}
