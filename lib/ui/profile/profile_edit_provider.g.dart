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
    extends $NotifierProvider<ProfileEditProvider, void> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$profileEditProviderHash() =>
    r'1ccbf79180ad1e7bd5c8e4f541baca2926a4565b';

abstract class _$ProfileEditProvider extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
