// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String? ?? 'player',
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone_number': instance.phoneNumber,
      'full_name': instance.fullName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'role': instance.role,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      primaryRole: json['primary_role'] as String? ?? 'batsman',
      overallRating: (json['overall_rating'] as num?)?.toDouble() ?? 0,
      playerLevel: json['player_level'] as String? ?? 'Beginner',
      city: json['city'] as String?,
      state: json['state'] as String?,
      joinDate: DateTime.parse(json['join_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'primary_role': instance.primaryRole,
      'overall_rating': instance.overallRating,
      'player_level': instance.playerLevel,
      'city': instance.city,
      'state': instance.state,
      'join_date': instance.joinDate.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$PlayerStatsImpl _$$PlayerStatsImplFromJson(Map<String, dynamic> json) =>
    _$PlayerStatsImpl(
      playerId: json['player_id'] as String,
      playerName: json['player_name'] as String,
      primaryRole: json['primary_role'] as String,
      overallRating: (json['overall_rating'] as num).toDouble(),
      playerLevel: json['player_level'] as String,
      joinDate: json['join_date'] as String,
      debutDate: json['debut_date'] as String,
      totalMatches: (json['total_matches'] as num).toInt(),
      battingStats:
          BattingStats.fromJson(json['batting_stats'] as Map<String, dynamic>),
      bowlingStats:
          BowlingStats.fromJson(json['bowling_stats'] as Map<String, dynamic>),
      fieldingStats: FieldingStats.fromJson(
          json['fielding_stats'] as Map<String, dynamic>),
      recentMatches: (json['recent_matches'] as List<dynamic>)
          .map((e) => MatchPerformance.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstCenturyDate: json['first_century_date'] as String?,
      firstFiftyDate: json['first_fifty_date'] as String?,
      firstFiveWicketDate: json['first_five_wicket_date'] as String?,
    );

Map<String, dynamic> _$$PlayerStatsImplToJson(_$PlayerStatsImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'player_name': instance.playerName,
      'primary_role': instance.primaryRole,
      'overall_rating': instance.overallRating,
      'player_level': instance.playerLevel,
      'join_date': instance.joinDate,
      'debut_date': instance.debutDate,
      'total_matches': instance.totalMatches,
      'batting_stats': instance.battingStats.toJson(),
      'bowling_stats': instance.bowlingStats.toJson(),
      'fielding_stats': instance.fieldingStats.toJson(),
      'recent_matches': instance.recentMatches.map((e) => e.toJson()).toList(),
      'first_century_date': instance.firstCenturyDate,
      'first_fifty_date': instance.firstFiftyDate,
      'first_five_wicket_date': instance.firstFiveWicketDate,
    };

_$BattingStatsImpl _$$BattingStatsImplFromJson(Map<String, dynamic> json) =>
    _$BattingStatsImpl(
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      innings: (json['innings'] as num?)?.toInt() ?? 0,
      runs: (json['runs'] as num?)?.toInt() ?? 0,
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      strikeRate: (json['strike_rate'] as num?)?.toDouble() ?? 0.0,
      highestScore: (json['highest_score'] as num?)?.toInt() ?? 0,
      fifties: (json['fifties'] as num?)?.toInt() ?? 0,
      hundreds: (json['hundreds'] as num?)?.toInt() ?? 0,
      fours: (json['fours'] as num?)?.toInt() ?? 0,
      sixes: (json['sixes'] as num?)?.toInt() ?? 0,
      ballsFaced: (json['balls_faced'] as num?)?.toInt() ?? 0,
      notOuts: json['not_outs'] as String? ?? '0',
    );

Map<String, dynamic> _$$BattingStatsImplToJson(_$BattingStatsImpl instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'innings': instance.innings,
      'runs': instance.runs,
      'average': instance.average,
      'strike_rate': instance.strikeRate,
      'highest_score': instance.highestScore,
      'fifties': instance.fifties,
      'hundreds': instance.hundreds,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'balls_faced': instance.ballsFaced,
      'not_outs': instance.notOuts,
    };

_$BowlingStatsImpl _$$BowlingStatsImplFromJson(Map<String, dynamic> json) =>
    _$BowlingStatsImpl(
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      innings: (json['innings'] as num?)?.toInt() ?? 0,
      balls: (json['balls'] as num?)?.toInt() ?? 0,
      runsConceded: (json['runs_conceded'] as num?)?.toInt() ?? 0,
      wickets: (json['wickets'] as num?)?.toInt() ?? 0,
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      economy: (json['economy'] as num?)?.toDouble() ?? 0.0,
      strikeRate: (json['strike_rate'] as num?)?.toDouble() ?? 0.0,
      bestBowling: json['best_bowling'] as String? ?? '0/0',
      fiveWicketHauls: (json['five_wicket_hauls'] as num?)?.toInt() ?? 0,
      tenWicketHauls: (json['ten_wicket_hauls'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BowlingStatsImplToJson(_$BowlingStatsImpl instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'innings': instance.innings,
      'balls': instance.balls,
      'runs_conceded': instance.runsConceded,
      'wickets': instance.wickets,
      'average': instance.average,
      'economy': instance.economy,
      'strike_rate': instance.strikeRate,
      'best_bowling': instance.bestBowling,
      'five_wicket_hauls': instance.fiveWicketHauls,
      'ten_wicket_hauls': instance.tenWicketHauls,
    };

_$FieldingStatsImpl _$$FieldingStatsImplFromJson(Map<String, dynamic> json) =>
    _$FieldingStatsImpl(
      catches: (json['catches'] as num?)?.toInt() ?? 0,
      runOuts: (json['run_outs'] as num?)?.toInt() ?? 0,
      stumpings: (json['stumpings'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FieldingStatsImplToJson(_$FieldingStatsImpl instance) =>
    <String, dynamic>{
      'catches': instance.catches,
      'run_outs': instance.runOuts,
      'stumpings': instance.stumpings,
    };

_$MatchPerformanceImpl _$$MatchPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$MatchPerformanceImpl(
      matchId: json['match_id'] as String,
      teamAName: json['team_a_name'] as String,
      teamBName: json['team_b_name'] as String,
      date: json['date'] as String,
      battingPerformance: json['batting_performance'] == null
          ? null
          : BattingPerformance.fromJson(
              json['batting_performance'] as Map<String, dynamic>),
      bowlingPerformance: json['bowling_performance'] == null
          ? null
          : BowlingPerformance.fromJson(
              json['bowling_performance'] as Map<String, dynamic>),
      fieldingPerformance: json['fielding_performance'] == null
          ? null
          : FieldingPerformance.fromJson(
              json['fielding_performance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MatchPerformanceImplToJson(
        _$MatchPerformanceImpl instance) =>
    <String, dynamic>{
      'match_id': instance.matchId,
      'team_a_name': instance.teamAName,
      'team_b_name': instance.teamBName,
      'date': instance.date,
      'batting_performance': instance.battingPerformance?.toJson(),
      'bowling_performance': instance.bowlingPerformance?.toJson(),
      'fielding_performance': instance.fieldingPerformance?.toJson(),
    };

_$BattingPerformanceImpl _$$BattingPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$BattingPerformanceImpl(
      runs: (json['runs'] as num).toInt(),
      balls: (json['balls'] as num).toInt(),
      fours: (json['fours'] as num).toInt(),
      sixes: (json['sixes'] as num).toInt(),
      strikeRate: json['strike_rate'] as String,
      dismissal: json['dismissal'] as String,
    );

Map<String, dynamic> _$$BattingPerformanceImplToJson(
        _$BattingPerformanceImpl instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'strike_rate': instance.strikeRate,
      'dismissal': instance.dismissal,
    };

_$BowlingPerformanceImpl _$$BowlingPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$BowlingPerformanceImpl(
      overs: (json['overs'] as num).toInt(),
      maidens: (json['maidens'] as num).toInt(),
      runs: (json['runs'] as num).toInt(),
      wickets: (json['wickets'] as num).toInt(),
      economy: json['economy'] as String,
    );

Map<String, dynamic> _$$BowlingPerformanceImplToJson(
        _$BowlingPerformanceImpl instance) =>
    <String, dynamic>{
      'overs': instance.overs,
      'maidens': instance.maidens,
      'runs': instance.runs,
      'wickets': instance.wickets,
      'economy': instance.economy,
    };

_$FieldingPerformanceImpl _$$FieldingPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$FieldingPerformanceImpl(
      catches: (json['catches'] as num?)?.toInt() ?? 0,
      runOuts: (json['run_outs'] as num?)?.toInt() ?? 0,
      stumpings: (json['stumpings'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FieldingPerformanceImplToJson(
        _$FieldingPerformanceImpl instance) =>
    <String, dynamic>{
      'catches': instance.catches,
      'run_outs': instance.runOuts,
      'stumpings': instance.stumpings,
    };
