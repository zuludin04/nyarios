import 'package:nyarios/domain/model/data_call.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_controller.g.dart';

@riverpod
class CallController extends _$CallController {
  @override
  Future<void> build(DataCall call) async {}

  Future<void> updateCallStatus(DataCall call) async {
    if (call.isAcceptCall) {
      final callController = ref.watch(callRepositoryProvider);
      await callController.updateCallStatus(
        call.notificationData['callId'].toString(),
        call.notificationData['callerProfileId'].toString(),
      );
    }
  }
}
