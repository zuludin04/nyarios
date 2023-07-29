import 'package:nyarios/data/model/profile.dart';

class LastMessage {
  String? message;
  String? receiverId;
  int? sendDatetime;
  String? roomId;
  Profile? profile;

  LastMessage({
    this.message,
    this.receiverId,
    this.sendDatetime,
    this.profile,
    this.roomId,
  });
}
