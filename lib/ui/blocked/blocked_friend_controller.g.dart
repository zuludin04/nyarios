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
    r'96a56ac80085aece9d3a4846b5d23687d138810b';

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
