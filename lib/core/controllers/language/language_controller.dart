import 'package:nyarios/data/sources/local/shared_local_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_controller.g.dart';

@riverpod
class LanguageController extends _$LanguageController {
  late final SharedLocalSource localRepo;

  @override
  Future<String> build() async {
    localRepo = ref.watch(sharedLocalSourceProvider);
    final language = await localRepo.gelectedLanguage();
    return language;
  }

  Future<void> changeLanguage(String code) async {
    state = AsyncData(code);
    await localRepo.setLanguage(code);
  }
}
