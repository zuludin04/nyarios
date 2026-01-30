import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_history_provider.g.dart';

@riverpod
class CallHistoryProvider extends _$CallHistoryProvider {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> build() async* {
    final repo = ref.watch(callRepositoryProvider);
    yield* repo.loadCallHistory();
  }
}
