import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/di/dio_module.dart';
import 'package:nyarios/domain/model/contact.dart';
import 'package:nyarios/domain/model/profile.dart';

final contactRemoteSourceProvider = Provider<ContactRemoteSource>((ref) {
  final dio = dioProvider(ref);
  return ContactRemoteSource(dio: dio);
});

class ContactRemoteSource {
  final Dio dio;

  const ContactRemoteSource({required this.dio});

  Future<List<Profile>> getContactByStatus(
    String profileId,
    String status,
  ) async {
    try {
      final response = await dio.get(
        "contact/list",
        queryParameters: {"profileId": profileId, "status": status},
      );
      List results = response.data["data"];
      List<Profile> profiles = results
          .map((e) => Profile.fromContact(e))
          .toList();
      return profiles;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Contact> getContactDetail(
    String ownerProfileId,
    String contactProfileId,
  ) async {
    try {
      final response = await dio.get(
        "contact",
        queryParameters: {
          "ownerProfileId": ownerProfileId,
          "contactProfileId": contactProfileId,
        },
      );
      Contact contact = Contact.fromMap(response.data["data"]);
      return contact;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> updateContactStatus(
    String ownerProfileId,
    String contactProfileId,
    String status,
  ) async {
    try {
      final response = await dio.post(
        "contact/update-status",
        data: {
          "ownerProfileId": ownerProfileId,
          "contactProfileId": contactProfileId,
          "status": status,
        },
      );
      return response.data["success"];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
