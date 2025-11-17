// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'player',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'role': instance.role,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      primaryRole: json['primaryRole'] as String? ?? 'batsman',
      overallRating: (json['overallRating'] as num?)?.toDouble() ?? 0,
      playerLevel: json['playerLevel'] as String? ?? 'Beginner',
      city: json['city'] as String?,
      state: json['state'] as String?,
      joinDate: DateTime.parse(json['joinDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'primaryRole': instance.primaryRole,
      'overallRating': instance.overallRating,
      'playerLevel': instance.playerLevel,
      'city': instance.city,
      'state': instance.state,
      'joinDate': instance.joinDate.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$PlayerStatsImpl _$$PlayerStatsImplFromJson(Map<String, dynamic> json) =>
    _$PlayerStatsImpl(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      primaryRole: json['primaryRole'] as String,
      overallRating: (json['overallRating'] as num).toDouble(),
      playerLevel: json['playerLevel'] as String,
      joinDate: json['joinDate'] as String,
      debutDate: json['debutDate'] as String,
      totalMatches: (json['totalMatches'] as num).toInt(),
      battingStats:
          BattingStats.fromJson(json['battingStats'] as Map<String, dynamic>),
      bowlingStats:
          BowlingStats.fromJson(json['bowlingStats'] as Map<String, dynamic>),
      fieldingStats:
          FieldingStats.fromJson(json['fieldingStats'] as Map<String, dynamic>),
      recentMatches: (json['recentMatches'] as List<dynamic>)
          .map((e) => MatchPerformance.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstCenturyDate: json['firstCenturyDate'] as String?,
      firstFiftyDate: json['firstFiftyDate'] as String?,
      firstFiveWicketDate: json['firstFiveWicketDate'] as String?,
    );

Map<String, dynamic> _$$PlayerStatsImplToJson(_$PlayerStatsImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'primaryRole': instance.primaryRole,
      'overallRating': instance.overallRating,
      'playerLevel': instance.playerLevel,
      'joinDate': instance.joinDate,
      'debutDate': instance.debutDate,
      'totalMatches': instance.totalMatches,
      'battingStats': instance.battingStats,
      'bowlingStats': instance.bowlingStats,
      'fieldingStats': instance.fieldingStats,
      'recentMatches': instance.recentMatches,
      'firstCenturyDate': instance.firstCenturyDate,
      'firstFiftyDate': instance.firstFiftyDate,
      'firstFiveWicketDate': instance.firstFiveWicketDate,
    };

_$BattingStatsImpl _$$BattingStatsImplFromJson(Map<String, dynamic> json) =>
    _$BattingStatsImpl(
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      innings: (json['innings'] as num?)?.toInt() ?? 0,
      runs: (json['runs'] as num?)?.toInt() ?? 0,
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      strikeRate: (json['strikeRate'] as num?)?.toDouble() ?? 0.0,
      highestScore: (json['highestScore'] as num?)?.toInt() ?? 0,
      fifties: (json['fifties'] as num?)?.toInt() ?? 0,
      hundreds: (json['hundreds'] as num?)?.toInt() ?? 0,
      fours: (json['fours'] as num?)?.toInt() ?? 0,
      sixes: (json['sixes'] as num?)?.toInt() ?? 0,
      ballsFaced: (json['ballsFaced'] as num?)?.toInt() ?? 0,
      notOuts: json['notOuts'] as String? ?? '0',
    );

Map<String, dynamic> _$$BattingStatsImplToJson(_$BattingStatsImpl instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'innings': instance.innings,
      'runs': instance.runs,
      'average': instance.average,
      'strikeRate': instance.strikeRate,
      'highestScore': instance.highestScore,
      'fifties': instance.fifties,
      'hundreds': instance.hundreds,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'ballsFaced': instance.ballsFaced,
      'notOuts': instance.notOuts,
    };

_$BowlingStatsImpl _$$BowlingStatsImplFromJson(Map<String, dynamic> json) =>
    _$BowlingStatsImpl(
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      innings: (json['innings'] as num?)?.toInt() ?? 0,
      balls: (json['balls'] as num?)?.toInt() ?? 0,
      runsConceded: (json['runsConceded'] as num?)?.toInt() ?? 0,
      wickets: (json['wickets'] as num?)?.toInt() ?? 0,
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      economy: (json['economy'] as num?)?.toDouble() ?? 0.0,
      strikeRate: (json['strikeRate'] as num?)?.toDouble() ?? 0.0,
      bestBowling: json['bestBowling'] as String? ?? '0/0',
      fiveWicketHauls: (json['fiveWicketHauls'] as num?)?.toInt() ?? 0,
      tenWicketHauls: (json['tenWicketHauls'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BowlingStatsImplToJson(_$BowlingStatsImpl instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'innings': instance.innings,
      'balls': instance.balls,
      'runsConceded': instance.runsConceded,
      'wickets': instance.wickets,
      'average': instance.average,
      'economy': instance.economy,
      'strikeRate': instance.strikeRate,
      'bestBowling': instance.bestBowling,
      'fiveWicketHauls': instance.fiveWicketHauls,
      'tenWicketHauls': instance.tenWicketHauls,
    };

_$FieldingStatsImpl _$$FieldingStatsImplFromJson(Map<String, dynamic> json) =>
    _$FieldingStatsImpl(
      catches: (json['catches'] as num?)?.toInt() ?? 0,
      runOuts: (json['runOuts'] as num?)?.toInt() ?? 0,
      stumpings: (json['stumpings'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FieldingStatsImplToJson(_$FieldingStatsImpl instance) =>
    <String, dynamic>{
      'catches': instance.catches,
      'runOuts': instance.runOuts,
      'stumpings': instance.stumpings,
    };

_$MatchPerformanceImpl _$$MatchPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$MatchPerformanceImpl(
      matchId: json['matchId'] as String,
      teamAName: json['teamAName'] as String,
      teamBName: json['teamBName'] as String,
      date: json['date'] as String,
      battingPerformance: json['battingPerformance'] == null
          ? null
          : BattingPerformance.fromJson(
              json['battingPerformance'] as Map<String, dynamic>),
      bowlingPerformance: json['bowlingPerformance'] == null
          ? null
          : BowlingPerformance.fromJson(
              json['bowlingPerformance'] as Map<String, dynamic>),
      fieldingPerformance: json['fieldingPerformance'] == null
          ? null
          : FieldingPerformance.fromJson(
              json['fieldingPerformance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MatchPerformanceImplToJson(
        _$MatchPerformanceImpl instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'teamAName': instance.teamAName,
      'teamBName': instance.teamBName,
      'date': instance.date,
      'battingPerformance': instance.battingPerformance,
      'bowlingPerformance': instance.bowlingPerformance,
      'fieldingPerformance': instance.fieldingPerformance,
    };

_$BattingPerformanceImpl _$$BattingPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$BattingPerformanceImpl(
      runs: (json['runs'] as num).toInt(),
      balls: (json['balls'] as num).toInt(),
      fours: (json['fours'] as num).toInt(),
      sixes: (json['sixes'] as num).toInt(),
      strikeRate: json['strikeRate'] as String,
      dismissal: json['dismissal'] as String,
    );

Map<String, dynamic> _$$BattingPerformanceImplToJson(
        _$BattingPerformanceImpl instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'strikeRate': instance.strikeRate,
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
      runOuts: (json['runOuts'] as num?)?.toInt() ?? 0,
      stumpings: (json['stumpings'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FieldingPerformanceImplToJson(
        _$FieldingPerformanceImpl instance) =>
    <String, dynamic>{
      'catches': instance.catches,
      'runOuts': instance.runOuts,
      'stumpings': instance.stumpings,
    };
