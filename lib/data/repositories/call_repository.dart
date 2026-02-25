import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/call_remote_source.dart';
import 'package:nyarios/data/sources/remote/post/call_post.dart';
import 'package:nyarios/domain/model/call.dart';
import 'package:uuid/uuid.dart';

class CallRepository {
  final SharedLocalSource localSource;
  final CallRemoteSource remoteSource;

  const CallRepository({required this.localSource, required this.remoteSource});

  Future<String> createCall(
    String type,
    String receiverProfileId,
    String chatId,
  ) async {
    final user = await localSource.getUserProfile();
    final createdAt = DateTime.now().toIso8601String();
    final callId = Uuid().v4();
    final call = CallPost(
      callId: callId,
      chatId: chatId,
      receiverProfileId: receiverProfileId,
      callerProfileId: user.userId!,
      type: type,
      createdAt: createdAt,
    );
    final token = await remoteSource.createCall(call);

    return token;
  }

  Future<void> updateCallStatus(String callId, String status) async {
    final user = await localSource.getUserProfile();
    await remoteSource.updateCallStatus(user.userId!, callId, status, true);
  }

  Stream<List<Call>> streamCallHistories() async* {
    final user = await localSource.getUserProfile();
    yield* remoteSource.loadCallHistory(user.userId);
  }
}
