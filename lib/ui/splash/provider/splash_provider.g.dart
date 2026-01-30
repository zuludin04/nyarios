// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashProvider)
const splashProviderProvider = SplashProviderFamily._();

final class SplashProviderProvider
    extends $AsyncNotifierProvider<SplashProvider, void> {
  const SplashProviderProvider._({
    required SplashProviderFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'splashProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$splashProviderHash();

  @override
  String toString() {
    return r'splashProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SplashProvider create() => SplashProvider();

  @override
  bool operator ==(Object other) {
    return other is SplashProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$splashProviderHash() => r'819c6a10c2cb786b248208962e2ab3e192aad760';

final class SplashProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          SplashProvider,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          bool
        > {
  const SplashProviderFamily._()
    : super(
        retry: null,
        name: r'splashProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SplashProviderProvider call(bool status) =>
      SplashProviderProvider._(argument: status, from: this);

  @override
  String toString() => r'splashProviderProvider';
}

abstract class _$SplashProvider extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as bool;
  bool get status => _$args;

  FutureOr<void> build(bool status);
  @$mustCallSuper
  @override
  void runBuild() {
    build(_$args);
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
