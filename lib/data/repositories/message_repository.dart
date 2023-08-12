import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/message.dart';

class MessageRepository {
  final CollectionReference messageReference =
      FirebaseFirestore.instance.collection('message');

  void sendNewMessage(Message message) {
    messageReference.add(message.toMap());
  }
}
