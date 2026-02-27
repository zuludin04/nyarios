class DataCall {
  final String token;
  final String name;
  final String chatId;
  final String photo;
  final bool isAcceptCall;
  final Map<Object?, Object?> notificationData;

  DataCall({
    required this.token,
    required this.name,
    required this.chatId,
    required this.photo,
    required this.isAcceptCall,
    this.notificationData = const {},
  });
}
