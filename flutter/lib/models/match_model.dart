import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String hostUserId,
    required String matchType,
    required String teamAName,
    required String teamBName,
    String? venue,
    double? latitude,
    double? longitude,
    DateTime? scheduledAt,
    required String status,
    required Map<String, dynamic> rules,
    Map<String, dynamic>? result,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Computed fields
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

  factory Innings.fromJson(Map<String, dynamic> json) => _$InningsFromJson(json);
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

@freezed
class PlayerInMatch with _$PlayerInMatch {
  const factory PlayerInMatch({
    required String id,
    required String matchId,
    required String userId,
    required String team,
    String? role,
    required DateTime joinedAt,
    // Player stats for this match
    int? runsScored,
    int? ballsFaced,
    int? wicketsTaken,
    int? oversBowled,
    int? runsConceded,
  }) = _PlayerInMatch;

  factory PlayerInMatch.fromJson(Map<String, dynamic> json) =>
      _$PlayerInMatchFromJson(json);
}