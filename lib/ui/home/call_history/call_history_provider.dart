import 'package:nyarios/domain/model/call.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_history_provider.g.dart';

@riverpod
class CallHistoryProvider extends _$CallHistoryProvider {
  @override
  Stream<List<Call>> build() async* {
    final callRepo = ref.watch(callRepositoryProvider);
    yield* callRepo.streamCallHistories();
  }
}
