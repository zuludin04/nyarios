import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/repositories/call_repository.dart';
import 'package:nyarios/domain/model/data_call.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/call/call_controller.dart';

import 'call_controller_test.mocks.dart';

@GenerateMocks([CallRepository])
void main() {
  late MockCallRepository mockCallRepo;
  late ProviderContainer container;

  setUp(() {
    mockCallRepo = MockCallRepository();
    container = ProviderContainer(
      overrides: [
        callRepositoryProvider.overrideWithValue(mockCallRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CallController', () {
    test('updateCallStatus should call repository when call is accepted', () async {
      final dataCall = DataCall(
        token: 'token123',
        name: 'Caller',
        chatId: 'chat1',
        photo: '',
        isAcceptCall: true,
        notificationData: {
          'callId': 'c123',
          'callerProfileId': 'cp456',
        },
      );

      when(mockCallRepo.updateCallStatus('c123', 'cp456'))
          .thenAnswer((_) async => {});

      final controller = container.read(callControllerProvider(dataCall).notifier);
      await controller.updateCallStatus(dataCall);

      verify(mockCallRepo.updateCallStatus('c123', 'cp456')).called(1);
    });

    test('updateCallStatus should not call repository when call is not accepted',
        () async {
      final dataCall = DataCall(
        token: 'token123',
        name: 'Caller',
        chatId: 'chat1',
        photo: '',
        isAcceptCall: false,
      );

      final controller = container.read(callControllerProvider(dataCall).notifier);
      await controller.updateCallStatus(dataCall);

      verifyNever(mockCallRepo.updateCallStatus(any, any));
    });
  });
}
