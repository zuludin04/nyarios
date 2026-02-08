import 'package:flutter_riverpod/legacy.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/auth/provider/state/signin_notifier.dart';
import 'package:nyarios/ui/auth/provider/state/signin_state.dart';

final signInNotifierProvider =
    StateNotifierProvider<SignInNotifier, SignInState>((ref) {
      final profileRepo = ref.watch(profileRepositoryProvider);
      return SignInNotifier(profileRepo: profileRepo);
    });
