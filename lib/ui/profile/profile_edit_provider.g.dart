// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileEditProvider)
const profileEditProviderProvider = ProfileEditProviderProvider._();

final class ProfileEditProviderProvider
    extends $AsyncNotifierProvider<ProfileEditProvider, ProfileEditState> {
  const ProfileEditProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditProviderHash();

  @$internal
  @override
  ProfileEditProvider create() => ProfileEditProvider();
}

String _$profileEditProviderHash() =>
    r'763cb66f9b02ab88f131ced031ab607c38d43b6f';

abstract class _$ProfileEditProvider extends $AsyncNotifier<ProfileEditState> {
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
