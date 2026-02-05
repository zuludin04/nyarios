// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CallHistoryProvider)
const callHistoryProviderProvider = CallHistoryProviderProvider._();

final class CallHistoryProviderProvider
    extends $StreamNotifierProvider<CallHistoryProvider, List<Call>> {
  const CallHistoryProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callHistoryProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callHistoryProviderHash();

  @$internal
  @override
  CallHistoryProvider create() => CallHistoryProvider();
}

String _$callHistoryProviderHash() =>
    r'2e7397dc6542264b4219a04402cc999e8810a20d';

abstract class _$CallHistoryProvider extends $StreamNotifier<List<Call>> {
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
