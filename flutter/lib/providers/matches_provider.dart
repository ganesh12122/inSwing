import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/services/api_service.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'matches_provider.freezed.dart';
part 'matches_provider.g.dart';

/// Matches state
@freezed
class MatchesState with _$MatchesState {
  const factory MatchesState.loading() = _MatchesStateLoading;
  const factory MatchesState.data(List<Match> matches) = _MatchesStateData;
  const factory MatchesState.error(String message) = _MatchesStateError;
}

/// Matches provider for managing match data
@riverpod
class Matches extends _$Matches {
  late final ApiService _apiService;
  String _currentFilter = 'all';

  @override
  MatchesState build() {
    _apiService = ref.watch(apiServiceProvider);
    return const MatchesState.loading();
  }

  /// Load matches from API or cache
  Future<void> loadMatches() async {
    state = const MatchesState.loading();
    
    try {
      // Try to get cached matches first
      final cachedMatches = StorageService.getMatches();
      if (cachedMatches.isNotEmpty) {
        state = MatchesState.data(_applyFilter(cachedMatches));
      }
      
      // Fetch fresh data from API
      await refreshMatches();
    } catch (e) {
      // If we have cached data, show it with an error
      final cachedMatches = StorageService.getMatches();
      if (cachedMatches.isNotEmpty) {
        state = MatchesState.data(_applyFilter(cachedMatches));
      } else {
        state = MatchesState.error(e.toString());
      }
    }
  }

  /// Refresh matches from API
  Future<void> refreshMatches() async {
    try {
      final matches = await _apiService.getMatches();
      
      // Cache the matches
      await StorageService.saveMatches(matches);
      
      state = MatchesState.data(_applyFilter(matches));
    } catch (e) {
      // If we have cached data, keep it but show error
      final cachedMatches = StorageService.getMatches();
      if (cachedMatches.isNotEmpty) {
        state = MatchesState.data(_applyFilter(cachedMatches));
      } else {
        state = MatchesState.error(e.toString());
      }
    }
  }

  /// Filter matches by type
  void filterMatches(String filter) {
    _currentFilter = filter;
    
    final currentState = state;
    if (currentState is _MatchesStateData) {
      state = MatchesState.data(_applyFilter(currentState.matches));
    }
  }

  /// Apply current filter to matches
  List<Match> _applyFilter(List<Match> matches) {
    if (_currentFilter == 'all') {
      return matches;
    }
    
    return matches.where((match) => match.matchType == _currentFilter).toList();
  }

  /// Get match by ID
  Match? getMatch(String matchId) {
    final currentState = state;
    if (currentState is _MatchesStateData) {
      try {
        return currentState.matches.firstWhere((m) => m.id == matchId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Update match in state
  void updateMatch(Match updatedMatch) {
    final currentState = state;
    if (currentState is _MatchesStateData) {
      final updatedMatches = currentState.matches.map((match) {
        return match.id == updatedMatch.id ? updatedMatch : match;
      }).toList();
      
      state = MatchesState.data(_applyFilter(updatedMatches));
      
      // Update cache
      StorageService.saveMatches(updatedMatches);
    }
  }

  /// Add new match to state
  void addMatch(Match newMatch) {
    final currentState = state;
    if (currentState is _MatchesStateData) {
      final updatedMatches = [newMatch, ...currentState.matches];
      state = MatchesState.data(_applyFilter(updatedMatches));
      
      // Update cache
      StorageService.saveMatches(updatedMatches);
    }
  }
}