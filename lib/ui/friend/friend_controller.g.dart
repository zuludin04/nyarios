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

String _$friendControllerHash() => r'51b3265e2d76b7299c5abc0c54dc98f21482c8b2';

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
