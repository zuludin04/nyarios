import 'package:nyarios/services/storage_services.dart';

class LastMessage {
  String? profileImage;
  String? profileName;
  String? profileId;
  String? lastMessage;
  int? lastMessageSent;
  bool? blocked;
  bool? alreadyFriend;
  String? chatId;
  String? type;

  LastMessage({
    this.profileImage,
    this.profileName,
    this.profileId,
    this.lastMessage,
    this.lastMessageSent,
    this.blocked,
    this.alreadyFriend,
    this.chatId,
    this.type,
  });

  Map<String, dynamic> toMap(bool fromSender) {
    return <String, dynamic>{
      'profileImage': fromSender ? profileImage : StorageServices.to.userImage,
      'profileName': fromSender ? profileName : StorageServices.to.userName,
      'profileId': fromSender ? profileId : StorageServices.to.userId,
      'lastMessage': lastMessage,
      'lastMessageSent': lastMessageSent,
      'blocked': blocked,
      'alreadyFriend': alreadyFriend,
      'chatId': chatId,
      'type': type,
    };
  }

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      profileName:
          map['profileName'] != null ? map['profileName'] as String : null,
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageSent:
          map['lastMessageSent'] != null ? map['lastMessageSent'] as int : null,
      blocked: map['blocked'] != null ? map['blocked'] as bool : null,
      alreadyFriend:
          map['alreadyFriend'] != null ? map['alreadyFriend'] as bool : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }
}
