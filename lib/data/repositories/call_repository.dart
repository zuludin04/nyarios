import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/domain/model/call.dart';
import 'package:nyarios/services/storage_services.dart';

class CallRepository {
  final FirebaseFirestore firestore;

  CallRepository({required this.firestore});

  Future<void> saveCallHistory(String profileId, Call call) async {
    await firestore
        .collection('call')
        .doc(profileId)
        .collection('history')
        .doc(call.callId)
        .set(call.toMap());
  }

  Future<void> updateCallStatus(
    String profileId,
    String callId,
    bool isAccepted,
  ) async {
    await firestore
        .collection('call')
        .doc(profileId)
        .collection('history')
        .doc(callId)
        .update({'isAccepted': isAccepted});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadCallHistory() async* {
    yield* firestore
        .collection('call')
        .doc(StorageServices.to.userId)
        .collection('history')
        .orderBy('callDate', descending: true)
        .snapshots();
  }
}
