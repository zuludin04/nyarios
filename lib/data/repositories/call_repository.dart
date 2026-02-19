import 'package:nyarios/data/sources/firebase/firebase_call_source.dart';
import 'package:nyarios/data/sources/firebase/firebase_profile_source.dart';
import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:nyarios/data/sources/remote/agora_remote_source.dart';
import 'package:nyarios/data/sources/remote/notification_remote_source.dart';
import 'package:nyarios/domain/model/call.dart';
import 'package:uuid/uuid.dart';

class CallRepository {
  final FirebaseCallSource callSource;
  final SharedLocalSource localSource;
  final AgoraRemoteSource agoraSource;
  final FirebaseProfileSource profileSource;
  final NotificationRemoteSource notificationSource;

  const CallRepository({
    required this.callSource,
    required this.localSource,
    required this.agoraSource,
    required this.profileSource,
    required this.notificationSource,
  });

  Future<String> createCall(
    String channel,
    String type,
    String receiverUserId,
    String chatId,
  ) async {
    final token = await agoraSource.loadAgoraToken(channel: channel);

    final user = await localSource.getUserProfile();
    final createdAt = DateTime.now().toIso8601String();
    final callId = Uuid().v4();
    final receiverProfile = await profileSource.loadSingleProfile(
      receiverUserId,
    );

    final callerHistory = Call(
      callId: callId,
      username: receiverProfile!.name!,
      image: receiverProfile.photo!,
      type: type,
      status: 'outgoing',
      createdAt: createdAt,
    );
    await callSource.saveCallHistory(user.userId, callerHistory);

    final receiverHistory = Call(
      callId: callId,
      username: user.userName!,
      image: user.userImage!,
      type: type,
      status: 'incoming',
      createdAt: createdAt,
    );
    await callSource.saveCallHistory(receiverUserId, receiverHistory);
    await notificationSource.sendCallNotification(
      userId: receiverUserId,
      name: user.userName ?? "",
      image: user.userImage ?? "",
      type: type,
      chatId: chatId,
      agoraToken: token,
    );

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
