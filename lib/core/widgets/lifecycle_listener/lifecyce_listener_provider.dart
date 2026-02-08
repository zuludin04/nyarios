import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';

final lifecycleListenerWrapperProvider =
    NotifierProvider<AppLifecycleController, void>(AppLifecycleController.new);

class AppLifecycleController extends Notifier<void> {
  @override
  void build() async {
    ref.read(profileRepositoryProvider).setOnlineStatus(true);
  }

  void onPaused() async {
    ref.read(profileRepositoryProvider).setOnlineStatus(false);
  }

  void onResumed() async {
    ref.read(profileRepositoryProvider).setOnlineStatus(true);
  }

  void onInactive() async {
    ref.read(profileRepositoryProvider).setOnlineStatus(false);
  }

  void onDetached() {
    // App terminated
  }
}
