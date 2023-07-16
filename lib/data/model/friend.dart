class Friend {
  bool? alreadyAdded;
  bool? blocked;
  String? profileId;
  String? roomId;

  Friend({this.alreadyAdded, this.blocked, this.profileId, this.roomId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': profileId,
      'blocked': blocked,
      'alreadyAdded': alreadyAdded,
      'roomId': roomId,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      profileId: map['profileId'] != null ? map['profileId'] as String : null,
      alreadyAdded:
          map['alreadyAdded'] != null ? map['alreadyAdded'] as bool : null,
      blocked: map['blocked'] != null ? map['blocked'] as bool : null,
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
    );
  }
}
