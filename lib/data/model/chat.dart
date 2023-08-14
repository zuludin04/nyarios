import 'package:nyarios/services/storage_services.dart';

import 'group.dart';
import 'profile.dart';

class Chat {
  String? profileId;
  String? lastMessage;
  int? lastMessageSent;
  String? chatId;
  String? type;

  Profile? profile;
  Group? group;

  Chat({
    this.profileId,
    this.lastMessage,
    this.lastMessageSent,
    this.chatId,
    this.type,
    this.profile,
    this.group,
  });

  Map<String, dynamic> toMap(bool fromSender) {
    return <String, dynamic>{
      'profileId': fromSender ? profileId : StorageServices.to.userId,
      'lastMessage': lastMessage,
      'lastMessageSent': lastMessageSent,
      'chatId': chatId,
      'type': type,
    };
  }

  Map<String, dynamic> toMapGroup() {
    return <String, dynamic>{
      'profileId': profileId,
      'lastMessage': lastMessage,
      'lastMessageSent': lastMessageSent,
      'chatId': chatId,
      'type': type,
    };
  }

  factory Chat.fromMapProfile(Map<String, dynamic> map, Profile profile) {
    return Chat(
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageSent:
          map['lastMessageSent'] != null ? map['lastMessageSent'] as int : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      profile: profile,
    );
  }

  factory Chat.fromMapGroup(Map<String, dynamic> map, Group group) {
    return Chat(
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageSent:
          map['lastMessageSent'] != null ? map['lastMessageSent'] as int : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      group: group,
    );
  }
}
