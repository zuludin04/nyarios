// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_friend_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlockedFriendController)
const blockedFriendControllerProvider = BlockedFriendControllerProvider._();

final class BlockedFriendControllerProvider
    extends $AsyncNotifierProvider<BlockedFriendController, List<Profile>> {
  const BlockedFriendControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedFriendControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedFriendControllerHash();

  @$internal
  @override
  BlockedFriendController create() => BlockedFriendController();
}

String _$blockedFriendControllerHash() =>
    r'db1f7a70d06c1cc1f7ff4d5a2a7a3fa72e00b2d5';

abstract class _$BlockedFriendController extends $AsyncNotifier<List<Profile>> {
  FutureOr<List<Profile>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Profile>>, List<Profile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Profile>>, List<Profile>>,
              AsyncValue<List<Profile>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
