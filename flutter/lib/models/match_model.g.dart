// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      hostUserId: json['hostUserId'] as String,
      matchType: json['matchType'] as String,
      teamAName: json['teamAName'] as String,
      teamBName: json['teamBName'] as String,
      venue: json['venue'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      status: json['status'] as String,
      rules: json['rules'] as Map<String, dynamic>,
      result: json['result'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      currentInningsId: json['currentInningsId'] as String?,
      battingTeam: json['battingTeam'] as String?,
      teamARuns: (json['teamARuns'] as num?)?.toInt(),
      teamAWickets: (json['teamAWickets'] as num?)?.toInt(),
      teamAOvers: (json['teamAOvers'] as num?)?.toDouble(),
      teamBRuns: (json['teamBRuns'] as num?)?.toInt(),
      teamBWickets: (json['teamBWickets'] as num?)?.toInt(),
      teamBOvers: (json['teamBOvers'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostUserId': instance.hostUserId,
      'matchType': instance.matchType,
      'teamAName': instance.teamAName,
      'teamBName': instance.teamBName,
      'venue': instance.venue,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'status': instance.status,
      'rules': instance.rules,
      'result': instance.result,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'currentInningsId': instance.currentInningsId,
      'battingTeam': instance.battingTeam,
      'teamARuns': instance.teamARuns,
      'teamAWickets': instance.teamAWickets,
      'teamAOvers': instance.teamAOvers,
      'teamBRuns': instance.teamBRuns,
      'teamBWickets': instance.teamBWickets,
      'teamBOvers': instance.teamBOvers,
    };

_$InningsImpl _$$InningsImplFromJson(Map<String, dynamic> json) =>
    _$InningsImpl(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      battingTeam: json['battingTeam'] as String,
      oversAllocated: (json['oversAllocated'] as num).toInt(),
      runs: (json['runs'] as num).toInt(),
      wickets: (json['wickets'] as num).toInt(),
      extras: (json['extras'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InningsImplToJson(_$InningsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'battingTeam': instance.battingTeam,
      'oversAllocated': instance.oversAllocated,
      'runs': instance.runs,
      'wickets': instance.wickets,
      'extras': instance.extras,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$BallImpl _$$BallImplFromJson(Map<String, dynamic> json) => _$BallImpl(
      id: json['id'] as String,
      inningsId: json['inningsId'] as String,
      overNumber: (json['overNumber'] as num).toInt(),
      ballInOver: (json['ballInOver'] as num).toInt(),
      batsmanId: json['batsmanId'] as String,
      nonStrikerId: json['nonStrikerId'] as String?,
      bowlerId: json['bowlerId'] as String,
      runsOffBat: (json['runsOffBat'] as num).toInt(),
      extrasType: json['extrasType'] as String?,
      extrasRuns: (json['extrasRuns'] as num).toInt(),
      wicketType: json['wicketType'] as String?,
      dismissalInfo: json['dismissalInfo'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalRuns: (json['totalRuns'] as num?)?.toInt(),
      isWicket: json['isWicket'] as bool?,
      isBoundary: json['isBoundary'] as bool?,
    );

Map<String, dynamic> _$$BallImplToJson(_$BallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inningsId': instance.inningsId,
      'overNumber': instance.overNumber,
      'ballInOver': instance.ballInOver,
      'batsmanId': instance.batsmanId,
      'nonStrikerId': instance.nonStrikerId,
      'bowlerId': instance.bowlerId,
      'runsOffBat': instance.runsOffBat,
      'extrasType': instance.extrasType,
      'extrasRuns': instance.extrasRuns,
      'wicketType': instance.wicketType,
      'dismissalInfo': instance.dismissalInfo,
      'createdAt': instance.createdAt.toIso8601String(),
      'totalRuns': instance.totalRuns,
      'isWicket': instance.isWicket,
      'isBoundary': instance.isBoundary,
    };

_$PlayerInMatchImpl _$$PlayerInMatchImplFromJson(Map<String, dynamic> json) =>
    _$PlayerInMatchImpl(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      userId: json['userId'] as String,
      team: json['team'] as String,
      role: json['role'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      runsScored: (json['runsScored'] as num?)?.toInt(),
      ballsFaced: (json['ballsFaced'] as num?)?.toInt(),
      wicketsTaken: (json['wicketsTaken'] as num?)?.toInt(),
      oversBowled: (json['oversBowled'] as num?)?.toInt(),
      runsConceded: (json['runsConceded'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PlayerInMatchImplToJson(_$PlayerInMatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'userId': instance.userId,
      'team': instance.team,
      'role': instance.role,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'runsScored': instance.runsScored,
      'ballsFaced': instance.ballsFaced,
      'wicketsTaken': instance.wicketsTaken,
      'oversBowled': instance.oversBowled,
      'runsConceded': instance.runsConceded,
    };
