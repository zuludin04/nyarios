import 'last_message.dart';

class Profile {
  String? uid;
  String? name;
  String? photo;
  String? status;
  String? email;
  bool? visibility;

  Profile({
    this.uid,
    this.name,
    this.photo,
    this.status,
    this.email,
    this.visibility,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': uid,
      'name': name,
      'photo': photo,
      'status': status,
      'email': email,
      'visibility': visibility,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      visibility: map['visibility'] != null ? map['visibility'] as bool : null,
    );
  }

  factory Profile.fromContact(LastMessage contact) {
    return Profile(
      uid: contact.receiverId,
      name: contact.name,
      photo: contact.photo,
    );
  }
}
