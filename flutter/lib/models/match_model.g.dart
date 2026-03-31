// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchRulesImpl _$$MatchRulesImplFromJson(Map<String, dynamic> json) =>
    _$MatchRulesImpl(
      oversLimit: (json['overs_limit'] as num?)?.toInt() ?? 6,
      powerplayOvers: (json['powerplay_overs'] as num?)?.toInt() ?? 0,
      maxOversPerBowler: (json['max_overs_per_bowler'] as num?)?.toInt() ?? 0,
      wideBallRuns: (json['wide_ball_runs'] as num?)?.toInt() ?? 1,
      noBallRuns: (json['no_ball_runs'] as num?)?.toInt() ?? 1,
      freeHit: json['free_hit'] as bool? ?? true,
      superOver: json['super_over'] as bool? ?? false,
      minPlayersPerTeam: (json['min_players_per_team'] as num?)?.toInt() ?? 2,
      maxPlayersPerTeam: (json['max_players_per_team'] as num?)?.toInt() ?? 11,
      lastManBatting: json['last_man_batting'] as bool? ?? false,
      tennisBall: json['tennis_ball'] as bool? ?? true,
      boundaryRuns: (json['boundary_runs'] as num?)?.toInt() ?? 4,
      scorerPermission: json['scorer_permission'] as String? ?? 'host_only',
    );

Map<String, dynamic> _$$MatchRulesImplToJson(_$MatchRulesImpl instance) =>
    <String, dynamic>{
      'overs_limit': instance.oversLimit,
      'powerplay_overs': instance.powerplayOvers,
      'max_overs_per_bowler': instance.maxOversPerBowler,
      'wide_ball_runs': instance.wideBallRuns,
      'no_ball_runs': instance.noBallRuns,
      'free_hit': instance.freeHit,
      'super_over': instance.superOver,
      'min_players_per_team': instance.minPlayersPerTeam,
      'max_players_per_team': instance.maxPlayersPerTeam,
      'last_man_batting': instance.lastManBatting,
      'tennis_ball': instance.tennisBall,
      'boundary_runs': instance.boundaryRuns,
      'scorer_permission': instance.scorerPermission,
    };

_$PlayerInMatchImpl _$$PlayerInMatchImplFromJson(Map<String, dynamic> json) =>
    _$PlayerInMatchImpl(
      id: json['id'] as String,
      matchId: json['match_id'] as String,
      userId: json['user_id'] as String?,
      team: json['team'] as String,
      role: json['role'] as String?,
      isGuest: json['is_guest'] as bool? ?? false,
      guestName: json['guest_name'] as String?,
      addedBy: json['added_by'] as String?,
      displayName: json['display_name'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      runsScored: (json['runs_scored'] as num?)?.toInt(),
      ballsFaced: (json['balls_faced'] as num?)?.toInt(),
      wicketsTaken: (json['wickets_taken'] as num?)?.toInt(),
      oversBowled: (json['overs_bowled'] as num?)?.toInt(),
      runsConceded: (json['runs_conceded'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PlayerInMatchImplToJson(_$PlayerInMatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'match_id': instance.matchId,
      'user_id': instance.userId,
      'team': instance.team,
      'role': instance.role,
      'is_guest': instance.isGuest,
      'guest_name': instance.guestName,
      'added_by': instance.addedBy,
      'display_name': instance.displayName,
      'joined_at': instance.joinedAt.toIso8601String(),
      'runs_scored': instance.runsScored,
      'balls_faced': instance.ballsFaced,
      'wickets_taken': instance.wicketsTaken,
      'overs_bowled': instance.oversBowled,
      'runs_conceded': instance.runsConceded,
    };

_$InningsImpl _$$InningsImplFromJson(Map<String, dynamic> json) =>
    _$InningsImpl(
      id: json['id'] as String,
      matchId: json['match_id'] as String,
      battingTeam: json['batting_team'] as String,
      oversAllocated: (json['overs_allocated'] as num).toInt(),
      runs: (json['runs'] as num).toInt(),
      wickets: (json['wickets'] as num).toInt(),
      extras: (json['extras'] as num).toInt(),
      isCompleted: json['is_completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InningsImplToJson(_$InningsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'match_id': instance.matchId,
      'batting_team': instance.battingTeam,
      'overs_allocated': instance.oversAllocated,
      'runs': instance.runs,
      'wickets': instance.wickets,
      'extras': instance.extras,
      'is_completed': instance.isCompleted,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$BallImpl _$$BallImplFromJson(Map<String, dynamic> json) => _$BallImpl(
      id: json['id'] as String,
      inningsId: json['innings_id'] as String,
      overNumber: (json['over_number'] as num).toInt(),
      ballInOver: (json['ball_in_over'] as num).toInt(),
      batsmanId: json['batsman_id'] as String,
      nonStrikerId: json['non_striker_id'] as String?,
      bowlerId: json['bowler_id'] as String,
      runsOffBat: (json['runs_off_bat'] as num).toInt(),
      extrasType: json['extras_type'] as String?,
      extrasRuns: (json['extras_runs'] as num).toInt(),
      wicketType: json['wicket_type'] as String?,
      dismissalInfo: json['dismissal_info'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      totalRuns: (json['total_runs'] as num?)?.toInt(),
      isWicket: json['is_wicket'] as bool?,
      isBoundary: json['is_boundary'] as bool?,
    );

Map<String, dynamic> _$$BallImplToJson(_$BallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'innings_id': instance.inningsId,
      'over_number': instance.overNumber,
      'ball_in_over': instance.ballInOver,
      'batsman_id': instance.batsmanId,
      'non_striker_id': instance.nonStrikerId,
      'bowler_id': instance.bowlerId,
      'runs_off_bat': instance.runsOffBat,
      'extras_type': instance.extrasType,
      'extras_runs': instance.extrasRuns,
      'wicket_type': instance.wicketType,
      'dismissal_info': instance.dismissalInfo,
      'created_at': instance.createdAt.toIso8601String(),
      'total_runs': instance.totalRuns,
      'is_wicket': instance.isWicket,
      'is_boundary': instance.isBoundary,
    };
