// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'contact.dart';

class Profile {
  String? uid;
  String? name;
  String? photo;
  String? roomId;
  bool? block;
  String? status;

  Profile({
    this.uid,
    this.name,
    this.photo,
    this.roomId,
    this.block,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': uid,
      'name': name,
      'photo': photo,
      'roomId': roomId,
      'block': block,
      'status': status,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      roomId: map['roomId'] != null ? map['roomId'] as String : null,
      block: map['block'] != null ? map['block'] as bool : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  factory Profile.fromContact(Contact contact) {
    return Profile(
      uid: contact.receiverId,
      name: contact.name,
      roomId: contact.roomId,
      photo: contact.photo,
      block: contact.block,
    );
  }
}
