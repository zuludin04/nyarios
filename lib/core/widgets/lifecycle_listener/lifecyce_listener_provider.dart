import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';

final lifecycleListenerWrapperProvider =
    NotifierProvider<AppLifecycleController, void>(AppLifecycleController.new);

class AppLifecycleController extends Notifier<void> {
  @override
  void build() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final user = await localRepo.getUserProfile();
    ref.read(profileRepositoryProvider).updateOnlineStatus(true, user.userId);
  }

  void onPaused() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final user = await localRepo.getUserProfile();
    ref.read(profileRepositoryProvider).updateOnlineStatus(false, user.userId);
  }

  void onResumed() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final user = await localRepo.getUserProfile();
    ref.read(profileRepositoryProvider).updateOnlineStatus(true, user.userId);
  }

  void onInactive() async {
    final localRepo = ref.watch(sharedLocalRepositoryProvider);
    final user = await localRepo.getUserProfile();
    ref.read(profileRepositoryProvider).updateOnlineStatus(false, user.userId);
  }

  void onDetached() {
    // App terminated
  }
}
