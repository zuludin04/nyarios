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
    r'cbf77a0c8b189cbed747cd5775a8b9a3c2ec14c5';

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
