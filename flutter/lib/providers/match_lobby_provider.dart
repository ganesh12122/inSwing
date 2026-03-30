import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'match_lobby_provider.freezed.dart';
part 'match_lobby_provider.g.dart';

/// State for managing a single match through its dual-captain lifecycle
@freezed
class MatchLobbyState with _$MatchLobbyState {
  const factory MatchLobbyState({
    Match? match,
    TeamsResponse? teams,
    @Default(false) bool isLoading,
    @Default(false) bool isActionLoading,
    String? error,
    String? successMessage,
  }) = _MatchLobbyState;
}

@riverpod
class MatchLobby extends _$MatchLobby {
  late final ApiService _api;

  @override
  MatchLobbyState build() {
    _api = ref.watch(apiServiceProvider);
    return const MatchLobbyState();
  }

  /// Load match and teams data
  Future<void> loadMatch(String matchId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final match = await _api.getMatch(matchId);
      TeamsResponse? teams;
      // Load teams if match is past invitation stage
      if ([
        'accepted',
        'teams_ready',
        'rules_proposed',
        'rules_approved',
        'toss_done',
        'live',
        'finished'
      ].contains(match.status)) {
        teams = await _api.getTeams(matchId);
      }
      state = state.copyWith(match: match, teams: teams, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh match data
  Future<void> refresh() async {
    if (state.match == null) return;
    await loadMatch(state.match!.id);
  }

  /// Send invitation to opponent
  Future<bool> inviteOpponent(String opponentUserId, {String? message}) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      final match = await _api.inviteOpponent(
        matchId: state.match!.id,
        opponentUserId: opponentUserId,
        message: message,
      );
      state = state.copyWith(
        match: match,
        isActionLoading: false,
        successMessage: 'Invitation sent!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Accept invitation
  Future<bool> acceptInvitation(String teamBName) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      final match = await _api.acceptInvitation(
        matchId: state.match!.id,
        teamBName: teamBName,
      );
      state = state.copyWith(
        match: match,
        isActionLoading: false,
        successMessage: 'Invitation accepted!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Decline invitation
  Future<bool> declineInvitation() async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      await _api.declineInvitation(state.match!.id);
      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Invitation declined',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Add player to team
  Future<bool> addPlayer(
      {String? userId, String? guestName, String role = 'batsman'}) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      await _api.addPlayerToTeam(
        matchId: state.match!.id,
        userId: userId,
        guestName: guestName,
        role: role,
      );
      // Refresh teams
      final teams = await _api.getTeams(state.match!.id);
      final match = await _api.getMatch(state.match!.id);
      state = state.copyWith(
        match: match,
        teams: teams,
        isActionLoading: false,
        successMessage: 'Player added!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Remove player from team
  Future<bool> removePlayer(String playerRecordId) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      await _api.removePlayerFromTeam(
        matchId: state.match!.id,
        playerRecordId: playerRecordId,
      );
      final teams = await _api.getTeams(state.match!.id);
      final match = await _api.getMatch(state.match!.id);
      state = state.copyWith(
        match: match,
        teams: teams,
        isActionLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Set team ready
  Future<bool> setTeamReady({bool ready = true}) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      final match =
          await _api.setTeamReady(matchId: state.match!.id, ready: ready);
      state = state.copyWith(
        match: match,
        isActionLoading: false,
        successMessage:
            ready ? 'Team marked as ready!' : 'Team marked as not ready',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Propose rules
  Future<bool> proposeRules(Map<String, dynamic> rules) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      final match =
          await _api.proposeRules(matchId: state.match!.id, rules: rules);
      state = state.copyWith(
        match: match,
        isActionLoading: false,
        successMessage: 'Rules proposed!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Approve rules
  Future<bool> approveRules() async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      final match = await _api.approveRules(state.match!.id);
      state = state.copyWith(
        match: match,
        isActionLoading: false,
        successMessage: 'Rules approved! ✅',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Record toss
  Future<bool> recordToss(String tossWinner, String tossDecision) async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      final match = await _api.recordToss(
        matchId: state.match!.id,
        tossWinner: tossWinner,
        tossDecision: tossDecision,
      );
      state = state.copyWith(
        match: match,
        isActionLoading: false,
        successMessage: 'Toss recorded!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  /// Cancel match
  Future<bool> cancelMatch() async {
    if (state.match == null) return false;
    state = state.copyWith(isActionLoading: true, error: null);
    try {
      await _api.cancelMatch(state.match!.id);
      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'Match cancelled',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isActionLoading: false, error: e.toString());
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}
