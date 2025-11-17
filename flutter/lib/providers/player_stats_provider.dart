import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

final playerStatsProvider = FutureProvider.family<PlayerStats?, String>((ref, playerId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getPlayerStats(playerId);
});