class Contact {
  String? profileImage;
  String? profileName;
  String? profileStatus;
  String? profileId;
  String? chatId;
  bool? blocked;
  bool? alreadyFriend;

  Contact({
    this.profileImage,
    this.profileName,
    this.profileStatus,
    this.profileId,
    this.chatId,
    this.blocked,
    this.alreadyFriend,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileImage': profileImage,
      'profileName': profileName,
      'profileStatus': profileStatus,
      'profileId': profileId,
      'chatId': chatId,
      'blocked': blocked,
      'alreadyFriend': alreadyFriend,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      profileName:
          map['profileName'] != null ? map['profileName'] as String : null,
      profileStatus:
          map['profileStatus'] != null ? map['profileStatus'] as String : null,
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      alreadyFriend:
          map['alreadyFriend'] != null ? map['alreadyFriend'] as bool : null,
      blocked: map['blocked'] != null ? map['blocked'] as bool : null,
    );
  }
}
