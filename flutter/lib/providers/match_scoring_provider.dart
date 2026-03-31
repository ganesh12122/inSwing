import 'dart:async';

import 'package:inswing/models/match_model.dart';
import 'package:inswing/services/api_service.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'match_scoring_provider.g.dart';

@riverpod
class MatchScoring extends _$MatchScoring {
  @override
  Future<Match> build() async {
    // This provider requires loadMatch() to be called after construction.
    // Return a "never completing" future so the UI shows loading state
    // until loadMatch() is explicitly called.
    final completer = Completer<Match>();
    ref.onDispose(() {
      if (!completer.isCompleted) completer.completeError('disposed');
    });
    return completer.future;
  }

  Future<void> loadMatch(String matchId) async {
    state = const AsyncValue.loading();

    try {
      final apiService = ref.read(apiServiceProvider);

      // Try to load from local storage first
      final localMatch = await StorageService.getMatch(matchId);
      if (localMatch != null) {
        state = AsyncValue.data(localMatch);
      }

      // Then fetch from API to get latest updates
      final match = await apiService.getMatch(matchId);

      // Cache the match locally
      await StorageService.saveMatch(match);

      state = AsyncValue.data(match);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> recordBall({
    required String matchId,
    required int runs,
    required bool isExtra,
    String? extraType,
  }) async {
    final currentMatch = state.value;
    if (currentMatch == null) return;

    try {
      final apiService = ref.read(apiServiceProvider);

      // Record the ball through API
      final updatedMatch = await apiService.recordMatchBall(
        matchId: matchId,
        runs: runs,
        isExtra: isExtra,
        extraType: extraType,
      );

      // Update local cache
      await StorageService.saveMatch(updatedMatch);

      state = AsyncValue.data(updatedMatch);
    } catch (e) {
      // If API fails, queue for offline sync
      await _queueOfflineAction('record_ball', {
        'matchId': matchId,
        'runs': runs,
        'isExtra': isExtra,
        'extraType': extraType,
      });

      // Update local state optimistically
      final updatedMatch = _updateMatchLocally(currentMatch, {
        'type': 'ball',
        'runs': runs,
        'isExtra': isExtra,
        'extraType': extraType,
      });

      state = AsyncValue.data(updatedMatch);
    }
  }

  Future<void> recordExtra({
    required String matchId,
    required String type,
  }) async {
    await recordBall(
      matchId: matchId,
      runs: type == 'wide' || type == 'no_ball' ? 1 : 0,
      isExtra: true,
      extraType: type,
    );
  }

  Future<void> recordWicket({
    required String matchId,
    required String type,
  }) async {
    final currentMatch = state.value;
    if (currentMatch == null) return;

    try {
      final apiService = ref.read(apiServiceProvider);

      final updatedMatch = await apiService.recordWicket(
        matchId: matchId,
        type: type,
      );

      await StorageService.saveMatch(updatedMatch);
      state = AsyncValue.data(updatedMatch);
    } catch (e) {
      await _queueOfflineAction('record_wicket', {
        'matchId': matchId,
        'type': type,
      });

      final updatedMatch = _updateMatchLocally(currentMatch, {
        'type': 'wicket',
        'wicketType': type,
      });

      state = AsyncValue.data(updatedMatch);
    }
  }

  Future<void> undoLastBall(String matchId) async {
    final currentMatch = state.value;
    if (currentMatch == null) return;

    try {
      final apiService = ref.read(apiServiceProvider);

      final updatedMatch = await apiService.undoLastBall(matchId);

      await StorageService.saveMatch(updatedMatch);
      state = AsyncValue.data(updatedMatch);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> switchInnings(String matchId) async {
    final currentMatch = state.value;
    if (currentMatch == null) return;

    try {
      final apiService = ref.read(apiServiceProvider);

      final updatedMatch = await apiService.switchInnings(matchId);

      await StorageService.saveMatch(updatedMatch);
      state = AsyncValue.data(updatedMatch);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _queueOfflineAction(
      String action, Map<String, dynamic> data) async {
    await StorageService.addToOfflineQueue({
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Match _updateMatchLocally(Match match, Map<String, dynamic> action) {
    // This is a simplified local update - in a real app, you'd implement
    // proper match state logic here
    return match.copyWith(
      updatedAt: DateTime.now(),
    );
  }
}

// Extension to get current innings
// Removed unsupported extensions for Match/Innings
