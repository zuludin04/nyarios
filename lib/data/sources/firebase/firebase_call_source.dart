import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/firebase_module.dart';
import 'package:nyarios/domain/model/call.dart';

final firebaseCallSourceProvider = Provider<FirebaseCallSource>((ref) {
  final firestore = firestoreProvider(ref);
  return FirebaseCallSource(firestore: firestore);
});

class FirebaseCallSource {
  final FirebaseFirestore firestore;

  const FirebaseCallSource({required this.firestore});

  Future<void> saveCallHistory(String? userId, Call call) async {
    await firestore
        .collection('recentChat')
        .doc(userId)
        .collection('calls')
        .doc(call.callId)
        .set(call.toMap());
  }

  Future<void> updateCallStatus(
    String? userId,
    String callId,
    String status,
  ) async {
    await firestore
        .collection('recentChat')
        .doc(userId)
        .collection('calls')
        .doc(callId)
        .update({'status': status});
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
