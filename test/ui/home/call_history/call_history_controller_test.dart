import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/domain/model/call.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/home/call_history/call_history_controller.dart';

import 'call_history_controller_test.mocks.dart';

@GenerateMocks([CallRepository])
void main() {
  late MockCallRepository mockCallRepo;
  late ProviderContainer container;

  setUp(() {
    mockCallRepo = MockCallRepository();
    container = ProviderContainer(
      overrides: [callRepositoryProvider.overrideWithValue(mockCallRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CallHistoryAsyncController', () {
    test('build should stream call history from repository', () async {
      final callHistories = [
        Call(
          callId: '1',
          username: 'zuludin',
          image: 'http://image.com',
          type: 'voice_call',
          status: 'incoming',
          createdAt: '2023-10-27T10:00:00Z',
        ),
      ];

      when(
        mockCallRepo.streamCallHistories(),
      ).thenAnswer((_) => Stream.value(callHistories));

      // Use listen to keep the provider alive during the test
      final subscription = container.listen(
        callHistoryControllerProvider,
        (previous, next) {},
      );

      final result = await container.read(callHistoryControllerProvider.future);

      expect(result, callHistories);
      verify(mockCallRepo.streamCallHistories()).called(1);

      subscription.close();
    });
  });
}
