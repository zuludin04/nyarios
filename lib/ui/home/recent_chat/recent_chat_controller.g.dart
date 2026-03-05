// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentChatController)
const recentChatControllerProvider = RecentChatControllerProvider._();

final class RecentChatControllerProvider
    extends $StreamNotifierProvider<RecentChatController, List<RecentChat>> {
  const RecentChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentChatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentChatControllerHash();

  @$internal
  @override
  RecentChatController create() => RecentChatController();
}

String _$recentChatControllerHash() =>
    r'95b2076a2b71e548ae2161ae9abf201e9330941b';

abstract class _$RecentChatController
    extends $StreamNotifier<List<RecentChat>> {
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
