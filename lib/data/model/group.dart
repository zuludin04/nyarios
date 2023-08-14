class Group {
  String? name;
  String? photo;
  List<String>? members;
  String? chatId;
  String? groupId;
  String? adminId;

  Group({
    this.name,
    this.photo,
    this.members,
    this.chatId,
    this.groupId,
    this.adminId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
      'members': members,
      'chatId': chatId,
      'groupId': groupId,
      'adminId': adminId,
    };
  }

  factory Group.fromJson(Map<String, dynamic> map) {
    return Group(
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      members: List.from(map['members']),
      chatId: map['chatId'] != null ? map['chatId'] as String : null,
      groupId: map['groupId'] != null ? map['groupId'] as String : null,
      adminId: map['adminId'] != null ? map['adminId'] as String : null,
    );
  }
}
