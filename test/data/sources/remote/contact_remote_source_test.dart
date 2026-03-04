import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nyarios/data/sources/remote/contact_remote_source.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/profile.dart';

import 'contact_remote_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late ContactRemoteSource contactRemoteSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    contactRemoteSource = ContactRemoteSource(dio: mockDio);
  });

  group('getContactByStatus', () {
    test('should return List<Profile> when successful', () async {
      final profilesData = [
        {'uid': '1', 'name': 'User 1', 'email': 'u1@test.com'},
      ];
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: {'data': profilesData},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await contactRemoteSource.getContactByStatus(
        'p1',
        'friend',
      );

      expect(result, isA<List<Profile>>());
      expect(result.length, 1);
      expect(result[0].uid, '1');
    });

    test('should throw Exception on Dio error', () async {
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(
        () => contactRemoteSource.getContactByStatus('p1', 'friend'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getContactDetail', () {
    test('should return Contact when successful', () async {
      final contactData = {
        'profileId': 'o1',
        'chatId': 'c1',
        'status': 'friend',
        'createdAt': '2023-10-27T10:00:00Z',
      };
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response(
          data: {'data': contactData},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await contactRemoteSource.getContactDetail('o1', 'c1');

      expect(result, isA<Contact>());
      expect(result.chatId, 'c1');
    });
  });

  group('updateContactStatus', () {
    test('should return success boolean when successful', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await contactRemoteSource.updateContactStatus(
        'o1',
        'c1',
        'blocked',
      );

      expect(result, true);
    });
  });
}
