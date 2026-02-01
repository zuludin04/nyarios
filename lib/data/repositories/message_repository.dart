import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nyarios/data/model/message.dart';
import 'package:nyarios/data/model/profile.dart';

class MessageRepository {
  final FirebaseFirestore firestore;

  MessageRepository({required this.firestore});

  void sendNewMessage(Message message) {
    firestore
        .collection('message')
        .doc(message.chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> loadChatMessages(String? roomId) {
    return firestore
        .collection('message')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((e) {
            return Message.fromMapWithMessageId(e.data(), e.id);
          }).toList();
        });
  }

  Stream<double> uploadFile({
    required File file,
    required String path,
    required String fileName,
  }) async* {
    var storage = FirebaseStorage.instance;
    final ref = storage.ref('$path/$fileName');
    final task = ref.putFile(file);

    await for (final event in task.snapshotEvents) {
      yield event.bytesTransferred / event.totalBytes;
    }
  }

  Future<String> getImageUrl({
    required String path,
    required String fileName,
  }) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref('$path/$fileName');
    final url = await ref.getDownloadURL();

    return url;
  }

  Future<List<Message>> loadMessageMedia(String? roomId) async {
    var chats = await firestore
        .collection('message')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs.map((e) => Message.fromMap(e.data())).toList();
  }

  Future<void> messagesBatchDelete(
    String roomId,
    List<Message> chatMessages,
  ) async {
    CollectionReference messages = firestore
        .collection('message')
        .doc(roomId)
        .collection('messages');

    for (var message in chatMessages) {
      messages.doc(message.messageId).delete();
    }
  }

  Future<List<Message>> loadMessages(String? roomId) async {
    var chats = await firestore
        .collection('message')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendDatetime')
        .get();

    return chats.docs
        .map((e) => Message.fromMapWithMessageId(e.data(), e.id))
        .toList();
  }
}
