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
    extends $AsyncNotifierProvider<FriendController, List<Contact>> {
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

String _$friendControllerHash() => r'2118dcce2bbf31031893eb8bbc7a4ea6fa379868';

abstract class _$FriendController extends $AsyncNotifier<List<Contact>> {
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
