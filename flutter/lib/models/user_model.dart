import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    String? phoneNumber,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? bio,
    @Default('player') String role,
    @Default(true) bool isActive,
    @Default(false) bool isVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String userId,
    required String name,
    String? email,
    String? avatarUrl,
    @Default('batsman') String primaryRole,
    @Default(0) double overallRating,
    @Default('Beginner') String playerLevel,
    String? city,
    String? state,
    required DateTime joinDate,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class PlayerStats with _$PlayerStats {
  const factory PlayerStats({
    required String playerId,
    required String playerName,
    required String primaryRole,
    required double overallRating,
    required String playerLevel,
    required String joinDate,
    required String debutDate,
    required int totalMatches,
    required BattingStats battingStats,
    required BowlingStats bowlingStats,
    required FieldingStats fieldingStats,
    required List<MatchPerformance> recentMatches,
    String? firstCenturyDate,
    String? firstFiftyDate,
    String? firstFiveWicketDate,
  }) = _PlayerStats;

  factory PlayerStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsFromJson(json);
}

@freezed
class BattingStats with _$BattingStats {
  const factory BattingStats({
    @Default(0) int matches,
    @Default(0) int innings,
    @Default(0) int runs,
    @Default(0.0) double average,
    @Default(0.0) double strikeRate,
    @Default(0) int highestScore,
    @Default(0) int fifties,
    @Default(0) int hundreds,
    @Default(0) int fours,
    @Default(0) int sixes,
    @Default(0) int ballsFaced,
    @Default('0') String notOuts,
  }) = _BattingStats;

  factory BattingStats.fromJson(Map<String, dynamic> json) =>
      _$BattingStatsFromJson(json);
}

@freezed
class BowlingStats with _$BowlingStats {
  const factory BowlingStats({
    @Default(0) int matches,
    @Default(0) int innings,
    @Default(0) int balls,
    @Default(0) int runsConceded,
    @Default(0) int wickets,
    @Default(0.0) double average,
    @Default(0.0) double economy,
    @Default(0.0) double strikeRate,
    @Default('0/0') String bestBowling,
    @Default(0) int fiveWicketHauls,
    @Default(0) int tenWicketHauls,
  }) = _BowlingStats;

  factory BowlingStats.fromJson(Map<String, dynamic> json) =>
      _$BowlingStatsFromJson(json);
}

@freezed
class FieldingStats with _$FieldingStats {
  const factory FieldingStats({
    @Default(0) int catches,
    @Default(0) int runOuts,
    @Default(0) int stumpings,
  }) = _FieldingStats;

  factory FieldingStats.fromJson(Map<String, dynamic> json) =>
      _$FieldingStatsFromJson(json);
}

@freezed
class MatchPerformance with _$MatchPerformance {
  const factory MatchPerformance({
    required String matchId,
    required String teamAName,
    required String teamBName,
    required String date,
    BattingPerformance? battingPerformance,
    BowlingPerformance? bowlingPerformance,
    FieldingPerformance? fieldingPerformance,
  }) = _MatchPerformance;

  factory MatchPerformance.fromJson(Map<String, dynamic> json) =>
      _$MatchPerformanceFromJson(json);
}

@freezed
class BattingPerformance with _$BattingPerformance {
  const factory BattingPerformance({
    required int runs,
    required int balls,
    required int fours,
    required int sixes,
    required String strikeRate,
    required String dismissal,
  }) = _BattingPerformance;

  factory BattingPerformance.fromJson(Map<String, dynamic> json) =>
      _$BattingPerformanceFromJson(json);
}

@freezed
class BowlingPerformance with _$BowlingPerformance {
  const factory BowlingPerformance({
    required int overs,
    required int maidens,
    required int runs,
    required int wickets,
    required String economy,
  }) = _BowlingPerformance;

  factory BowlingPerformance.fromJson(Map<String, dynamic> json) =>
      _$BowlingPerformanceFromJson(json);
}

@freezed
class FieldingPerformance with _$FieldingPerformance {
  const factory FieldingPerformance({
    @Default(0) int catches,
    @Default(0) int runOuts,
    @Default(0) int stumpings,
  }) = _FieldingPerformance;

  factory FieldingPerformance.fromJson(Map<String, dynamic> json) =>
      _$FieldingPerformanceFromJson(json);
}
