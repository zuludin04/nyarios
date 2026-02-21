class DataChat {
  final String chatId;
  final String profileId;
  final String username;
  final String photo;

  DataChat({
    required this.chatId,
    required this.profileId,
    required this.username,
    required this.photo,
  });

  factory DataChat.fromMap(Map<String, dynamic> map) {
    return DataChat(
      chatId: map['chatId'],
      profileId: map['profileId'],
      username: map['name'],
      photo: map['photo'],
    );
  }
}
