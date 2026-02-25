import 'package:nyarios/data/sources/firebase/firebase_call_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/agora_remote_source.dart';
import 'package:nyarios/data/sources/remote/call_remote_source.dart';
import 'package:nyarios/data/sources/remote/notification_remote_source.dart';
import 'package:nyarios/data/sources/remote/post/call_post.dart';
import 'package:nyarios/domain/model/call.dart';
import 'package:uuid/uuid.dart';

class CallRepository {
  final FirebaseCallSource callSource;
  final SharedLocalSource localSource;
  final AgoraRemoteSource agoraSource;
  final FirebaseProfileSource profileSource;
  final NotificationRemoteSource notificationSource;
  final CallRemoteSource remoteSource;

  const CallRepository({
    required this.callSource,
    required this.localSource,
    required this.agoraSource,
    required this.profileSource,
    required this.notificationSource,
    required this.remoteSource,
  });

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
    print("call data ${call.toMap()}");
    final token = await remoteSource.createCall(call);

    return token;
  }

  Future<void> updateCallStatus(String callId, String status) async {
    final user = await localSource.getUserProfile();
    await callSource.updateCallStatus(user.userId, callId, status);
  }

  Stream<List<Call>> streamCallHistories() async* {
    final user = await localSource.getUserProfile();
    yield* callSource.loadCallHistory(user.userId);
  }
}
