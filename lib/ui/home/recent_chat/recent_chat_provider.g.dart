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
    extends $StreamNotifierProvider<RecentChatProvider, List<Chat>> {
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
    r'c9f2858109ecbc60a103a2d75ef7ab337623bd60';

abstract class _$RecentChatProvider extends $StreamNotifier<List<Chat>> {
  Stream<List<Chat>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Chat>>, List<Chat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chat>>, List<Chat>>,
              AsyncValue<List<Chat>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
