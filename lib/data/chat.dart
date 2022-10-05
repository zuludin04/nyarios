class Chat {
  String? message;
  String? time;
  int? status;
  bool? received;
  String? type;

  Chat({
    this.message,
    this.time,
    this.status,
    this.received,
    required this.type,
  });
}
