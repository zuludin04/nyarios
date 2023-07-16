import 'package:nyarios/data/model/friend.dart';
import 'package:nyarios/data/model/profile.dart';

class LastMessage {
  String? message;
  String? receiverId;
  int? sendDatetime;
  Profile? profile;
  Friend? friend;

  LastMessage({
    this.message,
    this.receiverId,
    this.sendDatetime,
    this.profile,
    this.friend,
  });
}
