import 'package:nyarios/data/model/last_message.dart';

import 'profile.dart';

class Contact {
  String? profileId;
  String? chatId;
  bool? blocked;
  bool? alreadyFriend;

  Profile? profile;

  Contact({
    this.profileId,
    this.chatId,
    this.blocked,
    this.alreadyFriend,
    this.profile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': profileId,
      'chatId': chatId,
      'blocked': blocked,
      'alreadyFriend': alreadyFriend,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map, Profile profile) {
    return Contact(
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      alreadyFriend:
          map['alreadyFriend'] != null ? map['alreadyFriend'] as bool : null,
      blocked: map['blocked'] != null ? map['blocked'] as bool : null,
      profile: profile,
    );
  }

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      alreadyFriend:
      map['alreadyFriend'] != null ? map['alreadyFriend'] as bool : null,
      blocked: map['blocked'] != null ? map['blocked'] as bool : null,
    );
  }

  factory Contact.fromLastMessage(LastMessage message) {
    return Contact(
      profileId: message.profileId,
      chatId: message.chatId,
      profile: message.profile,
    );
  }
}
