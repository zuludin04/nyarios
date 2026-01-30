import 'package:flutter_riverpod/legacy.dart';
import 'package:nyarios/domain/providers/repository_providers.dart';
import 'package:nyarios/ui/qrcode/provider/state/qr_code_profile_notifier.dart';
import 'package:nyarios/ui/qrcode/provider/state/qr_code_profile_state.dart';

final qrCodeProfileNotifierProvider =
    StateNotifierProvider<QrCodeProfileNotifier, QrCodeProfileState>((ref) {
      final profileRepo = ref.watch(profileRepositoryProvider);
      final contactRepo = ref.watch(contactRepositoryProvider);
      return QrCodeProfileNotifier(
        profileRepo: profileRepo,
        contactRepo: contactRepo,
      );
    });
