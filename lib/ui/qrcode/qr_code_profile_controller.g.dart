// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QrCodeProfileController)
const qrCodeProfileControllerProvider = QrCodeProfileControllerProvider._();

final class QrCodeProfileControllerProvider
    extends
        $AsyncNotifierProvider<QrCodeProfileController, QrCodeProfileState> {
  const QrCodeProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qrCodeProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qrCodeProfileControllerHash();

  @$internal
  @override
  QrCodeProfileController create() => QrCodeProfileController();
}

String _$qrCodeProfileControllerHash() =>
    r'c1dfbb1ae0175afc608a9c11307e3237e6696852';

abstract class _$QrCodeProfileController
    extends $AsyncNotifier<QrCodeProfileState> {
  FutureOr<QrCodeProfileState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<QrCodeProfileState>, QrCodeProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QrCodeProfileState>, QrCodeProfileState>,
              AsyncValue<QrCodeProfileState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
