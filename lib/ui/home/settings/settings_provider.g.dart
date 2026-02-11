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
    extends $AsyncNotifierProvider<SettingsProvider, SettingsState> {
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

String _$settingsProviderHash() => r'4668e8a4d2e551a83b956dfb999fb91d160879c3';

abstract class _$SettingsProvider extends $AsyncNotifier<SettingsState> {
  FutureOr<SettingsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SettingsState>, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SettingsState>, SettingsState>,
              AsyncValue<SettingsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
