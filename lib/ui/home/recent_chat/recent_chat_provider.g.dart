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
    extends $StreamNotifierProvider<RecentChatProvider, List<RecentChat>> {
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
    r'8cb29977a4a30bb9ddeb0b3f030a9c78609d6373';

abstract class _$RecentChatProvider extends $StreamNotifier<List<RecentChat>> {
  Stream<List<RecentChat>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<RecentChat>>, List<RecentChat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<RecentChat>>, List<RecentChat>>,
              AsyncValue<List<RecentChat>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
