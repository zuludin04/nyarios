// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendController)
const friendControllerProvider = FriendControllerProvider._();

final class FriendControllerProvider
    extends $AsyncNotifierProvider<FriendController, List<Profile>> {
  const FriendControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendControllerHash();

  @$internal
  @override
  FriendController create() => FriendController();
}

String _$friendControllerHash() => r'3b9d8f6ecd39a9f968651b3990ff5e0a8e128989';

abstract class _$FriendController extends $AsyncNotifier<List<Profile>> {
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
