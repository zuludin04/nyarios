// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactDetailProvider)
const contactDetailProviderProvider = ContactDetailProviderFamily._();

final class ContactDetailProviderProvider
    extends $AsyncNotifierProvider<ContactDetailProvider, ContactDetailState> {
  const ContactDetailProviderProvider._({
    required ContactDetailProviderFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'contactDetailProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contactDetailProviderHash();

  @override
  String toString() {
    return r'contactDetailProviderProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ContactDetailProvider create() => ContactDetailProvider();

  @override
  bool operator ==(Object other) {
    return other is ContactDetailProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contactDetailProviderHash() =>
    r'f160e959a77d3128173fe6a2e45549fb363fd922';

final class ContactDetailProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          ContactDetailProvider,
          AsyncValue<ContactDetailState>,
          ContactDetailState,
          FutureOr<ContactDetailState>,
          (String, String)
        > {
  const ContactDetailProviderFamily._()
    : super(
        retry: null,
        name: r'contactDetailProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContactDetailProviderProvider call(String chatId, String profileId) =>
      ContactDetailProviderProvider._(
        argument: (chatId, profileId),
        from: this,
      );

  @override
  String toString() => r'contactDetailProviderProvider';
}

abstract class _$ContactDetailProvider
    extends $AsyncNotifier<ContactDetailState> {
  late final _$args = ref.$arg as (String, String);
  String get chatId => _$args.$1;
  String get profileId => _$args.$2;

  FutureOr<ContactDetailState> build(String chatId, String profileId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref as $Ref<AsyncValue<ContactDetailState>, ContactDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ContactDetailState>, ContactDetailState>,
              AsyncValue<ContactDetailState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
