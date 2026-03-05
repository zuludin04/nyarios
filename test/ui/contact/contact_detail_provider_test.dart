import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/chat_repository.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';
import 'package:nyarios/domain/model/message.dart';
import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/contact/contact_detail_provider.dart';
import 'package:nyarios/ui/contact/contact_detail_state.dart';

import 'contact_detail_provider_test.mocks.dart';

@GenerateMocks([ProfileRepository, ChatRepository])
void main() {
  late MockProfileRepository mockProfileRepo;
  late MockChatRepository mockChatRepo;
  late ProviderContainer container;

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    mockChatRepo = MockChatRepository();
    container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(mockProfileRepo),
        chatRepositoryProvider.overrideWithValue(mockChatRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ContactDetailProvider', () {
    test('build should initialize state and listen to online status', () async {
      final chatId = 'c1';
      final profileId = 'p1';
      final profile = Profile(uid: profileId, name: 'Contact');
      final messages = [
        Message(
          messageId: '1',
          chatId: chatId,
          senderProfileId: profileId,
          type: 'image',
          text: 'img_url',
          createdAt: '',
          fileSize: '0',
          replyToMessageId: '',
        ),
        Message(
          messageId: '2',
          chatId: chatId,
          senderProfileId: profileId,
          type: 'file',
          text: 'file_url',
          createdAt: '',
          fileSize: '0',
          replyToMessageId: '',
        ),
      ];

      when(mockChatRepo.loadMessages(chatId)).thenAnswer((_) async => messages);
      when(mockProfileRepo.loadSingleProfile(profileId))
          .thenAnswer((_) async => profile);
      when(mockProfileRepo.getOnlineStatus(profileId))
          .thenAnswer((_) => Stream.value(true));

      // Use a listener to capture state updates
      final states = <AsyncValue<ContactDetailState>>[];
      final subscription = container.listen(
        contactDetailProviderProvider(chatId, profileId),
        (previous, next) {
          states.add(next);
        },
        fireImmediately: true,
      );

      // Wait for the provider to finish its build and emit the first state
      await container.read(contactDetailProviderProvider(chatId, profileId).future);
      
      // Wait a bit more for the stream update to propagate
      await Future.delayed(Duration.zero);

      final state = container.read(contactDetailProviderProvider(chatId, profileId)).requireValue;

      expect(state.profile, profile);
      expect(state.mediaMessages.length, 1);
      expect(state.docMessages.length, 1);
      expect(state.isOnline, true);

      subscription.close();
    });
  });
}
