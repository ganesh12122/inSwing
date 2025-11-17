import 'package:inswing/models/match_model.dart';
import 'package:inswing/services/api_service.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_match_provider.g.dart';

@riverpod
class CreateMatch extends _$CreateMatch {
  @override
  Future<Match?> build() async {
    // Initial state - no match being created
    return null;
  }

  Future<Match> createMatch(Map<String, dynamic> matchData) async {
    state = const AsyncValue.loading();
    
    try {
      final apiService = ref.read(apiServiceProvider);
      
      // Create match through API
      final match = await apiService.createMatch(matchData);
      
      // Cache the match locally
      await StorageService.saveMatch(match);
      
      state = AsyncValue.data(match);
      return match;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}