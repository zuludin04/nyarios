import 'package:nyarios/domain/model/profile.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsProvider extends _$SettingsProvider {
  @override
  Stream<Profile> build() {
    final repo = ref.watch(profileRepositoryProvider);
    return repo.loadStreamProfile(StorageServices.to.userId);
  }
}
