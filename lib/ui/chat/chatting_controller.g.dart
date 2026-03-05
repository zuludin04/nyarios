// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatting_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChattingController)
const chattingControllerProvider = ChattingControllerFamily._();

final class ChattingControllerProvider
    extends $AsyncNotifierProvider<ChattingController, ChattingState> {
  const ChattingControllerProvider._({
    required ChattingControllerFamily super.from,
    required (String?, String?) super.argument,
  }) : super(
         retry: null,
         name: r'chattingControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chattingControllerHash();

  @override
  String toString() {
    return r'chattingControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ChattingController create() => ChattingController();

  @override
  bool operator ==(Object other) {
    return other is ChattingControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chattingControllerHash() =>
    r'dbbc8ab02cdfa5e8287ff183324f45248c0a6692';

final class ChattingControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChattingController,
          AsyncValue<ChattingState>,
          ChattingState,
          FutureOr<ChattingState>,
          (String?, String?)
        > {
  const ChattingControllerFamily._()
    : super(
        retry: null,
        name: r'chattingControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChattingControllerProvider call(String? chatId, String? profileId) =>
      ChattingControllerProvider._(argument: (chatId, profileId), from: this);

  @override
  String toString() => r'chattingControllerProvider';
}

abstract class _$ChattingController extends $AsyncNotifier<ChattingState> {
  late final _$args = ref.$arg as (String?, String?);
  String? get chatId => _$args.$1;
  String? get profileId => _$args.$2;

  FutureOr<ChattingState> build(String? chatId, String? profileId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<ChattingState>, ChattingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChattingState>, ChattingState>,
              AsyncValue<ChattingState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
