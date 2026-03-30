// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      hostUserId: json['hostUserId'] as String,
      opponentCaptainId: json['opponentCaptainId'] as String?,
      scorerUserId: json['scorerUserId'] as String?,
      matchType: json['matchType'] as String,
      teamAName: json['teamAName'] as String,
      teamBName: json['teamBName'] as String?,
      venue: json['venue'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      status: json['status'] as String,
      invitationMessage: json['invitationMessage'] as String?,
      invitedAt: json['invitedAt'] == null
          ? null
          : DateTime.parse(json['invitedAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      declinedAt: json['declinedAt'] == null
          ? null
          : DateTime.parse(json['declinedAt'] as String),
      rules: json['rules'] as Map<String, dynamic>,
      proposedRules: json['proposedRules'] as Map<String, dynamic>?,
      rulesProposedBy: json['rulesProposedBy'] as String?,
      hostRulesApproved: json['hostRulesApproved'] as bool? ?? false,
      opponentRulesApproved: json['opponentRulesApproved'] as bool? ?? false,
      hostTeamReady: json['hostTeamReady'] as bool? ?? false,
      opponentTeamReady: json['opponentTeamReady'] as bool? ?? false,
      minPlayersPerTeam: (json['minPlayersPerTeam'] as num?)?.toInt() ?? 2,
      result: json['result'] as Map<String, dynamic>?,
      tossWinner: json['tossWinner'] as String?,
      tossDecision: json['tossDecision'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      finishedAt: json['finishedAt'] == null
          ? null
          : DateTime.parse(json['finishedAt'] as String),
      isDualCaptain: json['isDualCaptain'] as bool? ?? false,
      bothTeamsReady: json['bothTeamsReady'] as bool? ?? false,
      rulesAgreed: json['rulesAgreed'] as bool? ?? false,
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
      'opponentCaptainId': instance.opponentCaptainId,
      'scorerUserId': instance.scorerUserId,
      'matchType': instance.matchType,
      'teamAName': instance.teamAName,
      'teamBName': instance.teamBName,
      'venue': instance.venue,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'status': instance.status,
      'invitationMessage': instance.invitationMessage,
      'invitedAt': instance.invitedAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'declinedAt': instance.declinedAt?.toIso8601String(),
      'rules': instance.rules,
      'proposedRules': instance.proposedRules,
      'rulesProposedBy': instance.rulesProposedBy,
      'hostRulesApproved': instance.hostRulesApproved,
      'opponentRulesApproved': instance.opponentRulesApproved,
      'hostTeamReady': instance.hostTeamReady,
      'opponentTeamReady': instance.opponentTeamReady,
      'minPlayersPerTeam': instance.minPlayersPerTeam,
      'result': instance.result,
      'tossWinner': instance.tossWinner,
      'tossDecision': instance.tossDecision,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
      'isDualCaptain': instance.isDualCaptain,
      'bothTeamsReady': instance.bothTeamsReady,
      'rulesAgreed': instance.rulesAgreed,
      'currentInningsId': instance.currentInningsId,
      'battingTeam': instance.battingTeam,
      'teamARuns': instance.teamARuns,
      'teamAWickets': instance.teamAWickets,
      'teamAOvers': instance.teamAOvers,
      'teamBRuns': instance.teamBRuns,
      'teamBWickets': instance.teamBWickets,
      'teamBOvers': instance.teamBOvers,
    };

_$MatchRulesImpl _$$MatchRulesImplFromJson(Map<String, dynamic> json) =>
    _$MatchRulesImpl(
      oversLimit: (json['oversLimit'] as num?)?.toInt() ?? 6,
      powerplayOvers: (json['powerplayOvers'] as num?)?.toInt() ?? 0,
      maxOversPerBowler: (json['maxOversPerBowler'] as num?)?.toInt() ?? 0,
      wideBallRuns: (json['wideBallRuns'] as num?)?.toInt() ?? 1,
      noBallRuns: (json['noBallRuns'] as num?)?.toInt() ?? 1,
      freeHit: json['freeHit'] as bool? ?? true,
      superOver: json['superOver'] as bool? ?? false,
      minPlayersPerTeam: (json['minPlayersPerTeam'] as num?)?.toInt() ?? 2,
      maxPlayersPerTeam: (json['maxPlayersPerTeam'] as num?)?.toInt() ?? 11,
      lastManBatting: json['lastManBatting'] as bool? ?? false,
      tennisBall: json['tennisBall'] as bool? ?? true,
      boundaryRuns: (json['boundaryRuns'] as num?)?.toInt() ?? 4,
      scorerPermission: json['scorerPermission'] as String? ?? 'host_only',
    );

Map<String, dynamic> _$$MatchRulesImplToJson(_$MatchRulesImpl instance) =>
    <String, dynamic>{
      'oversLimit': instance.oversLimit,
      'powerplayOvers': instance.powerplayOvers,
      'maxOversPerBowler': instance.maxOversPerBowler,
      'wideBallRuns': instance.wideBallRuns,
      'noBallRuns': instance.noBallRuns,
      'freeHit': instance.freeHit,
      'superOver': instance.superOver,
      'minPlayersPerTeam': instance.minPlayersPerTeam,
      'maxPlayersPerTeam': instance.maxPlayersPerTeam,
      'lastManBatting': instance.lastManBatting,
      'tennisBall': instance.tennisBall,
      'boundaryRuns': instance.boundaryRuns,
      'scorerPermission': instance.scorerPermission,
    };

_$PlayerInMatchImpl _$$PlayerInMatchImplFromJson(Map<String, dynamic> json) =>
    _$PlayerInMatchImpl(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      userId: json['userId'] as String?,
      team: json['team'] as String,
      role: json['role'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
      guestName: json['guestName'] as String?,
      addedBy: json['addedBy'] as String?,
      displayName: json['displayName'] as String?,
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
      'isGuest': instance.isGuest,
      'guestName': instance.guestName,
      'addedBy': instance.addedBy,
      'displayName': instance.displayName,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'runsScored': instance.runsScored,
      'ballsFaced': instance.ballsFaced,
      'wicketsTaken': instance.wicketsTaken,
      'oversBowled': instance.oversBowled,
      'runsConceded': instance.runsConceded,
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
