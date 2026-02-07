class Contact {
  final String userId;
  final String chatId;
  final String status;
  final String createdAt;

  Contact({
    required this.userId,
    required this.chatId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': userId,
      'chatId': chatId,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      userId: map['profileId'],
      chatId: map['chatId'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }
}
