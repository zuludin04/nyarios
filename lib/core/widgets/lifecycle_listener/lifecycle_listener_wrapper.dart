import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/widgets/lifecycle_listener/lifecyce_listener_provider.dart';

class LifecycleListnerWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const LifecycleListnerWrapper({super.key, required this.child});

  @override
  ConsumerState<LifecycleListnerWrapper> createState() =>
      _AppLifecycleListenerState();
}

class _AppLifecycleListenerState extends ConsumerState<LifecycleListnerWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lifecycleListenerWrapperProvider.notifier).onResumed();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(lifecycleListenerWrapperProvider.notifier);

    switch (state) {
      case AppLifecycleState.resumed:
        notifier.onResumed();
        break;
      case AppLifecycleState.paused:
        notifier.onPaused();
        break;
      case AppLifecycleState.inactive:
        notifier.onInactive();
        break;
      case AppLifecycleState.detached:
        notifier.onDetached();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
