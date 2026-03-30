import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inswing/models/user_model.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:inswing/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// API service for communicating with the backend
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.addAll([
      // Auth interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await StorageService.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshResponse = await _refreshToken(refreshToken);
                final newToken = refreshResponse['access_token'];
                await StorageService.storeAuthToken(newToken);
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final retryResponse = await _dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              } catch (e) {
                await StorageService.clearSecureStorage();
                return handler.reject(error);
              }
            }
          }
          return handler.reject(error);
        },
      ),
      // Logging interceptor (only in debug mode)
      if (const bool.fromEnvironment('dart.vm.product') == false)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }

  // ===========================================================================
  // AUTH
  // ===========================================================================

  Future<Map<String, dynamic>> _refreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    return response.data;
  }

  Future<bool> requestOtp(String phoneNumber) async {
    try {
      final response = await _dio.post('/auth/request-otp', data: {
        'phone_number': phoneNumber,
      });
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtpAndLogin(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'phone_number': phoneNumber,
        'otp_code': otp,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // USERS
  // ===========================================================================

  Future<User> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/profile');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw _handleError(e);
    }
  }

  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    try {
      final response = await _dio.put(
        '/users/${profile.userId}/profile',
        data: profile.toJson(),
      );
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Search users by phone number or name
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await _dio.get('/search/users', queryParameters: {
        'q': query,
      });
      final data = response.data;
      if (data is Map && data.containsKey('users')) {
        return (data['users'] as List)
            .map((json) => User.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // MATCHES — CRUD
  // ===========================================================================

  Future<Match> createMatch(Map<String, dynamic> matchData) async {
    try {
      final response = await _dio.post('/matches', data: matchData);
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Match>> getMatches({
    String? status,
    String? matchType,
    String? userId,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dio.get('/matches', queryParameters: {
        if (status != null) 'status': status,
        if (matchType != null) 'match_type': matchType,
        if (userId != null) 'user_id': userId,
        'page': page,
        'per_page': perPage,
      });

      final data = response.data;
      if (data is Map && data.containsKey('matches')) {
        return (data['matches'] as List)
            .map((json) => Match.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      if (data is List) {
        return data.map((json) => Match.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Match>> getMyMatches({String? status}) async {
    try {
      final response = await _dio.get('/matches/my', queryParameters: {
        if (status != null) 'status': status,
      });
      final data = response.data;
      if (data is Map && data.containsKey('matches')) {
        return (data['matches'] as List)
            .map((json) => Match.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Match> getMatch(String matchId) async {
    try {
      final response = await _dio.get('/matches/$matchId');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Match> updateMatchStatus(String matchId, String status) async {
    try {
      final response = await _dio.put(
        '/matches/$matchId/status',
        queryParameters: {'new_status': status},
      );
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> cancelMatch(String matchId) async {
    try {
      final response = await _dio.delete('/matches/$matchId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // MATCHES — INVITATION FLOW
  // ===========================================================================

  /// Send invitation to opponent captain
  Future<Match> inviteOpponent({
    required String matchId,
    required String opponentUserId,
    String? message,
  }) async {
    try {
      final response = await _dio.post('/matches/$matchId/invite', data: {
        'opponent_user_id': opponentUserId,
        if (message != null) 'message': message,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Accept a match invitation
  Future<Match> acceptInvitation({
    required String matchId,
    required String teamBName,
  }) async {
    try {
      final response = await _dio.post('/matches/$matchId/accept', data: {
        'team_b_name': teamBName,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Decline a match invitation
  Future<Map<String, dynamic>> declineInvitation(String matchId) async {
    try {
      final response = await _dio.post('/matches/$matchId/decline');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // MATCHES — TEAM MANAGEMENT
  // ===========================================================================

  /// Add player to captain's team
  Future<Map<String, dynamic>> addPlayerToTeam({
    required String matchId,
    String? userId,
    String? guestName,
    String role = 'batsman',
  }) async {
    try {
      final response =
          await _dio.post('/matches/$matchId/team/players', data: {
        if (userId != null) 'user_id': userId,
        if (guestName != null) 'guest_name': guestName,
        'role': role,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove player from captain's team
  Future<Map<String, dynamic>> removePlayerFromTeam({
    required String matchId,
    required String playerRecordId,
  }) async {
    try {
      final response =
          await _dio.delete('/matches/$matchId/team/players/$playerRecordId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mark team as ready/unready
  Future<Match> setTeamReady({
    required String matchId,
    bool ready = true,
  }) async {
    try {
      final response = await _dio.put('/matches/$matchId/team/ready', data: {
        'ready': ready,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get both teams' player lists
  Future<TeamsResponse> getTeams(String matchId) async {
    try {
      final response = await _dio.get('/matches/$matchId/teams');
      return TeamsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // MATCHES — RULES NEGOTIATION
  // ===========================================================================

  /// Propose rules
  Future<Match> proposeRules({
    required String matchId,
    required Map<String, dynamic> rules,
  }) async {
    try {
      final response =
          await _dio.post('/matches/$matchId/rules/propose', data: {
        'rules': rules,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Approve proposed rules
  Future<Match> approveRules(String matchId) async {
    try {
      final response = await _dio.post('/matches/$matchId/rules/approve');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Counter-propose rules
  Future<Match> counterRules({
    required String matchId,
    required Map<String, dynamic> rules,
  }) async {
    try {
      final response =
          await _dio.post('/matches/$matchId/rules/counter', data: {
        'rules': rules,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get rules + approval status
  Future<Map<String, dynamic>> getRules(String matchId) async {
    try {
      final response = await _dio.get('/matches/$matchId/rules');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // MATCHES — TOSS
  // ===========================================================================

  Future<Match> recordToss({
    required String matchId,
    required String tossWinner,
    required String tossDecision,
  }) async {
    try {
      final response = await _dio.put('/matches/$matchId/toss', data: {
        'toss_winner': tossWinner,
        'toss_decision': tossDecision,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // SCORING
  // ===========================================================================

  Future<Ball> recordBall(
      String matchId, String inningsId, Map<String, dynamic> ballData) async {
    try {
      final response = await _dio.post(
        '/matches/$matchId/innings/$inningsId/ball',
        data: ballData,
      );
      return Ball.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Ball>> getInningsBalls(String matchId, String inningsId) async {
    try {
      final response =
          await _dio.get('/matches/$matchId/innings/$inningsId/balls');
      return (response.data as List)
          .map((json) => Ball.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Match> recordMatchBall({
    required String matchId,
    required int runs,
    required bool isExtra,
    String? extraType,
  }) async {
    try {
      final response = await _dio.post('/matches/$matchId/ball', data: {
        'runs': runs,
        'is_extra': isExtra,
        'extra_type': extraType,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Match> recordWicket({
    required String matchId,
    required String type,
  }) async {
    try {
      final response = await _dio.post('/matches/$matchId/wicket', data: {
        'type': type,
      });
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Match> undoLastBall(String matchId) async {
    try {
      final response = await _dio.delete('/matches/$matchId/last-ball');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Match> switchInnings(String matchId) async {
    try {
      final response = await _dio.post('/matches/$matchId/switch-innings');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // PLAYERS
  // ===========================================================================

  Future<PlayerStats> getPlayerStats(String playerId) async {
    try {
      final response = await _dio.get('/players/$playerId/stats');
      return PlayerStats.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> endOver({required String matchId}) async {
    try {
      await _dio.post('/matches/$matchId/end-over');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> endInnings({required String matchId}) async {
    try {
      await _dio.post('/matches/$matchId/end-innings');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // OFFLINE SYNC
  // ===========================================================================

  Future<Map<String, dynamic>> syncOfflineQueue(
      List<Map<String, dynamic>> queue) async {
    try {
      final response = await _dio.post('/matches/sync', data: {
        'events': queue,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===========================================================================
  // ERROR HANDLING
  // ===========================================================================

  String _handleError(DioException error) {
    if (error.response?.data is Map<String, dynamic>) {
      final data = error.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      } else if (data.containsKey('message')) {
        return data['message'].toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}

/// API service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
