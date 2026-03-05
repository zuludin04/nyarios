// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileEditController)
const profileEditControllerProvider = ProfileEditControllerProvider._();

final class ProfileEditControllerProvider
    extends $AsyncNotifierProvider<ProfileEditController, ProfileEditState> {
  const ProfileEditControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditControllerHash();

  @$internal
  @override
  ProfileEditController create() => ProfileEditController();
}

String _$profileEditControllerHash() =>
    r'446fdb0042a13db8ea47a12155c2b5e437c72c87';

abstract class _$ProfileEditController
    extends $AsyncNotifier<ProfileEditState> {
  FutureOr<ProfileEditState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<ProfileEditState>, ProfileEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileEditState>, ProfileEditState>,
              AsyncValue<ProfileEditState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
