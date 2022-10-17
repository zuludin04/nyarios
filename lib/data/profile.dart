class Profile {
  String? uid;
  String? name;
  String? photo;
  String? roomId;

  Profile({
    this.uid,
    this.name,
    this.photo,
    this.roomId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': uid,
      'name': name,
      'photo': photo,
      'roomId': roomId,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
    );
  }
}
