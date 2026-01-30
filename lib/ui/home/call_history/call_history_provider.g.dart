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
    extends
        $StreamNotifierProvider<
          CallHistoryProvider,
          QuerySnapshot<Map<String, dynamic>>
        > {
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
    r'968556e62deef5f9c9a07a4cb0008d3fadb3453f';

abstract class _$CallHistoryProvider
    extends $StreamNotifier<QuerySnapshot<Map<String, dynamic>>> {
  Stream<QuerySnapshot<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<QuerySnapshot<Map<String, dynamic>>>,
              QuerySnapshot<Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<QuerySnapshot<Map<String, dynamic>>>,
                QuerySnapshot<Map<String, dynamic>>
              >,
              AsyncValue<QuerySnapshot<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
