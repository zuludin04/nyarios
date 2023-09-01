import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/data/model/call.dart';
import 'package:nyarios/services/storage_services.dart';

class CallRepository {
  final CollectionReference callReference =
      FirebaseFirestore.instance.collection('call');

  Future<void> saveCallHistory(String profileId, Call call) async {
    await callReference
        .doc(profileId)
        .collection('history')
        .doc(call.callId)
        .set(call.toMap());
  }

  Future<void> updateCallStatus(Call call, String status) async {
    await callReference
        .doc(call.profileId)
        .collection('history')
        .doc(call.callId)
        .update({'status': status});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadCallHistory() async* {
    yield* callReference
        .doc(StorageServices.to.userId)
        .collection('history')
        .orderBy('callDate', descending: true)
        .snapshots();
  }
}
