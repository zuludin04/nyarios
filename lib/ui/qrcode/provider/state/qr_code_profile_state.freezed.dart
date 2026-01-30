// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_code_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrCodeProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeProfileState()';
}


}

/// @nodoc
class $QrCodeProfileStateCopyWith<$Res>  {
$QrCodeProfileStateCopyWith(QrCodeProfileState _, $Res Function(QrCodeProfileState) __);
}


/// Adds pattern-matching-related methods to [QrCodeProfileState].
extension QrCodeProfileStatePatterns on QrCodeProfileState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( SuccessLoadProfile value)?  successLoadProfile,TResult Function( SuccessSaveContact value)?  successSaveContact,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case SuccessLoadProfile() when successLoadProfile != null:
return successLoadProfile(_that);case SuccessSaveContact() when successSaveContact != null:
return successSaveContact(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( SuccessLoadProfile value)  successLoadProfile,required TResult Function( SuccessSaveContact value)  successSaveContact,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case SuccessLoadProfile():
return successLoadProfile(_that);case SuccessSaveContact():
return successSaveContact(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( SuccessLoadProfile value)?  successLoadProfile,TResult? Function( SuccessSaveContact value)?  successSaveContact,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case SuccessLoadProfile() when successLoadProfile != null:
return successLoadProfile(_that);case SuccessSaveContact() when successSaveContact != null:
return successSaveContact(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Profile profile)?  successLoadProfile,TResult Function( Contact contact)?  successSaveContact,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case SuccessLoadProfile() when successLoadProfile != null:
return successLoadProfile(_that.profile);case SuccessSaveContact() when successSaveContact != null:
return successSaveContact(_that.contact);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Profile profile)  successLoadProfile,required TResult Function( Contact contact)  successSaveContact,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case Loading():
return loading();case SuccessLoadProfile():
return successLoadProfile(_that.profile);case SuccessSaveContact():
return successSaveContact(_that.contact);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Profile profile)?  successLoadProfile,TResult? Function( Contact contact)?  successSaveContact,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case SuccessLoadProfile() when successLoadProfile != null:
return successLoadProfile(_that.profile);case SuccessSaveContact() when successSaveContact != null:
return successSaveContact(_that.contact);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements QrCodeProfileState {
  const Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeProfileState.initial()';
}


}




/// @nodoc


class Loading implements QrCodeProfileState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeProfileState.loading()';
}


}




/// @nodoc


class SuccessLoadProfile implements QrCodeProfileState {
  const SuccessLoadProfile(this.profile);
  

 final  Profile profile;

/// Create a copy of QrCodeProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessLoadProfileCopyWith<SuccessLoadProfile> get copyWith => _$SuccessLoadProfileCopyWithImpl<SuccessLoadProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessLoadProfile&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'QrCodeProfileState.successLoadProfile(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $SuccessLoadProfileCopyWith<$Res> implements $QrCodeProfileStateCopyWith<$Res> {
  factory $SuccessLoadProfileCopyWith(SuccessLoadProfile value, $Res Function(SuccessLoadProfile) _then) = _$SuccessLoadProfileCopyWithImpl;
@useResult
$Res call({
 Profile profile
});




}
/// @nodoc
class _$SuccessLoadProfileCopyWithImpl<$Res>
    implements $SuccessLoadProfileCopyWith<$Res> {
  _$SuccessLoadProfileCopyWithImpl(this._self, this._then);

  final SuccessLoadProfile _self;
  final $Res Function(SuccessLoadProfile) _then;

/// Create a copy of QrCodeProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(SuccessLoadProfile(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}


}

/// @nodoc


class SuccessSaveContact implements QrCodeProfileState {
  const SuccessSaveContact(this.contact);
  

 final  Contact contact;

/// Create a copy of QrCodeProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessSaveContactCopyWith<SuccessSaveContact> get copyWith => _$SuccessSaveContactCopyWithImpl<SuccessSaveContact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessSaveContact&&(identical(other.contact, contact) || other.contact == contact));
}


@override
int get hashCode => Object.hash(runtimeType,contact);

@override
String toString() {
  return 'QrCodeProfileState.successSaveContact(contact: $contact)';
}


}

/// @nodoc
abstract mixin class $SuccessSaveContactCopyWith<$Res> implements $QrCodeProfileStateCopyWith<$Res> {
  factory $SuccessSaveContactCopyWith(SuccessSaveContact value, $Res Function(SuccessSaveContact) _then) = _$SuccessSaveContactCopyWithImpl;
@useResult
$Res call({
 Contact contact
});




}
/// @nodoc
class _$SuccessSaveContactCopyWithImpl<$Res>
    implements $SuccessSaveContactCopyWith<$Res> {
  _$SuccessSaveContactCopyWithImpl(this._self, this._then);

  final SuccessSaveContact _self;
  final $Res Function(SuccessSaveContact) _then;

/// Create a copy of QrCodeProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contact = null,}) {
  return _then(SuccessSaveContact(
null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as Contact,
  ));
}


}

// dart format on
