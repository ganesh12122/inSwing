// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get hostUserId => throw _privateConstructorUsedError;
  String get matchType => throw _privateConstructorUsedError;
  String get teamAName => throw _privateConstructorUsedError;
  String get teamBName => throw _privateConstructorUsedError;
  String? get venue => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get rules => throw _privateConstructorUsedError;
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Computed fields
  String? get currentInningsId => throw _privateConstructorUsedError;
  String? get battingTeam => throw _privateConstructorUsedError;
  int? get teamARuns => throw _privateConstructorUsedError;
  int? get teamAWickets => throw _privateConstructorUsedError;
  double? get teamAOvers => throw _privateConstructorUsedError;
  int? get teamBRuns => throw _privateConstructorUsedError;
  int? get teamBWickets => throw _privateConstructorUsedError;
  double? get teamBOvers => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String id,
      String hostUserId,
      String matchType,
      String teamAName,
      String teamBName,
      String? venue,
      double? latitude,
      double? longitude,
      DateTime? scheduledAt,
      String status,
      Map<String, dynamic> rules,
      Map<String, dynamic>? result,
      DateTime createdAt,
      DateTime updatedAt,
      String? currentInningsId,
      String? battingTeam,
      int? teamARuns,
      int? teamAWickets,
      double? teamAOvers,
      int? teamBRuns,
      int? teamBWickets,
      double? teamBOvers});
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostUserId = null,
    Object? matchType = null,
    Object? teamAName = null,
    Object? teamBName = null,
    Object? venue = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? scheduledAt = freezed,
    Object? status = null,
    Object? rules = null,
    Object? result = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currentInningsId = freezed,
    Object? battingTeam = freezed,
    Object? teamARuns = freezed,
    Object? teamAWickets = freezed,
    Object? teamAOvers = freezed,
    Object? teamBRuns = freezed,
    Object? teamBWickets = freezed,
    Object? teamBOvers = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostUserId: null == hostUserId
          ? _value.hostUserId
          : hostUserId // ignore: cast_nullable_to_non_nullable
              as String,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as String,
      teamAName: null == teamAName
          ? _value.teamAName
          : teamAName // ignore: cast_nullable_to_non_nullable
              as String,
      teamBName: null == teamBName
          ? _value.teamBName
          : teamBName // ignore: cast_nullable_to_non_nullable
              as String,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentInningsId: freezed == currentInningsId
          ? _value.currentInningsId
          : currentInningsId // ignore: cast_nullable_to_non_nullable
              as String?,
      battingTeam: freezed == battingTeam
          ? _value.battingTeam
          : battingTeam // ignore: cast_nullable_to_non_nullable
              as String?,
      teamARuns: freezed == teamARuns
          ? _value.teamARuns
          : teamARuns // ignore: cast_nullable_to_non_nullable
              as int?,
      teamAWickets: freezed == teamAWickets
          ? _value.teamAWickets
          : teamAWickets // ignore: cast_nullable_to_non_nullable
              as int?,
      teamAOvers: freezed == teamAOvers
          ? _value.teamAOvers
          : teamAOvers // ignore: cast_nullable_to_non_nullable
              as double?,
      teamBRuns: freezed == teamBRuns
          ? _value.teamBRuns
          : teamBRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      teamBWickets: freezed == teamBWickets
          ? _value.teamBWickets
          : teamBWickets // ignore: cast_nullable_to_non_nullable
              as int?,
      teamBOvers: freezed == teamBOvers
          ? _value.teamBOvers
          : teamBOvers // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String hostUserId,
      String matchType,
      String teamAName,
      String teamBName,
      String? venue,
      double? latitude,
      double? longitude,
      DateTime? scheduledAt,
      String status,
      Map<String, dynamic> rules,
      Map<String, dynamic>? result,
      DateTime createdAt,
      DateTime updatedAt,
      String? currentInningsId,
      String? battingTeam,
      int? teamARuns,
      int? teamAWickets,
      double? teamAOvers,
      int? teamBRuns,
      int? teamBWickets,
      double? teamBOvers});
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostUserId = null,
    Object? matchType = null,
    Object? teamAName = null,
    Object? teamBName = null,
    Object? venue = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? scheduledAt = freezed,
    Object? status = null,
    Object? rules = null,
    Object? result = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? currentInningsId = freezed,
    Object? battingTeam = freezed,
    Object? teamARuns = freezed,
    Object? teamAWickets = freezed,
    Object? teamAOvers = freezed,
    Object? teamBRuns = freezed,
    Object? teamBWickets = freezed,
    Object? teamBOvers = freezed,
  }) {
    return _then(_$MatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostUserId: null == hostUserId
          ? _value.hostUserId
          : hostUserId // ignore: cast_nullable_to_non_nullable
              as String,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as String,
      teamAName: null == teamAName
          ? _value.teamAName
          : teamAName // ignore: cast_nullable_to_non_nullable
              as String,
      teamBName: null == teamBName
          ? _value.teamBName
          : teamBName // ignore: cast_nullable_to_non_nullable
              as String,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rules: null == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      result: freezed == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentInningsId: freezed == currentInningsId
          ? _value.currentInningsId
          : currentInningsId // ignore: cast_nullable_to_non_nullable
              as String?,
      battingTeam: freezed == battingTeam
          ? _value.battingTeam
          : battingTeam // ignore: cast_nullable_to_non_nullable
              as String?,
      teamARuns: freezed == teamARuns
          ? _value.teamARuns
          : teamARuns // ignore: cast_nullable_to_non_nullable
              as int?,
      teamAWickets: freezed == teamAWickets
          ? _value.teamAWickets
          : teamAWickets // ignore: cast_nullable_to_non_nullable
              as int?,
      teamAOvers: freezed == teamAOvers
          ? _value.teamAOvers
          : teamAOvers // ignore: cast_nullable_to_non_nullable
              as double?,
      teamBRuns: freezed == teamBRuns
          ? _value.teamBRuns
          : teamBRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      teamBWickets: freezed == teamBWickets
          ? _value.teamBWickets
          : teamBWickets // ignore: cast_nullable_to_non_nullable
              as int?,
      teamBOvers: freezed == teamBOvers
          ? _value.teamBOvers
          : teamBOvers // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl(
      {required this.id,
      required this.hostUserId,
      required this.matchType,
      required this.teamAName,
      required this.teamBName,
      this.venue,
      this.latitude,
      this.longitude,
      this.scheduledAt,
      required this.status,
      required final Map<String, dynamic> rules,
      final Map<String, dynamic>? result,
      required this.createdAt,
      required this.updatedAt,
      this.currentInningsId,
      this.battingTeam,
      this.teamARuns,
      this.teamAWickets,
      this.teamAOvers,
      this.teamBRuns,
      this.teamBWickets,
      this.teamBOvers})
      : _rules = rules,
        _result = result;

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String hostUserId;
  @override
  final String matchType;
  @override
  final String teamAName;
  @override
  final String teamBName;
  @override
  final String? venue;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final DateTime? scheduledAt;
  @override
  final String status;
  final Map<String, dynamic> _rules;
  @override
  Map<String, dynamic> get rules {
    if (_rules is EqualUnmodifiableMapView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rules);
  }

  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// Computed fields
  @override
  final String? currentInningsId;
  @override
  final String? battingTeam;
  @override
  final int? teamARuns;
  @override
  final int? teamAWickets;
  @override
  final double? teamAOvers;
  @override
  final int? teamBRuns;
  @override
  final int? teamBWickets;
  @override
  final double? teamBOvers;

  @override
  String toString() {
    return 'Match(id: $id, hostUserId: $hostUserId, matchType: $matchType, teamAName: $teamAName, teamBName: $teamBName, venue: $venue, latitude: $latitude, longitude: $longitude, scheduledAt: $scheduledAt, status: $status, rules: $rules, result: $result, createdAt: $createdAt, updatedAt: $updatedAt, currentInningsId: $currentInningsId, battingTeam: $battingTeam, teamARuns: $teamARuns, teamAWickets: $teamAWickets, teamAOvers: $teamAOvers, teamBRuns: $teamBRuns, teamBWickets: $teamBWickets, teamBOvers: $teamBOvers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostUserId, hostUserId) ||
                other.hostUserId == hostUserId) &&
            (identical(other.matchType, matchType) ||
                other.matchType == matchType) &&
            (identical(other.teamAName, teamAName) ||
                other.teamAName == teamAName) &&
            (identical(other.teamBName, teamBName) ||
                other.teamBName == teamBName) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currentInningsId, currentInningsId) ||
                other.currentInningsId == currentInningsId) &&
            (identical(other.battingTeam, battingTeam) ||
                other.battingTeam == battingTeam) &&
            (identical(other.teamARuns, teamARuns) ||
                other.teamARuns == teamARuns) &&
            (identical(other.teamAWickets, teamAWickets) ||
                other.teamAWickets == teamAWickets) &&
            (identical(other.teamAOvers, teamAOvers) ||
                other.teamAOvers == teamAOvers) &&
            (identical(other.teamBRuns, teamBRuns) ||
                other.teamBRuns == teamBRuns) &&
            (identical(other.teamBWickets, teamBWickets) ||
                other.teamBWickets == teamBWickets) &&
            (identical(other.teamBOvers, teamBOvers) ||
                other.teamBOvers == teamBOvers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        hostUserId,
        matchType,
        teamAName,
        teamBName,
        venue,
        latitude,
        longitude,
        scheduledAt,
        status,
        const DeepCollectionEquality().hash(_rules),
        const DeepCollectionEquality().hash(_result),
        createdAt,
        updatedAt,
        currentInningsId,
        battingTeam,
        teamARuns,
        teamAWickets,
        teamAOvers,
        teamBRuns,
        teamBWickets,
        teamBOvers
      ]);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  const factory _Match(
      {required final String id,
      required final String hostUserId,
      required final String matchType,
      required final String teamAName,
      required final String teamBName,
      final String? venue,
      final double? latitude,
      final double? longitude,
      final DateTime? scheduledAt,
      required final String status,
      required final Map<String, dynamic> rules,
      final Map<String, dynamic>? result,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? currentInningsId,
      final String? battingTeam,
      final int? teamARuns,
      final int? teamAWickets,
      final double? teamAOvers,
      final int? teamBRuns,
      final int? teamBWickets,
      final double? teamBOvers}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get hostUserId;
  @override
  String get matchType;
  @override
  String get teamAName;
  @override
  String get teamBName;
  @override
  String? get venue;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  DateTime? get scheduledAt;
  @override
  String get status;
  @override
  Map<String, dynamic> get rules;
  @override
  Map<String, dynamic>? get result;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // Computed fields
  @override
  String? get currentInningsId;
  @override
  String? get battingTeam;
  @override
  int? get teamARuns;
  @override
  int? get teamAWickets;
  @override
  double? get teamAOvers;
  @override
  int? get teamBRuns;
  @override
  int? get teamBWickets;
  @override
  double? get teamBOvers;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Innings _$InningsFromJson(Map<String, dynamic> json) {
  return _Innings.fromJson(json);
}

/// @nodoc
mixin _$Innings {
  String get id => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get battingTeam => throw _privateConstructorUsedError;
  int get oversAllocated => throw _privateConstructorUsedError;
  int get runs => throw _privateConstructorUsedError;
  int get wickets => throw _privateConstructorUsedError;
  int get extras => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Innings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InningsCopyWith<Innings> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InningsCopyWith<$Res> {
  factory $InningsCopyWith(Innings value, $Res Function(Innings) then) =
      _$InningsCopyWithImpl<$Res, Innings>;
  @useResult
  $Res call(
      {String id,
      String matchId,
      String battingTeam,
      int oversAllocated,
      int runs,
      int wickets,
      int extras,
      bool isCompleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$InningsCopyWithImpl<$Res, $Val extends Innings>
    implements $InningsCopyWith<$Res> {
  _$InningsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? battingTeam = null,
    Object? oversAllocated = null,
    Object? runs = null,
    Object? wickets = null,
    Object? extras = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      battingTeam: null == battingTeam
          ? _value.battingTeam
          : battingTeam // ignore: cast_nullable_to_non_nullable
              as String,
      oversAllocated: null == oversAllocated
          ? _value.oversAllocated
          : oversAllocated // ignore: cast_nullable_to_non_nullable
              as int,
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      wickets: null == wickets
          ? _value.wickets
          : wickets // ignore: cast_nullable_to_non_nullable
              as int,
      extras: null == extras
          ? _value.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
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
abstract class _$$InningsImplCopyWith<$Res> implements $InningsCopyWith<$Res> {
  factory _$$InningsImplCopyWith(
          _$InningsImpl value, $Res Function(_$InningsImpl) then) =
      __$$InningsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String matchId,
      String battingTeam,
      int oversAllocated,
      int runs,
      int wickets,
      int extras,
      bool isCompleted,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$InningsImplCopyWithImpl<$Res>
    extends _$InningsCopyWithImpl<$Res, _$InningsImpl>
    implements _$$InningsImplCopyWith<$Res> {
  __$$InningsImplCopyWithImpl(
      _$InningsImpl _value, $Res Function(_$InningsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? battingTeam = null,
    Object? oversAllocated = null,
    Object? runs = null,
    Object? wickets = null,
    Object? extras = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InningsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      battingTeam: null == battingTeam
          ? _value.battingTeam
          : battingTeam // ignore: cast_nullable_to_non_nullable
              as String,
      oversAllocated: null == oversAllocated
          ? _value.oversAllocated
          : oversAllocated // ignore: cast_nullable_to_non_nullable
              as int,
      runs: null == runs
          ? _value.runs
          : runs // ignore: cast_nullable_to_non_nullable
              as int,
      wickets: null == wickets
          ? _value.wickets
          : wickets // ignore: cast_nullable_to_non_nullable
              as int,
      extras: null == extras
          ? _value.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
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
class _$InningsImpl implements _Innings {
  const _$InningsImpl(
      {required this.id,
      required this.matchId,
      required this.battingTeam,
      required this.oversAllocated,
      required this.runs,
      required this.wickets,
      required this.extras,
      required this.isCompleted,
      required this.createdAt,
      required this.updatedAt});

  factory _$InningsImpl.fromJson(Map<String, dynamic> json) =>
      _$$InningsImplFromJson(json);

  @override
  final String id;
  @override
  final String matchId;
  @override
  final String battingTeam;
  @override
  final int oversAllocated;
  @override
  final int runs;
  @override
  final int wickets;
  @override
  final int extras;
  @override
  final bool isCompleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Innings(id: $id, matchId: $matchId, battingTeam: $battingTeam, oversAllocated: $oversAllocated, runs: $runs, wickets: $wickets, extras: $extras, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InningsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.battingTeam, battingTeam) ||
                other.battingTeam == battingTeam) &&
            (identical(other.oversAllocated, oversAllocated) ||
                other.oversAllocated == oversAllocated) &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.wickets, wickets) || other.wickets == wickets) &&
            (identical(other.extras, extras) || other.extras == extras) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, matchId, battingTeam,
      oversAllocated, runs, wickets, extras, isCompleted, createdAt, updatedAt);

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InningsImplCopyWith<_$InningsImpl> get copyWith =>
      __$$InningsImplCopyWithImpl<_$InningsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InningsImplToJson(
      this,
    );
  }
}

abstract class _Innings implements Innings {
  const factory _Innings(
      {required final String id,
      required final String matchId,
      required final String battingTeam,
      required final int oversAllocated,
      required final int runs,
      required final int wickets,
      required final int extras,
      required final bool isCompleted,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$InningsImpl;

  factory _Innings.fromJson(Map<String, dynamic> json) = _$InningsImpl.fromJson;

  @override
  String get id;
  @override
  String get matchId;
  @override
  String get battingTeam;
  @override
  int get oversAllocated;
  @override
  int get runs;
  @override
  int get wickets;
  @override
  int get extras;
  @override
  bool get isCompleted;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Innings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InningsImplCopyWith<_$InningsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ball _$BallFromJson(Map<String, dynamic> json) {
  return _Ball.fromJson(json);
}

/// @nodoc
mixin _$Ball {
  String get id => throw _privateConstructorUsedError;
  String get inningsId => throw _privateConstructorUsedError;
  int get overNumber => throw _privateConstructorUsedError;
  int get ballInOver => throw _privateConstructorUsedError;
  String get batsmanId => throw _privateConstructorUsedError;
  String? get nonStrikerId => throw _privateConstructorUsedError;
  String get bowlerId => throw _privateConstructorUsedError;
  int get runsOffBat => throw _privateConstructorUsedError;
  String? get extrasType => throw _privateConstructorUsedError;
  int get extrasRuns => throw _privateConstructorUsedError;
  String? get wicketType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get dismissalInfo => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Computed fields
  int? get totalRuns => throw _privateConstructorUsedError;
  bool? get isWicket => throw _privateConstructorUsedError;
  bool? get isBoundary => throw _privateConstructorUsedError;

  /// Serializes this Ball to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ball
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallCopyWith<Ball> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallCopyWith<$Res> {
  factory $BallCopyWith(Ball value, $Res Function(Ball) then) =
      _$BallCopyWithImpl<$Res, Ball>;
  @useResult
  $Res call(
      {String id,
      String inningsId,
      int overNumber,
      int ballInOver,
      String batsmanId,
      String? nonStrikerId,
      String bowlerId,
      int runsOffBat,
      String? extrasType,
      int extrasRuns,
      String? wicketType,
      Map<String, dynamic>? dismissalInfo,
      DateTime createdAt,
      int? totalRuns,
      bool? isWicket,
      bool? isBoundary});
}

/// @nodoc
class _$BallCopyWithImpl<$Res, $Val extends Ball>
    implements $BallCopyWith<$Res> {
  _$BallCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ball
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inningsId = null,
    Object? overNumber = null,
    Object? ballInOver = null,
    Object? batsmanId = null,
    Object? nonStrikerId = freezed,
    Object? bowlerId = null,
    Object? runsOffBat = null,
    Object? extrasType = freezed,
    Object? extrasRuns = null,
    Object? wicketType = freezed,
    Object? dismissalInfo = freezed,
    Object? createdAt = null,
    Object? totalRuns = freezed,
    Object? isWicket = freezed,
    Object? isBoundary = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inningsId: null == inningsId
          ? _value.inningsId
          : inningsId // ignore: cast_nullable_to_non_nullable
              as String,
      overNumber: null == overNumber
          ? _value.overNumber
          : overNumber // ignore: cast_nullable_to_non_nullable
              as int,
      ballInOver: null == ballInOver
          ? _value.ballInOver
          : ballInOver // ignore: cast_nullable_to_non_nullable
              as int,
      batsmanId: null == batsmanId
          ? _value.batsmanId
          : batsmanId // ignore: cast_nullable_to_non_nullable
              as String,
      nonStrikerId: freezed == nonStrikerId
          ? _value.nonStrikerId
          : nonStrikerId // ignore: cast_nullable_to_non_nullable
              as String?,
      bowlerId: null == bowlerId
          ? _value.bowlerId
          : bowlerId // ignore: cast_nullable_to_non_nullable
              as String,
      runsOffBat: null == runsOffBat
          ? _value.runsOffBat
          : runsOffBat // ignore: cast_nullable_to_non_nullable
              as int,
      extrasType: freezed == extrasType
          ? _value.extrasType
          : extrasType // ignore: cast_nullable_to_non_nullable
              as String?,
      extrasRuns: null == extrasRuns
          ? _value.extrasRuns
          : extrasRuns // ignore: cast_nullable_to_non_nullable
              as int,
      wicketType: freezed == wicketType
          ? _value.wicketType
          : wicketType // ignore: cast_nullable_to_non_nullable
              as String?,
      dismissalInfo: freezed == dismissalInfo
          ? _value.dismissalInfo
          : dismissalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalRuns: freezed == totalRuns
          ? _value.totalRuns
          : totalRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      isWicket: freezed == isWicket
          ? _value.isWicket
          : isWicket // ignore: cast_nullable_to_non_nullable
              as bool?,
      isBoundary: freezed == isBoundary
          ? _value.isBoundary
          : isBoundary // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BallImplCopyWith<$Res> implements $BallCopyWith<$Res> {
  factory _$$BallImplCopyWith(
          _$BallImpl value, $Res Function(_$BallImpl) then) =
      __$$BallImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String inningsId,
      int overNumber,
      int ballInOver,
      String batsmanId,
      String? nonStrikerId,
      String bowlerId,
      int runsOffBat,
      String? extrasType,
      int extrasRuns,
      String? wicketType,
      Map<String, dynamic>? dismissalInfo,
      DateTime createdAt,
      int? totalRuns,
      bool? isWicket,
      bool? isBoundary});
}

/// @nodoc
class __$$BallImplCopyWithImpl<$Res>
    extends _$BallCopyWithImpl<$Res, _$BallImpl>
    implements _$$BallImplCopyWith<$Res> {
  __$$BallImplCopyWithImpl(_$BallImpl _value, $Res Function(_$BallImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ball
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inningsId = null,
    Object? overNumber = null,
    Object? ballInOver = null,
    Object? batsmanId = null,
    Object? nonStrikerId = freezed,
    Object? bowlerId = null,
    Object? runsOffBat = null,
    Object? extrasType = freezed,
    Object? extrasRuns = null,
    Object? wicketType = freezed,
    Object? dismissalInfo = freezed,
    Object? createdAt = null,
    Object? totalRuns = freezed,
    Object? isWicket = freezed,
    Object? isBoundary = freezed,
  }) {
    return _then(_$BallImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inningsId: null == inningsId
          ? _value.inningsId
          : inningsId // ignore: cast_nullable_to_non_nullable
              as String,
      overNumber: null == overNumber
          ? _value.overNumber
          : overNumber // ignore: cast_nullable_to_non_nullable
              as int,
      ballInOver: null == ballInOver
          ? _value.ballInOver
          : ballInOver // ignore: cast_nullable_to_non_nullable
              as int,
      batsmanId: null == batsmanId
          ? _value.batsmanId
          : batsmanId // ignore: cast_nullable_to_non_nullable
              as String,
      nonStrikerId: freezed == nonStrikerId
          ? _value.nonStrikerId
          : nonStrikerId // ignore: cast_nullable_to_non_nullable
              as String?,
      bowlerId: null == bowlerId
          ? _value.bowlerId
          : bowlerId // ignore: cast_nullable_to_non_nullable
              as String,
      runsOffBat: null == runsOffBat
          ? _value.runsOffBat
          : runsOffBat // ignore: cast_nullable_to_non_nullable
              as int,
      extrasType: freezed == extrasType
          ? _value.extrasType
          : extrasType // ignore: cast_nullable_to_non_nullable
              as String?,
      extrasRuns: null == extrasRuns
          ? _value.extrasRuns
          : extrasRuns // ignore: cast_nullable_to_non_nullable
              as int,
      wicketType: freezed == wicketType
          ? _value.wicketType
          : wicketType // ignore: cast_nullable_to_non_nullable
              as String?,
      dismissalInfo: freezed == dismissalInfo
          ? _value._dismissalInfo
          : dismissalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalRuns: freezed == totalRuns
          ? _value.totalRuns
          : totalRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      isWicket: freezed == isWicket
          ? _value.isWicket
          : isWicket // ignore: cast_nullable_to_non_nullable
              as bool?,
      isBoundary: freezed == isBoundary
          ? _value.isBoundary
          : isBoundary // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BallImpl implements _Ball {
  const _$BallImpl(
      {required this.id,
      required this.inningsId,
      required this.overNumber,
      required this.ballInOver,
      required this.batsmanId,
      this.nonStrikerId,
      required this.bowlerId,
      required this.runsOffBat,
      this.extrasType,
      required this.extrasRuns,
      this.wicketType,
      final Map<String, dynamic>? dismissalInfo,
      required this.createdAt,
      this.totalRuns,
      this.isWicket,
      this.isBoundary})
      : _dismissalInfo = dismissalInfo;

  factory _$BallImpl.fromJson(Map<String, dynamic> json) =>
      _$$BallImplFromJson(json);

  @override
  final String id;
  @override
  final String inningsId;
  @override
  final int overNumber;
  @override
  final int ballInOver;
  @override
  final String batsmanId;
  @override
  final String? nonStrikerId;
  @override
  final String bowlerId;
  @override
  final int runsOffBat;
  @override
  final String? extrasType;
  @override
  final int extrasRuns;
  @override
  final String? wicketType;
  final Map<String, dynamic>? _dismissalInfo;
  @override
  Map<String, dynamic>? get dismissalInfo {
    final value = _dismissalInfo;
    if (value == null) return null;
    if (_dismissalInfo is EqualUnmodifiableMapView) return _dismissalInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
// Computed fields
  @override
  final int? totalRuns;
  @override
  final bool? isWicket;
  @override
  final bool? isBoundary;

  @override
  String toString() {
    return 'Ball(id: $id, inningsId: $inningsId, overNumber: $overNumber, ballInOver: $ballInOver, batsmanId: $batsmanId, nonStrikerId: $nonStrikerId, bowlerId: $bowlerId, runsOffBat: $runsOffBat, extrasType: $extrasType, extrasRuns: $extrasRuns, wicketType: $wicketType, dismissalInfo: $dismissalInfo, createdAt: $createdAt, totalRuns: $totalRuns, isWicket: $isWicket, isBoundary: $isBoundary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inningsId, inningsId) ||
                other.inningsId == inningsId) &&
            (identical(other.overNumber, overNumber) ||
                other.overNumber == overNumber) &&
            (identical(other.ballInOver, ballInOver) ||
                other.ballInOver == ballInOver) &&
            (identical(other.batsmanId, batsmanId) ||
                other.batsmanId == batsmanId) &&
            (identical(other.nonStrikerId, nonStrikerId) ||
                other.nonStrikerId == nonStrikerId) &&
            (identical(other.bowlerId, bowlerId) ||
                other.bowlerId == bowlerId) &&
            (identical(other.runsOffBat, runsOffBat) ||
                other.runsOffBat == runsOffBat) &&
            (identical(other.extrasType, extrasType) ||
                other.extrasType == extrasType) &&
            (identical(other.extrasRuns, extrasRuns) ||
                other.extrasRuns == extrasRuns) &&
            (identical(other.wicketType, wicketType) ||
                other.wicketType == wicketType) &&
            const DeepCollectionEquality()
                .equals(other._dismissalInfo, _dismissalInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.totalRuns, totalRuns) ||
                other.totalRuns == totalRuns) &&
            (identical(other.isWicket, isWicket) ||
                other.isWicket == isWicket) &&
            (identical(other.isBoundary, isBoundary) ||
                other.isBoundary == isBoundary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      inningsId,
      overNumber,
      ballInOver,
      batsmanId,
      nonStrikerId,
      bowlerId,
      runsOffBat,
      extrasType,
      extrasRuns,
      wicketType,
      const DeepCollectionEquality().hash(_dismissalInfo),
      createdAt,
      totalRuns,
      isWicket,
      isBoundary);

  /// Create a copy of Ball
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallImplCopyWith<_$BallImpl> get copyWith =>
      __$$BallImplCopyWithImpl<_$BallImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BallImplToJson(
      this,
    );
  }
}

abstract class _Ball implements Ball {
  const factory _Ball(
      {required final String id,
      required final String inningsId,
      required final int overNumber,
      required final int ballInOver,
      required final String batsmanId,
      final String? nonStrikerId,
      required final String bowlerId,
      required final int runsOffBat,
      final String? extrasType,
      required final int extrasRuns,
      final String? wicketType,
      final Map<String, dynamic>? dismissalInfo,
      required final DateTime createdAt,
      final int? totalRuns,
      final bool? isWicket,
      final bool? isBoundary}) = _$BallImpl;

  factory _Ball.fromJson(Map<String, dynamic> json) = _$BallImpl.fromJson;

  @override
  String get id;
  @override
  String get inningsId;
  @override
  int get overNumber;
  @override
  int get ballInOver;
  @override
  String get batsmanId;
  @override
  String? get nonStrikerId;
  @override
  String get bowlerId;
  @override
  int get runsOffBat;
  @override
  String? get extrasType;
  @override
  int get extrasRuns;
  @override
  String? get wicketType;
  @override
  Map<String, dynamic>? get dismissalInfo;
  @override
  DateTime get createdAt; // Computed fields
  @override
  int? get totalRuns;
  @override
  bool? get isWicket;
  @override
  bool? get isBoundary;

  /// Create a copy of Ball
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallImplCopyWith<_$BallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerInMatch _$PlayerInMatchFromJson(Map<String, dynamic> json) {
  return _PlayerInMatch.fromJson(json);
}

/// @nodoc
mixin _$PlayerInMatch {
  String get id => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get team => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  DateTime get joinedAt =>
      throw _privateConstructorUsedError; // Player stats for this match
  int? get runsScored => throw _privateConstructorUsedError;
  int? get ballsFaced => throw _privateConstructorUsedError;
  int? get wicketsTaken => throw _privateConstructorUsedError;
  int? get oversBowled => throw _privateConstructorUsedError;
  int? get runsConceded => throw _privateConstructorUsedError;

  /// Serializes this PlayerInMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerInMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerInMatchCopyWith<PlayerInMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerInMatchCopyWith<$Res> {
  factory $PlayerInMatchCopyWith(
          PlayerInMatch value, $Res Function(PlayerInMatch) then) =
      _$PlayerInMatchCopyWithImpl<$Res, PlayerInMatch>;
  @useResult
  $Res call(
      {String id,
      String matchId,
      String userId,
      String team,
      String? role,
      DateTime joinedAt,
      int? runsScored,
      int? ballsFaced,
      int? wicketsTaken,
      int? oversBowled,
      int? runsConceded});
}

/// @nodoc
class _$PlayerInMatchCopyWithImpl<$Res, $Val extends PlayerInMatch>
    implements $PlayerInMatchCopyWith<$Res> {
  _$PlayerInMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerInMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? userId = null,
    Object? team = null,
    Object? role = freezed,
    Object? joinedAt = null,
    Object? runsScored = freezed,
    Object? ballsFaced = freezed,
    Object? wicketsTaken = freezed,
    Object? oversBowled = freezed,
    Object? runsConceded = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      runsScored: freezed == runsScored
          ? _value.runsScored
          : runsScored // ignore: cast_nullable_to_non_nullable
              as int?,
      ballsFaced: freezed == ballsFaced
          ? _value.ballsFaced
          : ballsFaced // ignore: cast_nullable_to_non_nullable
              as int?,
      wicketsTaken: freezed == wicketsTaken
          ? _value.wicketsTaken
          : wicketsTaken // ignore: cast_nullable_to_non_nullable
              as int?,
      oversBowled: freezed == oversBowled
          ? _value.oversBowled
          : oversBowled // ignore: cast_nullable_to_non_nullable
              as int?,
      runsConceded: freezed == runsConceded
          ? _value.runsConceded
          : runsConceded // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerInMatchImplCopyWith<$Res>
    implements $PlayerInMatchCopyWith<$Res> {
  factory _$$PlayerInMatchImplCopyWith(
          _$PlayerInMatchImpl value, $Res Function(_$PlayerInMatchImpl) then) =
      __$$PlayerInMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String matchId,
      String userId,
      String team,
      String? role,
      DateTime joinedAt,
      int? runsScored,
      int? ballsFaced,
      int? wicketsTaken,
      int? oversBowled,
      int? runsConceded});
}

/// @nodoc
class __$$PlayerInMatchImplCopyWithImpl<$Res>
    extends _$PlayerInMatchCopyWithImpl<$Res, _$PlayerInMatchImpl>
    implements _$$PlayerInMatchImplCopyWith<$Res> {
  __$$PlayerInMatchImplCopyWithImpl(
      _$PlayerInMatchImpl _value, $Res Function(_$PlayerInMatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerInMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchId = null,
    Object? userId = null,
    Object? team = null,
    Object? role = freezed,
    Object? joinedAt = null,
    Object? runsScored = freezed,
    Object? ballsFaced = freezed,
    Object? wicketsTaken = freezed,
    Object? oversBowled = freezed,
    Object? runsConceded = freezed,
  }) {
    return _then(_$PlayerInMatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      runsScored: freezed == runsScored
          ? _value.runsScored
          : runsScored // ignore: cast_nullable_to_non_nullable
              as int?,
      ballsFaced: freezed == ballsFaced
          ? _value.ballsFaced
          : ballsFaced // ignore: cast_nullable_to_non_nullable
              as int?,
      wicketsTaken: freezed == wicketsTaken
          ? _value.wicketsTaken
          : wicketsTaken // ignore: cast_nullable_to_non_nullable
              as int?,
      oversBowled: freezed == oversBowled
          ? _value.oversBowled
          : oversBowled // ignore: cast_nullable_to_non_nullable
              as int?,
      runsConceded: freezed == runsConceded
          ? _value.runsConceded
          : runsConceded // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerInMatchImpl implements _PlayerInMatch {
  const _$PlayerInMatchImpl(
      {required this.id,
      required this.matchId,
      required this.userId,
      required this.team,
      this.role,
      required this.joinedAt,
      this.runsScored,
      this.ballsFaced,
      this.wicketsTaken,
      this.oversBowled,
      this.runsConceded});

  factory _$PlayerInMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerInMatchImplFromJson(json);

  @override
  final String id;
  @override
  final String matchId;
  @override
  final String userId;
  @override
  final String team;
  @override
  final String? role;
  @override
  final DateTime joinedAt;
// Player stats for this match
  @override
  final int? runsScored;
  @override
  final int? ballsFaced;
  @override
  final int? wicketsTaken;
  @override
  final int? oversBowled;
  @override
  final int? runsConceded;

  @override
  String toString() {
    return 'PlayerInMatch(id: $id, matchId: $matchId, userId: $userId, team: $team, role: $role, joinedAt: $joinedAt, runsScored: $runsScored, ballsFaced: $ballsFaced, wicketsTaken: $wicketsTaken, oversBowled: $oversBowled, runsConceded: $runsConceded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerInMatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.runsScored, runsScored) ||
                other.runsScored == runsScored) &&
            (identical(other.ballsFaced, ballsFaced) ||
                other.ballsFaced == ballsFaced) &&
            (identical(other.wicketsTaken, wicketsTaken) ||
                other.wicketsTaken == wicketsTaken) &&
            (identical(other.oversBowled, oversBowled) ||
                other.oversBowled == oversBowled) &&
            (identical(other.runsConceded, runsConceded) ||
                other.runsConceded == runsConceded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      matchId,
      userId,
      team,
      role,
      joinedAt,
      runsScored,
      ballsFaced,
      wicketsTaken,
      oversBowled,
      runsConceded);

  /// Create a copy of PlayerInMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerInMatchImplCopyWith<_$PlayerInMatchImpl> get copyWith =>
      __$$PlayerInMatchImplCopyWithImpl<_$PlayerInMatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerInMatchImplToJson(
      this,
    );
  }
}

abstract class _PlayerInMatch implements PlayerInMatch {
  const factory _PlayerInMatch(
      {required final String id,
      required final String matchId,
      required final String userId,
      required final String team,
      final String? role,
      required final DateTime joinedAt,
      final int? runsScored,
      final int? ballsFaced,
      final int? wicketsTaken,
      final int? oversBowled,
      final int? runsConceded}) = _$PlayerInMatchImpl;

  factory _PlayerInMatch.fromJson(Map<String, dynamic> json) =
      _$PlayerInMatchImpl.fromJson;

  @override
  String get id;
  @override
  String get matchId;
  @override
  String get userId;
  @override
  String get team;
  @override
  String? get role;
  @override
  DateTime get joinedAt; // Player stats for this match
  @override
  int? get runsScored;
  @override
  int? get ballsFaced;
  @override
  int? get wicketsTaken;
  @override
  int? get oversBowled;
  @override
  int? get runsConceded;

  /// Create a copy of PlayerInMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerInMatchImplCopyWith<_$PlayerInMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
