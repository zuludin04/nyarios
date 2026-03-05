// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignInController)
const signInControllerProvider = SignInControllerProvider._();

final class SignInControllerProvider
    extends $AsyncNotifierProvider<SignInController, SignInState> {
  const SignInControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInControllerHash();

  @$internal
  @override
  SignInController create() => SignInController();
}

String _$signInControllerHash() => r'a6ed0e6817390696f0d8a1eb8a4b16a1e5d39190';

abstract class _$SignInController extends $AsyncNotifier<SignInState> {
  FutureOr<SignInState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SignInState>, SignInState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SignInState>, SignInState>,
              AsyncValue<SignInState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
