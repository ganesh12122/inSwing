import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inswing/models/user_model.dart';
import 'package:inswing/services/api_service.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

/// Authentication state
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    UserProfile? userProfile,
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;
}

/// Authentication provider for managing user authentication
@riverpod
class Auth extends _$Auth {
  late final ApiService _apiService;

  @override
  AuthState build() {
    _apiService = ref.watch(apiServiceProvider);
    _initializeAuth();
    return const AuthState();
  }

  /// Initialize authentication state from storage
  Future<void> _initializeAuth() async {
    final token = await StorageService.getAuthToken();
    final userId = await StorageService.getUserId();
    
    if (token != null && userId != null) {
      try {
        // Validate token and fetch user data
        final user = await _apiService.getUser(userId);
        final userProfile = await _apiService.getUserProfile(userId);
        
        state = state.copyWith(
          user: user,
          userProfile: userProfile,
          isAuthenticated: true,
          isLoading: false,
        );
      } catch (e) {
        // Token invalid or expired
        await logout();
      }
    }
  }

  /// Request OTP for phone number
  Future<bool> requestOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final success = await _apiService.requestOtp(phoneNumber);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Verify OTP and login
  Future<bool> verifyOtpAndLogin(String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authResponse = await _apiService.verifyOtpAndLogin(
        phoneNumber,
        otp,
      );
      
      // Store tokens
      await StorageService.storeAuthToken(authResponse['access_token']);
      await StorageService.storeRefreshToken(authResponse['refresh_token']);
      await StorageService.storeUserId(authResponse['user']['id']);
      await StorageService.storeUserPhone(phoneNumber);
      
      // Fetch user data
      final user = User.fromJson(authResponse['user']);
      final userProfile = authResponse['user_profile'] != null
          ? UserProfile.fromJson(authResponse['user_profile'])
          : null;
      
      state = state.copyWith(
        user: user,
        userProfile: userProfile,
        isAuthenticated: true,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _apiService.logout();
    } catch (e) {
      // Ignore logout errors
    } finally {
      // Clear storage
      await StorageService.clearSecureStorage();
      
      // Reset state
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return false;
      
      final authResponse = await _apiService.refreshToken(refreshToken);
      
      // Store new tokens
      await StorageService.storeAuthToken(authResponse['access_token']);
      await StorageService.storeRefreshToken(authResponse['refresh_token']);
      
      return true;
    } catch (e) {
      // Refresh failed, logout
      await logout();
      return false;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final updatedProfile = await _apiService.updateUserProfile(profile);
      state = state.copyWith(userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Reload user and profile
  Future<void> reloadUserData() async {
    try {
      final userId = await StorageService.getUserId();
      if (userId == null) return;
      final user = await _apiService.getUser(userId);
      final userProfile = await _apiService.getUserProfile(userId);
      state = state.copyWith(user: user, userProfile: userProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}