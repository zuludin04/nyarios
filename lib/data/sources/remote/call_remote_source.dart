import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/data/sources/remote/post/call_post.dart';
import 'package:nyarios/di/dio_module.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/call.dart';

final callRemoteSourceProvider = Provider<CallRemoteSource>((ref) {
  final dio = dioProvider(ref);
  final firestore = firestoreProvider(ref);
  return CallRemoteSource(dio: dio, firestore: firestore);
});

class CallRemoteSource {
  final Dio dio;
  final FirebaseFirestore firestore;

  const CallRemoteSource({required this.dio, required this.firestore});

  Future<String> createCall(CallPost call) async {
    try {
      final response = await dio.post("call/create-call", data: call.toMap());
      return response.data["data"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> updateCallStatus(
    String callId,
    String receiverProfileId,
    String callerProfileId,
    bool isPickup,
  ) async {
    try {
      final response = await dio.post(
        "call/update-status",
        data: {
          "callId": callId,
          "receiverProfileId": receiverProfileId,
          "callerProfileId": callerProfileId,
          "isPickup": isPickup,
        },
      );
      return response.data["success"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Call>> loadCallHistory(String? userId) async* {
    yield* firestore
        .collection('recentChat')
        .doc(userId)
        .collection('calls')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Call.fromMap(doc.data())).toList(),
        );
  }
}
