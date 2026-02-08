// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsProvider)
const settingsProviderProvider = SettingsProviderProvider._();

final class SettingsProviderProvider
    extends $StreamNotifierProvider<SettingsProvider, Profile> {
  const SettingsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsProviderHash();

  @$internal
  @override
  SettingsProvider create() => SettingsProvider();
}

String _$settingsProviderHash() => r'84c249430a433a12529cda23722cab638efa3c07';

abstract class _$SettingsProvider extends $StreamNotifier<Profile> {
  Stream<Profile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Profile>, Profile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Profile>, Profile>,
              AsyncValue<Profile>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
