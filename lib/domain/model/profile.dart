class Profile {
  int? id;
  String? uid;
  String? name;
  String? photo;
  String? status;
  String? email;
  bool? visibility;
  String? fcmToken;

  Profile({
    this.id,
    this.uid,
    this.name,
    this.photo,
    this.status,
    this.email,
    this.visibility,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'name': name,
      'photo': photo,
      'status': status,
      'email': email,
      'visibility': visibility,
      'fcmToken': fcmToken,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] != null ? map['id'] as int : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      visibility: map['visibility'] != null ? map['visibility'] as bool : null,
    );
  }
}
