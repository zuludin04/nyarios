// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactDetailController)
const contactDetailControllerProvider = ContactDetailControllerFamily._();

final class ContactDetailControllerProvider
    extends
        $AsyncNotifierProvider<ContactDetailController, ContactDetailState> {
  const ContactDetailControllerProvider._({
    required ContactDetailControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'contactDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contactDetailControllerHash();

  @override
  String toString() {
    return r'contactDetailControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ContactDetailController create() => ContactDetailController();

  @override
  bool operator ==(Object other) {
    return other is ContactDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contactDetailControllerHash() =>
    r'400ebb443b0272c9fb4c11e2d99c276deae4821a';

final class ContactDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ContactDetailController,
          AsyncValue<ContactDetailState>,
          ContactDetailState,
          FutureOr<ContactDetailState>,
          (String, String)
        > {
  const ContactDetailControllerFamily._()
    : super(
        retry: null,
        name: r'contactDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContactDetailControllerProvider call(String chatId, String profileId) =>
      ContactDetailControllerProvider._(
        argument: (chatId, profileId),
        from: this,
      );

  @override
  String toString() => r'contactDetailControllerProvider';
}

abstract class _$ContactDetailController
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
