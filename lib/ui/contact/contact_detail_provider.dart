import 'dart:async';

import 'package:nyarios/ui/contact/contact_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_detail_provider.g.dart';

@riverpod
class ContactDetailProvider extends _$ContactDetailProvider {
  StreamSubscription<bool>? onlineStatusSub;

  @override
  FutureOr<ContactDetailState> build(String chatId, String profileId) async {
    // final messageRepo = ref.watch(messageRepositoryProvider);
    // final profileRepo = ref.watch(profileRepositoryProvider);

    // state = const AsyncData(ContactDetailState());

    // final chats = await messageRepo.loadMessageMedia(chatId);
    // final media = chats.where((e) => e.type == "image").toList();
    // final doc = chats.where((e) => e.type == "file").toList();

    // final profile = await profileRepo.loadSingleProfile(profileId);

    // onlineStatusSub = profileRepo.getOnlineStatus().listen((isOnline) {
    //   final current = state.value!;
    //   state = AsyncData(
    //     current.copyWith(
    //       userStatus: profile.status,
    //       mediaMessages: media,
    //       docMessages: doc,
    //       isOnline: isOnline,
    //     ),
    //   );
    // });

    return const ContactDetailState();
  }
}
