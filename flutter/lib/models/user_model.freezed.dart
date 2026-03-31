// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String? phoneNumber,
      String? fullName,
      String? email,
      String? avatarUrl,
      String? bio,
      String role,
      bool isActive,
      bool isVerified,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? phoneNumber,
      String? fullName,
      String? email,
      String? avatarUrl,
      String? bio,
      String role,
      bool isActive,
      bool isVerified,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phoneNumber = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? bio = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      this.phoneNumber,
      this.fullName,
      this.email,
      this.avatarUrl,
      this.bio,
      this.role = 'player',
      this.isActive = true,
      this.isVerified = false,
      required this.createdAt,
      required this.updatedAt});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String? phoneNumber;
  @override
  final String? fullName;
  @override
  final String? email;
  @override
  final String? avatarUrl;
  @override
  final String? bio;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'User(id: $id, phoneNumber: $phoneNumber, fullName: $fullName, email: $email, avatarUrl: $avatarUrl, bio: $bio, role: $role, isActive: $isActive, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, phoneNumber, fullName, email,
      avatarUrl, bio, role, isActive, isVerified, createdAt, updatedAt);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      final String? phoneNumber,
      final String? fullName,
      final String? email,
      final String? avatarUrl,
      final String? bio,
      final String role,
      final bool isActive,
      final bool isVerified,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String? get phoneNumber;
  @override
  String? get fullName;
  @override
  String? get email;
  @override
  String? get avatarUrl;
  @override
  String? get bio;
  @override
  String get role;
  @override
  bool get isActive;
  @override
  bool get isVerified;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get primaryRole => throw _privateConstructorUsedError;
  double get overallRating => throw _privateConstructorUsedError;
  String get playerLevel => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  DateTime get joinDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? email,
      String? avatarUrl,
      String primaryRole,
      double overallRating,
      String playerLevel,
      String? city,
      String? state,
      DateTime joinDate,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? primaryRole = null,
    Object? overallRating = null,
    Object? playerLevel = null,
    Object? city = freezed,
    Object? state = freezed,
    Object? joinDate = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryRole: null == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      playerLevel: null == playerLevel
          ? _value.playerLevel
          : playerLevel // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? email,
      String? avatarUrl,
      String primaryRole,
      double overallRating,
      String playerLevel,
      String? city,
      String? state,
      DateTime joinDate,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? primaryRole = null,
    Object? overallRating = null,
    Object? playerLevel = null,
    Object? city = freezed,
    Object? state = freezed,
    Object? joinDate = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryRole: null == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      playerLevel: null == playerLevel
          ? _value.playerLevel
          : playerLevel // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.email,
      this.avatarUrl,
      this.primaryRole = 'batsman',
      this.overallRating = 0,
      this.playerLevel = 'Beginner',
      this.city,
      this.state,
      required this.joinDate,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final String primaryRole;
  @override
  @JsonKey()
  final double overallRating;
  @override
  @JsonKey()
  final String playerLevel;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final DateTime joinDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, userId: $userId, name: $name, email: $email, avatarUrl: $avatarUrl, primaryRole: $primaryRole, overallRating: $overallRating, playerLevel: $playerLevel, city: $city, state: $state, joinDate: $joinDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.primaryRole, primaryRole) ||
                other.primaryRole == primaryRole) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            (identical(other.playerLevel, playerLevel) ||
                other.playerLevel == playerLevel) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      email,
      avatarUrl,
      primaryRole,
      overallRating,
      playerLevel,
      city,
      state,
      joinDate,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String userId,
      required final String name,
      final String? email,
      final String? avatarUrl,
      final String primaryRole,
      final double overallRating,
      final String playerLevel,
      final String? city,
      final String? state,
      required final DateTime joinDate,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get avatarUrl;
  @override
  String get primaryRole;
  @override
  double get overallRating;
  @override
  String get playerLevel;
  @override
  String? get city;
  @override
  String? get state;
  @override
  DateTime get joinDate;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) {
  return _PlayerStats.fromJson(json);
}

/// @nodoc
mixin _$PlayerStats {
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get primaryRole => throw _privateConstructorUsedError;
  double get overallRating => throw _privateConstructorUsedError;
  String get playerLevel => throw _privateConstructorUsedError;
  String get joinDate => throw _privateConstructorUsedError;
  String get debutDate => throw _privateConstructorUsedError;
  int get totalMatches => throw _privateConstructorUsedError;
  BattingStats get battingStats => throw _privateConstructorUsedError;
  BowlingStats get bowlingStats => throw _privateConstructorUsedError;
  FieldingStats get fieldingStats => throw _privateConstructorUsedError;
  List<MatchPerformance> get recentMatches =>
      throw _privateConstructorUsedError;
  String? get firstCenturyDate => throw _privateConstructorUsedError;
  String? get firstFiftyDate => throw _privateConstructorUsedError;
  String? get firstFiveWicketDate => throw _privateConstructorUsedError;

  /// Serializes this PlayerStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStatsCopyWith<PlayerStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatsCopyWith<$Res> {
  factory $PlayerStatsCopyWith(
          PlayerStats value, $Res Function(PlayerStats) then) =
      _$PlayerStatsCopyWithImpl<$Res, PlayerStats>;
  @useResult
  $Res call(
      {String playerId,
      String playerName,
      String primaryRole,
      double overallRating,
      String playerLevel,
      String joinDate,
      String debutDate,
      int totalMatches,
      BattingStats battingStats,
      BowlingStats bowlingStats,
      FieldingStats fieldingStats,
      List<MatchPerformance> recentMatches,
      String? firstCenturyDate,
      String? firstFiftyDate,
      String? firstFiveWicketDate});

  $BattingStatsCopyWith<$Res> get battingStats;
  $BowlingStatsCopyWith<$Res> get bowlingStats;
  $FieldingStatsCopyWith<$Res> get fieldingStats;
}

/// @nodoc
class _$PlayerStatsCopyWithImpl<$Res, $Val extends PlayerStats>
    implements $PlayerStatsCopyWith<$Res> {
  _$PlayerStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? primaryRole = null,
    Object? overallRating = null,
    Object? playerLevel = null,
    Object? joinDate = null,
    Object? debutDate = null,
    Object? totalMatches = null,
    Object? battingStats = null,
    Object? bowlingStats = null,
    Object? fieldingStats = null,
    Object? recentMatches = null,
    Object? firstCenturyDate = freezed,
    Object? firstFiftyDate = freezed,
    Object? firstFiveWicketDate = freezed,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      primaryRole: null == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      playerLevel: null == playerLevel
          ? _value.playerLevel
          : playerLevel // ignore: cast_nullable_to_non_nullable
              as String,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as String,
      debutDate: null == debutDate
          ? _value.debutDate
          : debutDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalMatches: null == totalMatches
          ? _value.totalMatches
          : totalMatches // ignore: cast_nullable_to_non_nullable
              as int,
      battingStats: null == battingStats
          ? _value.battingStats
          : battingStats // ignore: cast_nullable_to_non_nullable
              as BattingStats,
      bowlingStats: null == bowlingStats
          ? _value.bowlingStats
          : bowlingStats // ignore: cast_nullable_to_non_nullable
              as BowlingStats,
      fieldingStats: null == fieldingStats
          ? _value.fieldingStats
          : fieldingStats // ignore: cast_nullable_to_non_nullable
              as FieldingStats,
      recentMatches: null == recentMatches
          ? _value.recentMatches
          : recentMatches // ignore: cast_nullable_to_non_nullable
              as List<MatchPerformance>,
      firstCenturyDate: freezed == firstCenturyDate
          ? _value.firstCenturyDate
          : firstCenturyDate // ignore: cast_nullable_to_non_nullable
              as String?,
      firstFiftyDate: freezed == firstFiftyDate
          ? _value.firstFiftyDate
          : firstFiftyDate // ignore: cast_nullable_to_non_nullable
              as String?,
      firstFiveWicketDate: freezed == firstFiveWicketDate
          ? _value.firstFiveWicketDate
          : firstFiveWicketDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BattingStatsCopyWith<$Res> get battingStats {
    return $BattingStatsCopyWith<$Res>(_value.battingStats, (value) {
      return _then(_value.copyWith(battingStats: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BowlingStatsCopyWith<$Res> get bowlingStats {
    return $BowlingStatsCopyWith<$Res>(_value.bowlingStats, (value) {
      return _then(_value.copyWith(bowlingStats: value) as $Val);
    });
  }

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FieldingStatsCopyWith<$Res> get fieldingStats {
    return $FieldingStatsCopyWith<$Res>(_value.fieldingStats, (value) {
      return _then(_value.copyWith(fieldingStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerStatsImplCopyWith<$Res>
    implements $PlayerStatsCopyWith<$Res> {
  factory _$$PlayerStatsImplCopyWith(
          _$PlayerStatsImpl value, $Res Function(_$PlayerStatsImpl) then) =
      __$$PlayerStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String playerId,
      String playerName,
      String primaryRole,
      double overallRating,
      String playerLevel,
      String joinDate,
      String debutDate,
      int totalMatches,
      BattingStats battingStats,
      BowlingStats bowlingStats,
      FieldingStats fieldingStats,
      List<MatchPerformance> recentMatches,
      String? firstCenturyDate,
      String? firstFiftyDate,
      String? firstFiveWicketDate});

  @override
  $BattingStatsCopyWith<$Res> get battingStats;
  @override
  $BowlingStatsCopyWith<$Res> get bowlingStats;
  @override
  $FieldingStatsCopyWith<$Res> get fieldingStats;
}

/// @nodoc
class __$$PlayerStatsImplCopyWithImpl<$Res>
    extends _$PlayerStatsCopyWithImpl<$Res, _$PlayerStatsImpl>
    implements _$$PlayerStatsImplCopyWith<$Res> {
  __$$PlayerStatsImplCopyWithImpl(
      _$PlayerStatsImpl _value, $Res Function(_$PlayerStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? primaryRole = null,
    Object? overallRating = null,
    Object? playerLevel = null,
    Object? joinDate = null,
    Object? debutDate = null,
    Object? totalMatches = null,
    Object? battingStats = null,
    Object? bowlingStats = null,
    Object? fieldingStats = null,
    Object? recentMatches = null,
    Object? firstCenturyDate = freezed,
    Object? firstFiftyDate = freezed,
    Object? firstFiveWicketDate = freezed,
  }) {
    return _then(_$PlayerStatsImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      primaryRole: null == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      playerLevel: null == playerLevel
          ? _value.playerLevel
          : playerLevel // ignore: cast_nullable_to_non_nullable
              as String,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as String,
      debutDate: null == debutDate
          ? _value.debutDate
          : debutDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalMatches: null == totalMatches
          ? _value.totalMatches
          : totalMatches // ignore: cast_nullable_to_non_nullable
              as int,
      battingStats: null == battingStats
          ? _value.battingStats
          : battingStats // ignore: cast_nullable_to_non_nullable
              as BattingStats,
      bowlingStats: null == bowlingStats
          ? _value.bowlingStats
          : bowlingStats // ignore: cast_nullable_to_non_nullable
              as BowlingStats,
      fieldingStats: null == fieldingStats
          ? _value.fieldingStats
          : fieldingStats // ignore: cast_nullable_to_non_nullable
              as FieldingStats,
      recentMatches: null == recentMatches
          ? _value._recentMatches
          : recentMatches // ignore: cast_nullable_to_non_nullable
              as List<MatchPerformance>,
      firstCenturyDate: freezed == firstCenturyDate
          ? _value.firstCenturyDate
          : firstCenturyDate // ignore: cast_nullable_to_non_nullable
              as String?,
      firstFiftyDate: freezed == firstFiftyDate
          ? _value.firstFiftyDate
          : firstFiftyDate // ignore: cast_nullable_to_non_nullable
              as String?,
      firstFiveWicketDate: freezed == firstFiveWicketDate
          ? _value.firstFiveWicketDate
          : firstFiveWicketDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStatsImpl implements _PlayerStats {
  const _$PlayerStatsImpl(
      {required this.playerId,
      required this.playerName,
      required this.primaryRole,
      required this.overallRating,
      required this.playerLevel,
      required this.joinDate,
      required this.debutDate,
      required this.totalMatches,
      required this.battingStats,
      required this.bowlingStats,
      required this.fieldingStats,
      required final List<MatchPerformance> recentMatches,
      this.firstCenturyDate,
      this.firstFiftyDate,
      this.firstFiveWicketDate})
      : _recentMatches = recentMatches;

  factory _$PlayerStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStatsImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String primaryRole;
  @override
  final double overallRating;
  @override
  final String playerLevel;
  @override
  final String joinDate;
  @override
  final String debutDate;
  @override
  final int totalMatches;
  @override
  final BattingStats battingStats;
  @override
  final BowlingStats bowlingStats;
  @override
  final FieldingStats fieldingStats;
  final List<MatchPerformance> _recentMatches;
  @override
  List<MatchPerformance> get recentMatches {
    if (_recentMatches is EqualUnmodifiableListView) return _recentMatches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentMatches);
  }

  @override
  final String? firstCenturyDate;
  @override
  final String? firstFiftyDate;
  @override
  final String? firstFiveWicketDate;

  @override
  String toString() {
    return 'PlayerStats(playerId: $playerId, playerName: $playerName, primaryRole: $primaryRole, overallRating: $overallRating, playerLevel: $playerLevel, joinDate: $joinDate, debutDate: $debutDate, totalMatches: $totalMatches, battingStats: $battingStats, bowlingStats: $bowlingStats, fieldingStats: $fieldingStats, recentMatches: $recentMatches, firstCenturyDate: $firstCenturyDate, firstFiftyDate: $firstFiftyDate, firstFiveWicketDate: $firstFiveWicketDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatsImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.primaryRole, primaryRole) ||
                other.primaryRole == primaryRole) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            (identical(other.playerLevel, playerLevel) ||
                other.playerLevel == playerLevel) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.debutDate, debutDate) ||
                other.debutDate == debutDate) &&
            (identical(other.totalMatches, totalMatches) ||
                other.totalMatches == totalMatches) &&
            (identical(other.battingStats, battingStats) ||
                other.battingStats == battingStats) &&
            (identical(other.bowlingStats, bowlingStats) ||
                other.bowlingStats == bowlingStats) &&
            (identical(other.fieldingStats, fieldingStats) ||
                other.fieldingStats == fieldingStats) &&
            const DeepCollectionEquality()
                .equals(other._recentMatches, _recentMatches) &&
            (identical(other.firstCenturyDate, firstCenturyDate) ||
                other.firstCenturyDate == firstCenturyDate) &&
            (identical(other.firstFiftyDate, firstFiftyDate) ||
                other.firstFiftyDate == firstFiftyDate) &&
            (identical(other.firstFiveWicketDate, firstFiveWicketDate) ||
                other.firstFiveWicketDate == firstFiveWicketDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      playerId,
      playerName,
      primaryRole,
      overallRating,
      playerLevel,
      joinDate,
      debutDate,
      totalMatches,
      battingStats,
      bowlingStats,
      fieldingStats,
      const DeepCollectionEquality().hash(_recentMatches),
      firstCenturyDate,
      firstFiftyDate,
      firstFiveWicketDate);

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStatsImplCopyWith<_$PlayerStatsImpl> get copyWith =>
      __$$PlayerStatsImplCopyWithImpl<_$PlayerStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStatsImplToJson(
      this,
    );
  }
}

abstract class _PlayerStats implements PlayerStats {
  const factory _PlayerStats(
      {required final String playerId,
      required final String playerName,
      required final String primaryRole,
      required final double overallRating,
      required final String playerLevel,
      required final String joinDate,
      required final String debutDate,
      required final int totalMatches,
      required final BattingStats battingStats,
      required final BowlingStats bowlingStats,
      required final FieldingStats fieldingStats,
      required final List<MatchPerformance> recentMatches,
      final String? firstCenturyDate,
      final String? firstFiftyDate,
      final String? firstFiveWicketDate}) = _$PlayerStatsImpl;

  factory _PlayerStats.fromJson(Map<String, dynamic> json) =
      _$PlayerStatsImpl.fromJson;

  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get primaryRole;
  @override
  double get overallRating;
  @override
  String get playerLevel;
  @override
  String get joinDate;
  @override
  String get debutDate;
  @override
  int get totalMatches;
  @override
  BattingStats get battingStats;
  @override
  BowlingStats get bowlingStats;
  @override
  FieldingStats get fieldingStats;
  @override
  List<MatchPerformance> get recentMatches;
  @override
  String? get firstCenturyDate;
  @override
  String? get firstFiftyDate;
  @override
  String? get firstFiveWicketDate;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStatsImplCopyWith<_$PlayerStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BattingStats _$BattingStatsFromJson(Map<String, dynamic> json) {
  return _BattingStats.fromJson(json);
}

/// @nodoc
mixin _$BattingStats {
  int get matches => throw _privateConstructorUsedError;
  int get innings => throw _privateConstructorUsedError;
  int get runs => throw _privateConstructorUsedError;
  double get average => throw _privateConstructorUsedError;
  double get strikeRate => throw _privateConstructorUsedError;
  int get highestScore => throw _privateConstructorUsedError;
  int get fifties => throw _privateConstructorUsedError;
  int get hundreds => throw _privateConstructorUsedError;
  int get fours => throw _privateConstructorUsedError;
  int get sixes => throw _privateConstructorUsedError;
  int get ballsFaced => throw _privateConstructorUsedError;
  String get notOuts => throw _privateConstructorUsedError;

  /// Serializes this BattingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BattingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattingStatsCopyWith<BattingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattingStatsCopyWith<$Res> {
  factory $BattingStatsCopyWith(
          BattingStats value, $Res Function(BattingStats) then) =
      _$BattingStatsCopyWithImpl<$Res, BattingStats>;
  @useResult
  $Res call(
      {int matches,
      int innings,
      int runs,
      double average,
      double strikeRate,
      int highestScore,
      int fifties,
      int hundreds,
      int fours,
      int sixes,
      int ballsFaced,
      String notOuts});
}

/// @nodoc
class _$BattingStatsCopyWithImpl<$Res, $Val extends BattingStats>
    implements $BattingStatsCopyWith<$Res> {
  _$BattingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matches = null,
    Object? innings = null,
    Object? runs = null,
    Object? average = null,
    Object? strikeRate = null,
    Object? highestScore = null,
    Object? fifties = null,
    Object? hundreds = null,
    Object? fours = null,
    Object? sixes = null,
    Object? ballsFaced = null,
    Object? notOuts = null,
  }) {
    return _then(_value.copyWith(
      matches: null == matches
          ? _value.matches
          : matches // ignore: cast_nullable_to_non_nullable
              as int,
      innings: null == innings
          ? _value.innings
          : innings // ignore: cast_nullable_to_non_nullable
              as int,
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      strikeRate: null == strikeRate
          ? _value.strikeRate
          : strikeRate // ignore: cast_nullable_to_non_nullable
              as double,
      highestScore: null == highestScore
          ? _value.highestScore
          : highestScore // ignore: cast_nullable_to_non_nullable
              as int,
      fifties: null == fifties
          ? _value.fifties
          : fifties // ignore: cast_nullable_to_non_nullable
              as int,
      hundreds: null == hundreds
          ? _value.hundreds
          : hundreds // ignore: cast_nullable_to_non_nullable
              as int,
      fours: null == fours
          ? _value.fours
          : fours // ignore: cast_nullable_to_non_nullable
              as int,
      sixes: null == sixes
          ? _value.sixes
          : sixes // ignore: cast_nullable_to_non_nullable
              as int,
      ballsFaced: null == ballsFaced
          ? _value.ballsFaced
          : ballsFaced // ignore: cast_nullable_to_non_nullable
              as int,
      notOuts: null == notOuts
          ? _value.notOuts
          : notOuts // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BattingStatsImplCopyWith<$Res>
    implements $BattingStatsCopyWith<$Res> {
  factory _$$BattingStatsImplCopyWith(
          _$BattingStatsImpl value, $Res Function(_$BattingStatsImpl) then) =
      __$$BattingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int matches,
      int innings,
      int runs,
      double average,
      double strikeRate,
      int highestScore,
      int fifties,
      int hundreds,
      int fours,
      int sixes,
      int ballsFaced,
      String notOuts});
}

/// @nodoc
class __$$BattingStatsImplCopyWithImpl<$Res>
    extends _$BattingStatsCopyWithImpl<$Res, _$BattingStatsImpl>
    implements _$$BattingStatsImplCopyWith<$Res> {
  __$$BattingStatsImplCopyWithImpl(
      _$BattingStatsImpl _value, $Res Function(_$BattingStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BattingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matches = null,
    Object? innings = null,
    Object? runs = null,
    Object? average = null,
    Object? strikeRate = null,
    Object? highestScore = null,
    Object? fifties = null,
    Object? hundreds = null,
    Object? fours = null,
    Object? sixes = null,
    Object? ballsFaced = null,
    Object? notOuts = null,
  }) {
    return _then(_$BattingStatsImpl(
      matches: null == matches
          ? _value.matches
          : matches // ignore: cast_nullable_to_non_nullable
              as int,
      innings: null == innings
          ? _value.innings
          : innings // ignore: cast_nullable_to_non_nullable
              as int,
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      strikeRate: null == strikeRate
          ? _value.strikeRate
          : strikeRate // ignore: cast_nullable_to_non_nullable
              as double,
      highestScore: null == highestScore
          ? _value.highestScore
          : highestScore // ignore: cast_nullable_to_non_nullable
              as int,
      fifties: null == fifties
          ? _value.fifties
          : fifties // ignore: cast_nullable_to_non_nullable
              as int,
      hundreds: null == hundreds
          ? _value.hundreds
          : hundreds // ignore: cast_nullable_to_non_nullable
              as int,
      fours: null == fours
          ? _value.fours
          : fours // ignore: cast_nullable_to_non_nullable
              as int,
      sixes: null == sixes
          ? _value.sixes
          : sixes // ignore: cast_nullable_to_non_nullable
              as int,
      ballsFaced: null == ballsFaced
          ? _value.ballsFaced
          : ballsFaced // ignore: cast_nullable_to_non_nullable
              as int,
      notOuts: null == notOuts
          ? _value.notOuts
          : notOuts // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BattingStatsImpl implements _BattingStats {
  const _$BattingStatsImpl(
      {this.matches = 0,
      this.innings = 0,
      this.runs = 0,
      this.average = 0.0,
      this.strikeRate = 0.0,
      this.highestScore = 0,
      this.fifties = 0,
      this.hundreds = 0,
      this.fours = 0,
      this.sixes = 0,
      this.ballsFaced = 0,
      this.notOuts = '0'});

  factory _$BattingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattingStatsImplFromJson(json);

  @override
  @JsonKey()
  final int matches;
  @override
  @JsonKey()
  final int innings;
  @override
  @JsonKey()
  final int runs;
  @override
  @JsonKey()
  final double average;
  @override
  @JsonKey()
  final double strikeRate;
  @override
  @JsonKey()
  final int highestScore;
  @override
  @JsonKey()
  final int fifties;
  @override
  @JsonKey()
  final int hundreds;
  @override
  @JsonKey()
  final int fours;
  @override
  @JsonKey()
  final int sixes;
  @override
  @JsonKey()
  final int ballsFaced;
  @override
  @JsonKey()
  final String notOuts;

  @override
  String toString() {
    return 'BattingStats(matches: $matches, innings: $innings, runs: $runs, average: $average, strikeRate: $strikeRate, highestScore: $highestScore, fifties: $fifties, hundreds: $hundreds, fours: $fours, sixes: $sixes, ballsFaced: $ballsFaced, notOuts: $notOuts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattingStatsImpl &&
            (identical(other.matches, matches) || other.matches == matches) &&
            (identical(other.innings, innings) || other.innings == innings) &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.strikeRate, strikeRate) ||
                other.strikeRate == strikeRate) &&
            (identical(other.highestScore, highestScore) ||
                other.highestScore == highestScore) &&
            (identical(other.fifties, fifties) || other.fifties == fifties) &&
            (identical(other.hundreds, hundreds) ||
                other.hundreds == hundreds) &&
            (identical(other.fours, fours) || other.fours == fours) &&
            (identical(other.sixes, sixes) || other.sixes == sixes) &&
            (identical(other.ballsFaced, ballsFaced) ||
                other.ballsFaced == ballsFaced) &&
            (identical(other.notOuts, notOuts) || other.notOuts == notOuts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matches,
      innings,
      runs,
      average,
      strikeRate,
      highestScore,
      fifties,
      hundreds,
      fours,
      sixes,
      ballsFaced,
      notOuts);

  /// Create a copy of BattingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattingStatsImplCopyWith<_$BattingStatsImpl> get copyWith =>
      __$$BattingStatsImplCopyWithImpl<_$BattingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattingStatsImplToJson(
      this,
    );
  }
}

abstract class _BattingStats implements BattingStats {
  const factory _BattingStats(
      {final int matches,
      final int innings,
      final int runs,
      final double average,
      final double strikeRate,
      final int highestScore,
      final int fifties,
      final int hundreds,
      final int fours,
      final int sixes,
      final int ballsFaced,
      final String notOuts}) = _$BattingStatsImpl;

  factory _BattingStats.fromJson(Map<String, dynamic> json) =
      _$BattingStatsImpl.fromJson;

  @override
  int get matches;
  @override
  int get innings;
  @override
  int get runs;
  @override
  double get average;
  @override
  double get strikeRate;
  @override
  int get highestScore;
  @override
  int get fifties;
  @override
  int get hundreds;
  @override
  int get fours;
  @override
  int get sixes;
  @override
  int get ballsFaced;
  @override
  String get notOuts;

  /// Create a copy of BattingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattingStatsImplCopyWith<_$BattingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BowlingStats _$BowlingStatsFromJson(Map<String, dynamic> json) {
  return _BowlingStats.fromJson(json);
}

/// @nodoc
mixin _$BowlingStats {
  int get matches => throw _privateConstructorUsedError;
  int get innings => throw _privateConstructorUsedError;
  int get balls => throw _privateConstructorUsedError;
  int get runsConceded => throw _privateConstructorUsedError;
  int get wickets => throw _privateConstructorUsedError;
  double get average => throw _privateConstructorUsedError;
  double get economy => throw _privateConstructorUsedError;
  double get strikeRate => throw _privateConstructorUsedError;
  String get bestBowling => throw _privateConstructorUsedError;
  int get fiveWicketHauls => throw _privateConstructorUsedError;
  int get tenWicketHauls => throw _privateConstructorUsedError;

  /// Serializes this BowlingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BowlingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BowlingStatsCopyWith<BowlingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BowlingStatsCopyWith<$Res> {
  factory $BowlingStatsCopyWith(
          BowlingStats value, $Res Function(BowlingStats) then) =
      _$BowlingStatsCopyWithImpl<$Res, BowlingStats>;
  @useResult
  $Res call(
      {int matches,
      int innings,
      int balls,
      int runsConceded,
      int wickets,
      double average,
      double economy,
      double strikeRate,
      String bestBowling,
      int fiveWicketHauls,
      int tenWicketHauls});
}

/// @nodoc
class _$BowlingStatsCopyWithImpl<$Res, $Val extends BowlingStats>
    implements $BowlingStatsCopyWith<$Res> {
  _$BowlingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BowlingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matches = null,
    Object? innings = null,
    Object? balls = null,
    Object? runsConceded = null,
    Object? wickets = null,
    Object? average = null,
    Object? economy = null,
    Object? strikeRate = null,
    Object? bestBowling = null,
    Object? fiveWicketHauls = null,
    Object? tenWicketHauls = null,
  }) {
    return _then(_value.copyWith(
      matches: null == matches
          ? _value.matches
          : matches // ignore: cast_nullable_to_non_nullable
              as int,
      innings: null == innings
          ? _value.innings
          : innings // ignore: cast_nullable_to_non_nullable
              as int,
      balls: null == balls
          ? _value.balls
          : balls // ignore: cast_nullable_to_non_nullable
              as int,
      runsConceded: null == runsConceded
          ? _value.runsConceded
          : runsConceded // ignore: cast_nullable_to_non_nullable
              as int,
      wickets: null == wickets
          ? _value.wickets
          : wickets // ignore: cast_nullable_to_non_nullable
              as int,
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      economy: null == economy
          ? _value.economy
          : economy // ignore: cast_nullable_to_non_nullable
              as double,
      strikeRate: null == strikeRate
          ? _value.strikeRate
          : strikeRate // ignore: cast_nullable_to_non_nullable
              as double,
      bestBowling: null == bestBowling
          ? _value.bestBowling
          : bestBowling // ignore: cast_nullable_to_non_nullable
              as String,
      fiveWicketHauls: null == fiveWicketHauls
          ? _value.fiveWicketHauls
          : fiveWicketHauls // ignore: cast_nullable_to_non_nullable
              as int,
      tenWicketHauls: null == tenWicketHauls
          ? _value.tenWicketHauls
          : tenWicketHauls // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BowlingStatsImplCopyWith<$Res>
    implements $BowlingStatsCopyWith<$Res> {
  factory _$$BowlingStatsImplCopyWith(
          _$BowlingStatsImpl value, $Res Function(_$BowlingStatsImpl) then) =
      __$$BowlingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int matches,
      int innings,
      int balls,
      int runsConceded,
      int wickets,
      double average,
      double economy,
      double strikeRate,
      String bestBowling,
      int fiveWicketHauls,
      int tenWicketHauls});
}

/// @nodoc
class __$$BowlingStatsImplCopyWithImpl<$Res>
    extends _$BowlingStatsCopyWithImpl<$Res, _$BowlingStatsImpl>
    implements _$$BowlingStatsImplCopyWith<$Res> {
  __$$BowlingStatsImplCopyWithImpl(
      _$BowlingStatsImpl _value, $Res Function(_$BowlingStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BowlingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matches = null,
    Object? innings = null,
    Object? balls = null,
    Object? runsConceded = null,
    Object? wickets = null,
    Object? average = null,
    Object? economy = null,
    Object? strikeRate = null,
    Object? bestBowling = null,
    Object? fiveWicketHauls = null,
    Object? tenWicketHauls = null,
  }) {
    return _then(_$BowlingStatsImpl(
      matches: null == matches
          ? _value.matches
          : matches // ignore: cast_nullable_to_non_nullable
              as int,
      innings: null == innings
          ? _value.innings
          : innings // ignore: cast_nullable_to_non_nullable
              as int,
      balls: null == balls
          ? _value.balls
          : balls // ignore: cast_nullable_to_non_nullable
              as int,
      runsConceded: null == runsConceded
          ? _value.runsConceded
          : runsConceded // ignore: cast_nullable_to_non_nullable
              as int,
      wickets: null == wickets
          ? _value.wickets
          : wickets // ignore: cast_nullable_to_non_nullable
              as int,
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      economy: null == economy
          ? _value.economy
          : economy // ignore: cast_nullable_to_non_nullable
              as double,
      strikeRate: null == strikeRate
          ? _value.strikeRate
          : strikeRate // ignore: cast_nullable_to_non_nullable
              as double,
      bestBowling: null == bestBowling
          ? _value.bestBowling
          : bestBowling // ignore: cast_nullable_to_non_nullable
              as String,
      fiveWicketHauls: null == fiveWicketHauls
          ? _value.fiveWicketHauls
          : fiveWicketHauls // ignore: cast_nullable_to_non_nullable
              as int,
      tenWicketHauls: null == tenWicketHauls
          ? _value.tenWicketHauls
          : tenWicketHauls // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BowlingStatsImpl implements _BowlingStats {
  const _$BowlingStatsImpl(
      {this.matches = 0,
      this.innings = 0,
      this.balls = 0,
      this.runsConceded = 0,
      this.wickets = 0,
      this.average = 0.0,
      this.economy = 0.0,
      this.strikeRate = 0.0,
      this.bestBowling = '0/0',
      this.fiveWicketHauls = 0,
      this.tenWicketHauls = 0});

  factory _$BowlingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BowlingStatsImplFromJson(json);

  @override
  @JsonKey()
  final int matches;
  @override
  @JsonKey()
  final int innings;
  @override
  @JsonKey()
  final int balls;
  @override
  @JsonKey()
  final int runsConceded;
  @override
  @JsonKey()
  final int wickets;
  @override
  @JsonKey()
  final double average;
  @override
  @JsonKey()
  final double economy;
  @override
  @JsonKey()
  final double strikeRate;
  @override
  @JsonKey()
  final String bestBowling;
  @override
  @JsonKey()
  final int fiveWicketHauls;
  @override
  @JsonKey()
  final int tenWicketHauls;

  @override
  String toString() {
    return 'BowlingStats(matches: $matches, innings: $innings, balls: $balls, runsConceded: $runsConceded, wickets: $wickets, average: $average, economy: $economy, strikeRate: $strikeRate, bestBowling: $bestBowling, fiveWicketHauls: $fiveWicketHauls, tenWicketHauls: $tenWicketHauls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BowlingStatsImpl &&
            (identical(other.matches, matches) || other.matches == matches) &&
            (identical(other.innings, innings) || other.innings == innings) &&
            (identical(other.balls, balls) || other.balls == balls) &&
            (identical(other.runsConceded, runsConceded) ||
                other.runsConceded == runsConceded) &&
            (identical(other.wickets, wickets) || other.wickets == wickets) &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.economy, economy) || other.economy == economy) &&
            (identical(other.strikeRate, strikeRate) ||
                other.strikeRate == strikeRate) &&
            (identical(other.bestBowling, bestBowling) ||
                other.bestBowling == bestBowling) &&
            (identical(other.fiveWicketHauls, fiveWicketHauls) ||
                other.fiveWicketHauls == fiveWicketHauls) &&
            (identical(other.tenWicketHauls, tenWicketHauls) ||
                other.tenWicketHauls == tenWicketHauls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matches,
      innings,
      balls,
      runsConceded,
      wickets,
      average,
      economy,
      strikeRate,
      bestBowling,
      fiveWicketHauls,
      tenWicketHauls);

  /// Create a copy of BowlingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BowlingStatsImplCopyWith<_$BowlingStatsImpl> get copyWith =>
      __$$BowlingStatsImplCopyWithImpl<_$BowlingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BowlingStatsImplToJson(
      this,
    );
  }
}

abstract class _BowlingStats implements BowlingStats {
  const factory _BowlingStats(
      {final int matches,
      final int innings,
      final int balls,
      final int runsConceded,
      final int wickets,
      final double average,
      final double economy,
      final double strikeRate,
      final String bestBowling,
      final int fiveWicketHauls,
      final int tenWicketHauls}) = _$BowlingStatsImpl;

  factory _BowlingStats.fromJson(Map<String, dynamic> json) =
      _$BowlingStatsImpl.fromJson;

  @override
  int get matches;
  @override
  int get innings;
  @override
  int get balls;
  @override
  int get runsConceded;
  @override
  int get wickets;
  @override
  double get average;
  @override
  double get economy;
  @override
  double get strikeRate;
  @override
  String get bestBowling;
  @override
  int get fiveWicketHauls;
  @override
  int get tenWicketHauls;

  /// Create a copy of BowlingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BowlingStatsImplCopyWith<_$BowlingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FieldingStats _$FieldingStatsFromJson(Map<String, dynamic> json) {
  return _FieldingStats.fromJson(json);
}

/// @nodoc
mixin _$FieldingStats {
  int get catches => throw _privateConstructorUsedError;
  int get runOuts => throw _privateConstructorUsedError;
  int get stumpings => throw _privateConstructorUsedError;

  /// Serializes this FieldingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldingStatsCopyWith<FieldingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldingStatsCopyWith<$Res> {
  factory $FieldingStatsCopyWith(
          FieldingStats value, $Res Function(FieldingStats) then) =
      _$FieldingStatsCopyWithImpl<$Res, FieldingStats>;
  @useResult
  $Res call({int catches, int runOuts, int stumpings});
}

/// @nodoc
class _$FieldingStatsCopyWithImpl<$Res, $Val extends FieldingStats>
    implements $FieldingStatsCopyWith<$Res> {
  _$FieldingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catches = null,
    Object? runOuts = null,
    Object? stumpings = null,
  }) {
    return _then(_value.copyWith(
      catches: null == catches
          ? _value.catches
          : catches // ignore: cast_nullable_to_non_nullable
              as int,
      runOuts: null == runOuts
          ? _value.runOuts
          : runOuts // ignore: cast_nullable_to_non_nullable
              as int,
      stumpings: null == stumpings
          ? _value.stumpings
          : stumpings // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldingStatsImplCopyWith<$Res>
    implements $FieldingStatsCopyWith<$Res> {
  factory _$$FieldingStatsImplCopyWith(
          _$FieldingStatsImpl value, $Res Function(_$FieldingStatsImpl) then) =
      __$$FieldingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int catches, int runOuts, int stumpings});
}

/// @nodoc
class __$$FieldingStatsImplCopyWithImpl<$Res>
    extends _$FieldingStatsCopyWithImpl<$Res, _$FieldingStatsImpl>
    implements _$$FieldingStatsImplCopyWith<$Res> {
  __$$FieldingStatsImplCopyWithImpl(
      _$FieldingStatsImpl _value, $Res Function(_$FieldingStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FieldingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catches = null,
    Object? runOuts = null,
    Object? stumpings = null,
  }) {
    return _then(_$FieldingStatsImpl(
      catches: null == catches
          ? _value.catches
          : catches // ignore: cast_nullable_to_non_nullable
              as int,
      runOuts: null == runOuts
          ? _value.runOuts
          : runOuts // ignore: cast_nullable_to_non_nullable
              as int,
      stumpings: null == stumpings
          ? _value.stumpings
          : stumpings // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldingStatsImpl implements _FieldingStats {
  const _$FieldingStatsImpl(
      {this.catches = 0, this.runOuts = 0, this.stumpings = 0});

  factory _$FieldingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldingStatsImplFromJson(json);

  @override
  @JsonKey()
  final int catches;
  @override
  @JsonKey()
  final int runOuts;
  @override
  @JsonKey()
  final int stumpings;

  @override
  String toString() {
    return 'FieldingStats(catches: $catches, runOuts: $runOuts, stumpings: $stumpings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldingStatsImpl &&
            (identical(other.catches, catches) || other.catches == catches) &&
            (identical(other.runOuts, runOuts) || other.runOuts == runOuts) &&
            (identical(other.stumpings, stumpings) ||
                other.stumpings == stumpings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, catches, runOuts, stumpings);

  /// Create a copy of FieldingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldingStatsImplCopyWith<_$FieldingStatsImpl> get copyWith =>
      __$$FieldingStatsImplCopyWithImpl<_$FieldingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldingStatsImplToJson(
      this,
    );
  }
}

abstract class _FieldingStats implements FieldingStats {
  const factory _FieldingStats(
      {final int catches,
      final int runOuts,
      final int stumpings}) = _$FieldingStatsImpl;

  factory _FieldingStats.fromJson(Map<String, dynamic> json) =
      _$FieldingStatsImpl.fromJson;

  @override
  int get catches;
  @override
  int get runOuts;
  @override
  int get stumpings;

  /// Create a copy of FieldingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldingStatsImplCopyWith<_$FieldingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchPerformance _$MatchPerformanceFromJson(Map<String, dynamic> json) {
  return _MatchPerformance.fromJson(json);
}

/// @nodoc
mixin _$MatchPerformance {
  String get matchId => throw _privateConstructorUsedError;
  String get teamAName => throw _privateConstructorUsedError;
  String get teamBName => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  BattingPerformance? get battingPerformance =>
      throw _privateConstructorUsedError;
  BowlingPerformance? get bowlingPerformance =>
      throw _privateConstructorUsedError;
  FieldingPerformance? get fieldingPerformance =>
      throw _privateConstructorUsedError;

  /// Serializes this MatchPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchPerformanceCopyWith<MatchPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchPerformanceCopyWith<$Res> {
  factory $MatchPerformanceCopyWith(
          MatchPerformance value, $Res Function(MatchPerformance) then) =
      _$MatchPerformanceCopyWithImpl<$Res, MatchPerformance>;
  @useResult
  $Res call(
      {String matchId,
      String teamAName,
      String teamBName,
      String date,
      BattingPerformance? battingPerformance,
      BowlingPerformance? bowlingPerformance,
      FieldingPerformance? fieldingPerformance});

  $BattingPerformanceCopyWith<$Res>? get battingPerformance;
  $BowlingPerformanceCopyWith<$Res>? get bowlingPerformance;
  $FieldingPerformanceCopyWith<$Res>? get fieldingPerformance;
}

/// @nodoc
class _$MatchPerformanceCopyWithImpl<$Res, $Val extends MatchPerformance>
    implements $MatchPerformanceCopyWith<$Res> {
  _$MatchPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? teamAName = null,
    Object? teamBName = null,
    Object? date = null,
    Object? battingPerformance = freezed,
    Object? bowlingPerformance = freezed,
    Object? fieldingPerformance = freezed,
  }) {
    return _then(_value.copyWith(
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      teamAName: null == teamAName
          ? _value.teamAName
          : teamAName // ignore: cast_nullable_to_non_nullable
              as String,
      teamBName: null == teamBName
          ? _value.teamBName
          : teamBName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      battingPerformance: freezed == battingPerformance
          ? _value.battingPerformance
          : battingPerformance // ignore: cast_nullable_to_non_nullable
              as BattingPerformance?,
      bowlingPerformance: freezed == bowlingPerformance
          ? _value.bowlingPerformance
          : bowlingPerformance // ignore: cast_nullable_to_non_nullable
              as BowlingPerformance?,
      fieldingPerformance: freezed == fieldingPerformance
          ? _value.fieldingPerformance
          : fieldingPerformance // ignore: cast_nullable_to_non_nullable
              as FieldingPerformance?,
    ) as $Val);
  }

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BattingPerformanceCopyWith<$Res>? get battingPerformance {
    if (_value.battingPerformance == null) {
      return null;
    }

    return $BattingPerformanceCopyWith<$Res>(_value.battingPerformance!,
        (value) {
      return _then(_value.copyWith(battingPerformance: value) as $Val);
    });
  }

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BowlingPerformanceCopyWith<$Res>? get bowlingPerformance {
    if (_value.bowlingPerformance == null) {
      return null;
    }

    return $BowlingPerformanceCopyWith<$Res>(_value.bowlingPerformance!,
        (value) {
      return _then(_value.copyWith(bowlingPerformance: value) as $Val);
    });
  }

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FieldingPerformanceCopyWith<$Res>? get fieldingPerformance {
    if (_value.fieldingPerformance == null) {
      return null;
    }

    return $FieldingPerformanceCopyWith<$Res>(_value.fieldingPerformance!,
        (value) {
      return _then(_value.copyWith(fieldingPerformance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchPerformanceImplCopyWith<$Res>
    implements $MatchPerformanceCopyWith<$Res> {
  factory _$$MatchPerformanceImplCopyWith(_$MatchPerformanceImpl value,
          $Res Function(_$MatchPerformanceImpl) then) =
      __$$MatchPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String matchId,
      String teamAName,
      String teamBName,
      String date,
      BattingPerformance? battingPerformance,
      BowlingPerformance? bowlingPerformance,
      FieldingPerformance? fieldingPerformance});

  @override
  $BattingPerformanceCopyWith<$Res>? get battingPerformance;
  @override
  $BowlingPerformanceCopyWith<$Res>? get bowlingPerformance;
  @override
  $FieldingPerformanceCopyWith<$Res>? get fieldingPerformance;
}

/// @nodoc
class __$$MatchPerformanceImplCopyWithImpl<$Res>
    extends _$MatchPerformanceCopyWithImpl<$Res, _$MatchPerformanceImpl>
    implements _$$MatchPerformanceImplCopyWith<$Res> {
  __$$MatchPerformanceImplCopyWithImpl(_$MatchPerformanceImpl _value,
      $Res Function(_$MatchPerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? teamAName = null,
    Object? teamBName = null,
    Object? date = null,
    Object? battingPerformance = freezed,
    Object? bowlingPerformance = freezed,
    Object? fieldingPerformance = freezed,
  }) {
    return _then(_$MatchPerformanceImpl(
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      teamAName: null == teamAName
          ? _value.teamAName
          : teamAName // ignore: cast_nullable_to_non_nullable
              as String,
      teamBName: null == teamBName
          ? _value.teamBName
          : teamBName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      battingPerformance: freezed == battingPerformance
          ? _value.battingPerformance
          : battingPerformance // ignore: cast_nullable_to_non_nullable
              as BattingPerformance?,
      bowlingPerformance: freezed == bowlingPerformance
          ? _value.bowlingPerformance
          : bowlingPerformance // ignore: cast_nullable_to_non_nullable
              as BowlingPerformance?,
      fieldingPerformance: freezed == fieldingPerformance
          ? _value.fieldingPerformance
          : fieldingPerformance // ignore: cast_nullable_to_non_nullable
              as FieldingPerformance?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchPerformanceImpl implements _MatchPerformance {
  const _$MatchPerformanceImpl(
      {required this.matchId,
      required this.teamAName,
      required this.teamBName,
      required this.date,
      this.battingPerformance,
      this.bowlingPerformance,
      this.fieldingPerformance});

  factory _$MatchPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchPerformanceImplFromJson(json);

  @override
  final String matchId;
  @override
  final String teamAName;
  @override
  final String teamBName;
  @override
  final String date;
  @override
  final BattingPerformance? battingPerformance;
  @override
  final BowlingPerformance? bowlingPerformance;
  @override
  final FieldingPerformance? fieldingPerformance;

  @override
  String toString() {
    return 'MatchPerformance(matchId: $matchId, teamAName: $teamAName, teamBName: $teamBName, date: $date, battingPerformance: $battingPerformance, bowlingPerformance: $bowlingPerformance, fieldingPerformance: $fieldingPerformance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchPerformanceImpl &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.teamAName, teamAName) ||
                other.teamAName == teamAName) &&
            (identical(other.teamBName, teamBName) ||
                other.teamBName == teamBName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.battingPerformance, battingPerformance) ||
                other.battingPerformance == battingPerformance) &&
            (identical(other.bowlingPerformance, bowlingPerformance) ||
                other.bowlingPerformance == bowlingPerformance) &&
            (identical(other.fieldingPerformance, fieldingPerformance) ||
                other.fieldingPerformance == fieldingPerformance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, matchId, teamAName, teamBName,
      date, battingPerformance, bowlingPerformance, fieldingPerformance);

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchPerformanceImplCopyWith<_$MatchPerformanceImpl> get copyWith =>
      __$$MatchPerformanceImplCopyWithImpl<_$MatchPerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchPerformanceImplToJson(
      this,
    );
  }
}

abstract class _MatchPerformance implements MatchPerformance {
  const factory _MatchPerformance(
      {required final String matchId,
      required final String teamAName,
      required final String teamBName,
      required final String date,
      final BattingPerformance? battingPerformance,
      final BowlingPerformance? bowlingPerformance,
      final FieldingPerformance? fieldingPerformance}) = _$MatchPerformanceImpl;

  factory _MatchPerformance.fromJson(Map<String, dynamic> json) =
      _$MatchPerformanceImpl.fromJson;

  @override
  String get matchId;
  @override
  String get teamAName;
  @override
  String get teamBName;
  @override
  String get date;
  @override
  BattingPerformance? get battingPerformance;
  @override
  BowlingPerformance? get bowlingPerformance;
  @override
  FieldingPerformance? get fieldingPerformance;

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchPerformanceImplCopyWith<_$MatchPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BattingPerformance _$BattingPerformanceFromJson(Map<String, dynamic> json) {
  return _BattingPerformance.fromJson(json);
}

/// @nodoc
mixin _$BattingPerformance {
  int get runs => throw _privateConstructorUsedError;
  int get balls => throw _privateConstructorUsedError;
  int get fours => throw _privateConstructorUsedError;
  int get sixes => throw _privateConstructorUsedError;
  String get strikeRate => throw _privateConstructorUsedError;
  String get dismissal => throw _privateConstructorUsedError;

  /// Serializes this BattingPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BattingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattingPerformanceCopyWith<BattingPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattingPerformanceCopyWith<$Res> {
  factory $BattingPerformanceCopyWith(
          BattingPerformance value, $Res Function(BattingPerformance) then) =
      _$BattingPerformanceCopyWithImpl<$Res, BattingPerformance>;
  @useResult
  $Res call(
      {int runs,
      int balls,
      int fours,
      int sixes,
      String strikeRate,
      String dismissal});
}

/// @nodoc
class _$BattingPerformanceCopyWithImpl<$Res, $Val extends BattingPerformance>
    implements $BattingPerformanceCopyWith<$Res> {
  _$BattingPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? runs = null,
    Object? balls = null,
    Object? fours = null,
    Object? sixes = null,
    Object? strikeRate = null,
    Object? dismissal = null,
  }) {
    return _then(_value.copyWith(
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      balls: null == balls
          ? _value.balls
          : balls // ignore: cast_nullable_to_non_nullable
              as int,
      fours: null == fours
          ? _value.fours
          : fours // ignore: cast_nullable_to_non_nullable
              as int,
      sixes: null == sixes
          ? _value.sixes
          : sixes // ignore: cast_nullable_to_non_nullable
              as int,
      strikeRate: null == strikeRate
          ? _value.strikeRate
          : strikeRate // ignore: cast_nullable_to_non_nullable
              as String,
      dismissal: null == dismissal
          ? _value.dismissal
          : dismissal // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BattingPerformanceImplCopyWith<$Res>
    implements $BattingPerformanceCopyWith<$Res> {
  factory _$$BattingPerformanceImplCopyWith(_$BattingPerformanceImpl value,
          $Res Function(_$BattingPerformanceImpl) then) =
      __$$BattingPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int runs,
      int balls,
      int fours,
      int sixes,
      String strikeRate,
      String dismissal});
}

/// @nodoc
class __$$BattingPerformanceImplCopyWithImpl<$Res>
    extends _$BattingPerformanceCopyWithImpl<$Res, _$BattingPerformanceImpl>
    implements _$$BattingPerformanceImplCopyWith<$Res> {
  __$$BattingPerformanceImplCopyWithImpl(_$BattingPerformanceImpl _value,
      $Res Function(_$BattingPerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of BattingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? runs = null,
    Object? balls = null,
    Object? fours = null,
    Object? sixes = null,
    Object? strikeRate = null,
    Object? dismissal = null,
  }) {
    return _then(_$BattingPerformanceImpl(
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      balls: null == balls
          ? _value.balls
          : balls // ignore: cast_nullable_to_non_nullable
              as int,
      fours: null == fours
          ? _value.fours
          : fours // ignore: cast_nullable_to_non_nullable
              as int,
      sixes: null == sixes
          ? _value.sixes
          : sixes // ignore: cast_nullable_to_non_nullable
              as int,
      strikeRate: null == strikeRate
          ? _value.strikeRate
          : strikeRate // ignore: cast_nullable_to_non_nullable
              as String,
      dismissal: null == dismissal
          ? _value.dismissal
          : dismissal // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BattingPerformanceImpl implements _BattingPerformance {
  const _$BattingPerformanceImpl(
      {required this.runs,
      required this.balls,
      required this.fours,
      required this.sixes,
      required this.strikeRate,
      required this.dismissal});

  factory _$BattingPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattingPerformanceImplFromJson(json);

  @override
  final int runs;
  @override
  final int balls;
  @override
  final int fours;
  @override
  final int sixes;
  @override
  final String strikeRate;
  @override
  final String dismissal;

  @override
  String toString() {
    return 'BattingPerformance(runs: $runs, balls: $balls, fours: $fours, sixes: $sixes, strikeRate: $strikeRate, dismissal: $dismissal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattingPerformanceImpl &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.balls, balls) || other.balls == balls) &&
            (identical(other.fours, fours) || other.fours == fours) &&
            (identical(other.sixes, sixes) || other.sixes == sixes) &&
            (identical(other.strikeRate, strikeRate) ||
                other.strikeRate == strikeRate) &&
            (identical(other.dismissal, dismissal) ||
                other.dismissal == dismissal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, runs, balls, fours, sixes, strikeRate, dismissal);

  /// Create a copy of BattingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattingPerformanceImplCopyWith<_$BattingPerformanceImpl> get copyWith =>
      __$$BattingPerformanceImplCopyWithImpl<_$BattingPerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BattingPerformanceImplToJson(
      this,
    );
  }
}

abstract class _BattingPerformance implements BattingPerformance {
  const factory _BattingPerformance(
      {required final int runs,
      required final int balls,
      required final int fours,
      required final int sixes,
      required final String strikeRate,
      required final String dismissal}) = _$BattingPerformanceImpl;

  factory _BattingPerformance.fromJson(Map<String, dynamic> json) =
      _$BattingPerformanceImpl.fromJson;

  @override
  int get runs;
  @override
  int get balls;
  @override
  int get fours;
  @override
  int get sixes;
  @override
  String get strikeRate;
  @override
  String get dismissal;

  /// Create a copy of BattingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattingPerformanceImplCopyWith<_$BattingPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BowlingPerformance _$BowlingPerformanceFromJson(Map<String, dynamic> json) {
  return _BowlingPerformance.fromJson(json);
}

/// @nodoc
mixin _$BowlingPerformance {
  int get overs => throw _privateConstructorUsedError;
  int get maidens => throw _privateConstructorUsedError;
  int get runs => throw _privateConstructorUsedError;
  int get wickets => throw _privateConstructorUsedError;
  String get economy => throw _privateConstructorUsedError;

  /// Serializes this BowlingPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BowlingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BowlingPerformanceCopyWith<BowlingPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BowlingPerformanceCopyWith<$Res> {
  factory $BowlingPerformanceCopyWith(
          BowlingPerformance value, $Res Function(BowlingPerformance) then) =
      _$BowlingPerformanceCopyWithImpl<$Res, BowlingPerformance>;
  @useResult
  $Res call({int overs, int maidens, int runs, int wickets, String economy});
}

/// @nodoc
class _$BowlingPerformanceCopyWithImpl<$Res, $Val extends BowlingPerformance>
    implements $BowlingPerformanceCopyWith<$Res> {
  _$BowlingPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BowlingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overs = null,
    Object? maidens = null,
    Object? runs = null,
    Object? wickets = null,
    Object? economy = null,
  }) {
    return _then(_value.copyWith(
      overs: null == overs
          ? _value.overs
          : overs // ignore: cast_nullable_to_non_nullable
              as int,
      maidens: null == maidens
          ? _value.maidens
          : maidens // ignore: cast_nullable_to_non_nullable
              as int,
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      wickets: null == wickets
          ? _value.wickets
          : wickets // ignore: cast_nullable_to_non_nullable
              as int,
      economy: null == economy
          ? _value.economy
          : economy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BowlingPerformanceImplCopyWith<$Res>
    implements $BowlingPerformanceCopyWith<$Res> {
  factory _$$BowlingPerformanceImplCopyWith(_$BowlingPerformanceImpl value,
          $Res Function(_$BowlingPerformanceImpl) then) =
      __$$BowlingPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int overs, int maidens, int runs, int wickets, String economy});
}

/// @nodoc
class __$$BowlingPerformanceImplCopyWithImpl<$Res>
    extends _$BowlingPerformanceCopyWithImpl<$Res, _$BowlingPerformanceImpl>
    implements _$$BowlingPerformanceImplCopyWith<$Res> {
  __$$BowlingPerformanceImplCopyWithImpl(_$BowlingPerformanceImpl _value,
      $Res Function(_$BowlingPerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of BowlingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overs = null,
    Object? maidens = null,
    Object? runs = null,
    Object? wickets = null,
    Object? economy = null,
  }) {
    return _then(_$BowlingPerformanceImpl(
      overs: null == overs
          ? _value.overs
          : overs // ignore: cast_nullable_to_non_nullable
              as int,
      maidens: null == maidens
          ? _value.maidens
          : maidens // ignore: cast_nullable_to_non_nullable
              as int,
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      wickets: null == wickets
          ? _value.wickets
          : wickets // ignore: cast_nullable_to_non_nullable
              as int,
      economy: null == economy
          ? _value.economy
          : economy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BowlingPerformanceImpl implements _BowlingPerformance {
  const _$BowlingPerformanceImpl(
      {required this.overs,
      required this.maidens,
      required this.runs,
      required this.wickets,
      required this.economy});

  factory _$BowlingPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$BowlingPerformanceImplFromJson(json);

  @override
  final int overs;
  @override
  final int maidens;
  @override
  final int runs;
  @override
  final int wickets;
  @override
  final String economy;

  @override
  String toString() {
    return 'BowlingPerformance(overs: $overs, maidens: $maidens, runs: $runs, wickets: $wickets, economy: $economy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BowlingPerformanceImpl &&
            (identical(other.overs, overs) || other.overs == overs) &&
            (identical(other.maidens, maidens) || other.maidens == maidens) &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.wickets, wickets) || other.wickets == wickets) &&
            (identical(other.economy, economy) || other.economy == economy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, overs, maidens, runs, wickets, economy);

  /// Create a copy of BowlingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BowlingPerformanceImplCopyWith<_$BowlingPerformanceImpl> get copyWith =>
      __$$BowlingPerformanceImplCopyWithImpl<_$BowlingPerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BowlingPerformanceImplToJson(
      this,
    );
  }
}

abstract class _BowlingPerformance implements BowlingPerformance {
  const factory _BowlingPerformance(
      {required final int overs,
      required final int maidens,
      required final int runs,
      required final int wickets,
      required final String economy}) = _$BowlingPerformanceImpl;

  factory _BowlingPerformance.fromJson(Map<String, dynamic> json) =
      _$BowlingPerformanceImpl.fromJson;

  @override
  int get overs;
  @override
  int get maidens;
  @override
  int get runs;
  @override
  int get wickets;
  @override
  String get economy;

  /// Create a copy of BowlingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BowlingPerformanceImplCopyWith<_$BowlingPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FieldingPerformance _$FieldingPerformanceFromJson(Map<String, dynamic> json) {
  return _FieldingPerformance.fromJson(json);
}

/// @nodoc
mixin _$FieldingPerformance {
  int get catches => throw _privateConstructorUsedError;
  int get runOuts => throw _privateConstructorUsedError;
  int get stumpings => throw _privateConstructorUsedError;

  /// Serializes this FieldingPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldingPerformanceCopyWith<FieldingPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldingPerformanceCopyWith<$Res> {
  factory $FieldingPerformanceCopyWith(
          FieldingPerformance value, $Res Function(FieldingPerformance) then) =
      _$FieldingPerformanceCopyWithImpl<$Res, FieldingPerformance>;
  @useResult
  $Res call({int catches, int runOuts, int stumpings});
}

/// @nodoc
class _$FieldingPerformanceCopyWithImpl<$Res, $Val extends FieldingPerformance>
    implements $FieldingPerformanceCopyWith<$Res> {
  _$FieldingPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catches = null,
    Object? runOuts = null,
    Object? stumpings = null,
  }) {
    return _then(_value.copyWith(
      catches: null == catches
          ? _value.catches
          : catches // ignore: cast_nullable_to_non_nullable
              as int,
      runOuts: null == runOuts
          ? _value.runOuts
          : runOuts // ignore: cast_nullable_to_non_nullable
              as int,
      stumpings: null == stumpings
          ? _value.stumpings
          : stumpings // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldingPerformanceImplCopyWith<$Res>
    implements $FieldingPerformanceCopyWith<$Res> {
  factory _$$FieldingPerformanceImplCopyWith(_$FieldingPerformanceImpl value,
          $Res Function(_$FieldingPerformanceImpl) then) =
      __$$FieldingPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int catches, int runOuts, int stumpings});
}

/// @nodoc
class __$$FieldingPerformanceImplCopyWithImpl<$Res>
    extends _$FieldingPerformanceCopyWithImpl<$Res, _$FieldingPerformanceImpl>
    implements _$$FieldingPerformanceImplCopyWith<$Res> {
  __$$FieldingPerformanceImplCopyWithImpl(_$FieldingPerformanceImpl _value,
      $Res Function(_$FieldingPerformanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of FieldingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? catches = null,
    Object? runOuts = null,
    Object? stumpings = null,
  }) {
    return _then(_$FieldingPerformanceImpl(
      catches: null == catches
          ? _value.catches
          : catches // ignore: cast_nullable_to_non_nullable
              as int,
      runOuts: null == runOuts
          ? _value.runOuts
          : runOuts // ignore: cast_nullable_to_non_nullable
              as int,
      stumpings: null == stumpings
          ? _value.stumpings
          : stumpings // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldingPerformanceImpl implements _FieldingPerformance {
  const _$FieldingPerformanceImpl(
      {this.catches = 0, this.runOuts = 0, this.stumpings = 0});

  factory _$FieldingPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldingPerformanceImplFromJson(json);

  @override
  @JsonKey()
  final int catches;
  @override
  @JsonKey()
  final int runOuts;
  @override
  @JsonKey()
  final int stumpings;

  @override
  String toString() {
    return 'FieldingPerformance(catches: $catches, runOuts: $runOuts, stumpings: $stumpings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldingPerformanceImpl &&
            (identical(other.catches, catches) || other.catches == catches) &&
            (identical(other.runOuts, runOuts) || other.runOuts == runOuts) &&
            (identical(other.stumpings, stumpings) ||
                other.stumpings == stumpings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, catches, runOuts, stumpings);

  /// Create a copy of FieldingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldingPerformanceImplCopyWith<_$FieldingPerformanceImpl> get copyWith =>
      __$$FieldingPerformanceImplCopyWithImpl<_$FieldingPerformanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldingPerformanceImplToJson(
      this,
    );
  }
}

abstract class _FieldingPerformance implements FieldingPerformance {
  const factory _FieldingPerformance(
      {final int catches,
      final int runOuts,
      final int stumpings}) = _$FieldingPerformanceImpl;

  factory _FieldingPerformance.fromJson(Map<String, dynamic> json) =
      _$FieldingPerformanceImpl.fromJson;

  @override
  int get catches;
  @override
  int get runOuts;
  @override
  int get stumpings;

  /// Create a copy of FieldingPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldingPerformanceImplCopyWith<_$FieldingPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
