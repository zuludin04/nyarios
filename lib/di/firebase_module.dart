import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firestoreProvider(Ref ref) {
  return FirebaseFirestore.instance;
}
