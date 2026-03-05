import 'dart:async';

import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/contact/contact_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_detail_provider.g.dart';

@riverpod
class ContactDetailProvider extends _$ContactDetailProvider {
  StreamSubscription<bool>? onlineStatusSub;

  @override
  FutureOr<ContactDetailState> build(String chatId, String profileId) async {
    final profileRepo = ref.read(profileRepositoryProvider);
    final chatRepo = ref.read(chatRepositoryProvider);

    final chats = await chatRepo.loadMessages(chatId);
    final media = chats.where((e) => e.type == "image").toList();
    final doc = chats.where((e) => e.type == "file").toList();

    final profile = await profileRepo.loadSingleProfile(profileId);

    onlineStatusSub = profileRepo.getOnlineStatus(profileId).listen((isOnline) {
      if (state.hasValue) {
        state = AsyncData(
          state.value!.copyWith(
            profile: profile,
            mediaMessages: media,
            docMessages: doc,
            isOnline: isOnline,
          ),
        );
      }
    });

    ref.onDispose(() {
      onlineStatusSub?.cancel();
    });

    return ContactDetailState(
      profile: profile,
      mediaMessages: media,
      docMessages: doc,
    );
  }
}
