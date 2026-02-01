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
    extends $AsyncNotifierProvider<BlockedFriendController, List<Contact>> {
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
    r'fae54f094e269ffbe1d78e8b47f8fd0e21d9646a';

abstract class _$BlockedFriendController extends $AsyncNotifier<List<Contact>> {
  FutureOr<List<Contact>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Contact>>, List<Contact>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Contact>>, List<Contact>>,
              AsyncValue<List<Contact>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
