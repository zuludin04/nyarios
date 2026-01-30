// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentChatProvider)
const recentChatProviderProvider = RecentChatProviderProvider._();

final class RecentChatProviderProvider
    extends
        $StreamNotifierProvider<
          RecentChatProvider,
          QuerySnapshot<Map<String, dynamic>>
        > {
  const RecentChatProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentChatProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentChatProviderHash();

  @$internal
  @override
  RecentChatProvider create() => RecentChatProvider();
}

String _$recentChatProviderHash() =>
    r'7893481b13a30a5c7325ae7728bd75d7c6597431';

abstract class _$RecentChatProvider
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
