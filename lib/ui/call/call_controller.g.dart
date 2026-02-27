// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CallController)
const callControllerProvider = CallControllerFamily._();

final class CallControllerProvider
    extends $AsyncNotifierProvider<CallController, void> {
  const CallControllerProvider._({
    required CallControllerFamily super.from,
    required DataCall super.argument,
  }) : super(
         retry: null,
         name: r'callControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$callControllerHash();

  @override
  String toString() {
    return r'callControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CallController create() => CallController();

  @override
  bool operator ==(Object other) {
    return other is CallControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$callControllerHash() => r'298e4e1e1dc05f72c78674436459df6f08c621ef';

final class CallControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CallController,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          DataCall
        > {
  const CallControllerFamily._()
    : super(
        retry: null,
        name: r'callControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CallControllerProvider call(DataCall call) =>
      CallControllerProvider._(argument: call, from: this);

  @override
  String toString() => r'callControllerProvider';
}

abstract class _$CallController extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as DataCall;
  DataCall get call => _$args;

  FutureOr<void> build(DataCall call);
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
