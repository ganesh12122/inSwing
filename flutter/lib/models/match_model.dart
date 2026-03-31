import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

// Helper functions for LinkedMap fix on web — ensures Map<dynamic, dynamic>
// from dart:convert is properly cast to Map<String, dynamic>
Map<String, dynamic> _mapFromDynamic(dynamic value) =>
    Map<String, dynamic>.from(value as Map);

Map<String, dynamic>? _nullableMapFromDynamic(dynamic value) =>
    value != null ? Map<String, dynamic>.from(value as Map) : null;

// ignore_for_file: invalid_annotation_target

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String hostUserId,
    String? opponentCaptainId,
    String? scorerUserId,
    required String matchType,
    required String teamAName,
    String? teamBName,
    String? venue,
    double? latitude,
    double? longitude,
    DateTime? scheduledAt,
    required String status,
    // Invitation
    String? invitationMessage,
    DateTime? invitedAt,
    DateTime? acceptedAt,
    DateTime? declinedAt,
    // Rules
    @JsonKey(fromJson: _mapFromDynamic) required Map<String, dynamic> rules,
    @JsonKey(fromJson: _nullableMapFromDynamic)
    Map<String, dynamic>? proposedRules,
    String? rulesProposedBy,
    @Default(false) bool hostRulesApproved,
    @Default(false) bool opponentRulesApproved,
    // Team readiness
    @Default(false) bool hostTeamReady,
    @Default(false) bool opponentTeamReady,
    @Default(2) int minPlayersPerTeam,
    // Result
    @JsonKey(fromJson: _nullableMapFromDynamic) Map<String, dynamic>? result,
    // Toss
    String? tossWinner,
    String? tossDecision,
    // Timestamps
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    // Computed fields from API
    @Default(false) bool isDualCaptain,
    @Default(false) bool bothTeamsReady,
    @Default(false) bool rulesAgreed,
    // Legacy computed fields for scoring screen
    String? currentInningsId,
    String? battingTeam,
    int? teamARuns,
    int? teamAWickets,
    double? teamAOvers,
    int? teamBRuns,
    int? teamBWickets,
    double? teamBOvers,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
class MatchRules with _$MatchRules {
  const factory MatchRules({
    @Default(6) int oversLimit,
    @Default(0) int powerplayOvers,
    @Default(0) int maxOversPerBowler,
    @Default(1) int wideBallRuns,
    @Default(1) int noBallRuns,
    @Default(true) bool freeHit,
    @Default(false) bool superOver,
    @Default(2) int minPlayersPerTeam,
    @Default(11) int maxPlayersPerTeam,
    @Default(false) bool lastManBatting,
    @Default(true) bool tennisBall,
    @Default(4) int boundaryRuns,
    @Default('host_only') String scorerPermission,
  }) = _MatchRules;

  factory MatchRules.fromJson(Map<String, dynamic> json) =>
      _$MatchRulesFromJson(json);
}

@freezed
class PlayerInMatch with _$PlayerInMatch {
  const factory PlayerInMatch({
    required String id,
    required String matchId,
    String? userId,
    required String team,
    String? role,
    @Default(false) bool isGuest,
    String? guestName,
    String? addedBy,
    String? displayName,
    required DateTime joinedAt,
    // Player stats for this match (computed)
    int? runsScored,
    int? ballsFaced,
    int? wicketsTaken,
    int? oversBowled,
    int? runsConceded,
  }) = _PlayerInMatch;

  factory PlayerInMatch.fromJson(Map<String, dynamic> json) =>
      _$PlayerInMatchFromJson(json);
}

@freezed
class TeamInfo with _$TeamInfo {
  const factory TeamInfo({
    required String name,
    required List<PlayerInMatch> players,
    required int count,
    required bool ready,
  }) = _TeamInfo;

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      name: json['name'] as String? ?? '',
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => PlayerInMatch.fromJson(Map<String, dynamic>.from(p)))
              .toList() ??
          [],
      count: json['count'] as int? ?? 0,
      ready: json['ready'] as bool? ?? false,
    );
  }
}

@freezed
class TeamsResponse with _$TeamsResponse {
  const factory TeamsResponse({
    required TeamInfo teamA,
    required TeamInfo teamB,
    @Default(2) int minPlayers,
  }) = _TeamsResponse;

  factory TeamsResponse.fromJson(Map<String, dynamic> json) {
    return TeamsResponse(
      teamA: TeamInfo.fromJson(Map<String, dynamic>.from(json['team_a'])),
      teamB: TeamInfo.fromJson(Map<String, dynamic>.from(json['team_b'])),
      minPlayers: json['min_players'] as int? ?? 2,
    );
  }
}

@freezed
class Innings with _$Innings {
  const factory Innings({
    required String id,
    required String matchId,
    required String battingTeam,
    required int oversAllocated,
    required int runs,
    required int wickets,
    required int extras,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Innings;

  factory Innings.fromJson(Map<String, dynamic> json) =>
      _$InningsFromJson(json);
}

@freezed
class Ball with _$Ball {
  const factory Ball({
    required String id,
    required String inningsId,
    required int overNumber,
    required int ballInOver,
    required String batsmanId,
    String? nonStrikerId,
    required String bowlerId,
    required int runsOffBat,
    String? extrasType,
    required int extrasRuns,
    String? wicketType,
    Map<String, dynamic>? dismissalInfo,
    required DateTime createdAt,
    // Computed fields
    int? totalRuns,
    bool? isWicket,
    bool? isBoundary,
  }) = _Ball;

  factory Ball.fromJson(Map<String, dynamic> json) => _$BallFromJson(json);
}
