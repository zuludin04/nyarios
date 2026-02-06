import 'package:nyarios/data/repositories/shared_local_repository.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_controller.g.dart';

@riverpod
class LanguageController extends _$LanguageController {
  late final SharedLocalRepository localRepo;
  @override
  Future<String> build() async {
    localRepo = ref.watch(sharedLocalRepositoryProvider);
    final language = await localRepo.gelectedLanguage();
    return language;
  }

  Future<void> changeLanguage(String code) async {
    state = AsyncData(code);
    await localRepo.setLanguage(code);
  }
}
