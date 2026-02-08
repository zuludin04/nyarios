// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatting_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChattingAsyncController)
const chattingAsyncControllerProvider = ChattingAsyncControllerFamily._();

final class ChattingAsyncControllerProvider
    extends $AsyncNotifierProvider<ChattingAsyncController, ChattingState> {
  const ChattingAsyncControllerProvider._({
    required ChattingAsyncControllerFamily super.from,
    required (String?, String?) super.argument,
  }) : super(
         retry: null,
         name: r'chattingAsyncControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chattingAsyncControllerHash();

  @override
  String toString() {
    return r'chattingAsyncControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ChattingAsyncController create() => ChattingAsyncController();

  @override
  bool operator ==(Object other) {
    return other is ChattingAsyncControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chattingAsyncControllerHash() =>
    r'8d1210f62dcd9c691cd97b3fff2260599e4768be';

final class ChattingAsyncControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ChattingAsyncController,
          AsyncValue<ChattingState>,
          ChattingState,
          FutureOr<ChattingState>,
          (String?, String?)
        > {
  const ChattingAsyncControllerFamily._()
    : super(
        retry: null,
        name: r'chattingAsyncControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChattingAsyncControllerProvider call(String? chatId, String? profileId) =>
      ChattingAsyncControllerProvider._(
        argument: (chatId, profileId),
        from: this,
      );

  @override
  String toString() => r'chattingAsyncControllerProvider';
}

abstract class _$ChattingAsyncController extends $AsyncNotifier<ChattingState> {
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
