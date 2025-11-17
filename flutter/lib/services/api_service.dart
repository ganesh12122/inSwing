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
          // Add auth token if available
          final token = await StorageService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            // Attempt to refresh token
            final refreshToken = await StorageService.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshResponse = await _refreshToken(refreshToken);
                final newToken = refreshResponse['access_token'];
                
                // Store new token
                await StorageService.storeAuthToken(newToken);
                
                // Retry original request
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final retryResponse = await _dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              } catch (e) {
                // Refresh failed, logout
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

  /// Refresh authentication token
  Future<Map<String, dynamic>> _refreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    return response.data;
  }

  /// Request OTP for phone number
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

  /// Verify OTP and login
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

  /// Get current user
  Future<User> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/profile');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleError(e);
    }
  }

  /// Update user profile
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

  /// Logout user
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Refresh token
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

  /// Get matches
  Future<List<Match>> getMatches({
    String? status,
    String? userId,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dio.get('/matches', queryParameters: {
        if (status != null) 'status': status,
        if (userId != null) 'user_id': userId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      });
      
      return (response.data as List)
          .map((json) => Match.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get match details
  Future<Match> getMatch(String matchId) async {
    try {
      final response = await _dio.get('/matches/$matchId');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create new match
  Future<Match> createMatch(Map<String, dynamic> matchData) async {
    try {
      final response = await _dio.post('/matches', data: matchData);
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update match status
  Future<Match> updateMatchStatus(String matchId, String status) async {
    try {
      final response = await _dio.put(
        '/matches/$matchId/status',
        data: {'status': status},
      );
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Record ball
  Future<Ball> recordBall(String matchId, String inningsId, Map<String, dynamic> ballData) async {
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

  /// Get innings balls
  Future<List<Ball>> getInningsBalls(String matchId, String inningsId) async {
    try {
      final response = await _dio.get('/matches/$matchId/innings/$inningsId/balls');
      
      return (response.data as List)
          .map((json) => Ball.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Record ball for match scoring
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

  /// Record wicket for match scoring
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

  /// Undo last ball
  Future<Match> undoLastBall(String matchId) async {
    try {
      final response = await _dio.delete('/matches/$matchId/last-ball');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Switch innings
  Future<Match> switchInnings(String matchId) async {
    try {
      final response = await _dio.post('/matches/$matchId/switch-innings');
      return Match.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get player statistics
  Future<PlayerStats> getPlayerStats(String playerId) async {
    try {
      final response = await _dio.get('/players/$playerId/stats');
      return PlayerStats.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }


  /// End over
  Future<void> endOver({
    required String matchId,
  }) async {
    try {
      await _dio.post('/matches/$matchId/end-over');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// End innings
  Future<void> endInnings({
    required String matchId,
  }) async {
    try {
      await _dio.post('/matches/$matchId/end-innings');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sync offline queue
  Future<Map<String, dynamic>> syncOfflineQueue(List<Map<String, dynamic>> queue) async {
    try {
      final response = await _dio.post('/matches/sync', data: {
        'events': queue,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle API errors
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