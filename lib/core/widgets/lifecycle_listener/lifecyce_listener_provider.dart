import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';

final lifecycleListenerWrapperProvider =
    NotifierProvider<AppLifecycleController, void>(AppLifecycleController.new);

class AppLifecycleController extends Notifier<void> {
  @override
  void build() {
    ref.read(profileRepositoryProvider).updateOnlineStatus(true);
  }

  void onPaused() {
    ref.read(profileRepositoryProvider).updateOnlineStatus(false);
  }

  void onResumed() {
    ref.read(profileRepositoryProvider).updateOnlineStatus(true);
  }

  void onInactive() {
    ref.read(profileRepositoryProvider).updateOnlineStatus(false);
  }

  void onDetached() {
    // App terminated
  }
}
