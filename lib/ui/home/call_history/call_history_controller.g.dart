// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CallHistoryController)
const callHistoryControllerProvider = CallHistoryControllerProvider._();

final class CallHistoryControllerProvider
    extends $StreamNotifierProvider<CallHistoryController, List<Call>> {
  const CallHistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callHistoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callHistoryControllerHash();

  @$internal
  @override
  CallHistoryController create() => CallHistoryController();
}

String _$callHistoryControllerHash() =>
    r'a3093a6449de26fa1a37b004e9b06cdcc2042710';

abstract class _$CallHistoryController extends $StreamNotifier<List<Call>> {
  Stream<List<Call>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Call>>, List<Call>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Call>>, List<Call>>,
              AsyncValue<List<Call>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
