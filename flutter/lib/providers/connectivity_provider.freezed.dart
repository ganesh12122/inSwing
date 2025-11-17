// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connectivity_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConnectivityState {
  bool get isConnected => throw _privateConstructorUsedError;
  connectivity_plus.ConnectivityResult get connectionType =>
      throw _privateConstructorUsedError;

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectivityStateCopyWith<ConnectivityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectivityStateCopyWith<$Res> {
  factory $ConnectivityStateCopyWith(
          ConnectivityState value, $Res Function(ConnectivityState) then) =
      _$ConnectivityStateCopyWithImpl<$Res, ConnectivityState>;
  @useResult
  $Res call(
      {bool isConnected, connectivity_plus.ConnectivityResult connectionType});
}

/// @nodoc
class _$ConnectivityStateCopyWithImpl<$Res, $Val extends ConnectivityState>
    implements $ConnectivityStateCopyWith<$Res> {
  _$ConnectivityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConnected = null,
    Object? connectionType = null,
  }) {
    return _then(_value.copyWith(
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionType: null == connectionType
          ? _value.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as connectivity_plus.ConnectivityResult,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectivityStateImplCopyWith<$Res>
    implements $ConnectivityStateCopyWith<$Res> {
  factory _$$ConnectivityStateImplCopyWith(_$ConnectivityStateImpl value,
          $Res Function(_$ConnectivityStateImpl) then) =
      __$$ConnectivityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isConnected, connectivity_plus.ConnectivityResult connectionType});
}

/// @nodoc
class __$$ConnectivityStateImplCopyWithImpl<$Res>
    extends _$ConnectivityStateCopyWithImpl<$Res, _$ConnectivityStateImpl>
    implements _$$ConnectivityStateImplCopyWith<$Res> {
  __$$ConnectivityStateImplCopyWithImpl(_$ConnectivityStateImpl _value,
      $Res Function(_$ConnectivityStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConnected = null,
    Object? connectionType = null,
  }) {
    return _then(_$ConnectivityStateImpl(
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionType: null == connectionType
          ? _value.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as connectivity_plus.ConnectivityResult,
    ));
  }
}

/// @nodoc

class _$ConnectivityStateImpl implements _ConnectivityState {
  const _$ConnectivityStateImpl(
      {this.isConnected = true,
      this.connectionType = connectivity_plus.ConnectivityResult.wifi});

  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final connectivity_plus.ConnectivityResult connectionType;

  @override
  String toString() {
    return 'ConnectivityState(isConnected: $isConnected, connectionType: $connectionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectivityStateImpl &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isConnected, connectionType);

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectivityStateImplCopyWith<_$ConnectivityStateImpl> get copyWith =>
      __$$ConnectivityStateImplCopyWithImpl<_$ConnectivityStateImpl>(
          this, _$identity);
}

abstract class _ConnectivityState implements ConnectivityState {
  const factory _ConnectivityState(
          {final bool isConnected,
          final connectivity_plus.ConnectivityResult connectionType}) =
      _$ConnectivityStateImpl;

  @override
  bool get isConnected;
  @override
  connectivity_plus.ConnectivityResult get connectionType;

  /// Create a copy of ConnectivityState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectivityStateImplCopyWith<_$ConnectivityStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
