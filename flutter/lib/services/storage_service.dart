import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/models/user_model.dart';
import 'package:inswing/utils/constants.dart';

/// Service for managing local storage using Hive and Flutter Secure Storage
class StorageService {
  static late Box _matchesBox;
  static late Box _playersBox;
  static late Box _offlineQueueBox;
  static late Box _settingsBox;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Initialize all storage boxes
  static Future<void> init() async {
    _matchesBox = await Hive.openBox(kMatchesBox);
    _playersBox = await Hive.openBox(kPlayersBox);
    _offlineQueueBox = await Hive.openBox(kOfflineQueueBox);
    _settingsBox = await Hive.openBox(kSettingsBox);
  }

  /// Secure storage methods for auth tokens
  static Future<void> storeAuthToken(String token) async {
    await _secureStorage.write(key: kAuthTokenKey, value: token);
  }

  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: kAuthTokenKey);
  }

  static Future<void> deleteAuthToken() async {
    await _secureStorage.delete(key: kAuthTokenKey);
  }

  static Future<void> storeRefreshToken(String token) async {
    await _secureStorage.write(key: kRefreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: kRefreshTokenKey);
  }

  static Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: kRefreshTokenKey);
  }

  static Future<void> storeUserId(String userId) async {
    await _secureStorage.write(key: kUserIdKey, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _secureStorage.read(key: kUserIdKey);
  }

  static Future<void> deleteUserId() async {
    await _secureStorage.delete(key: kUserIdKey);
  }

  static Future<void> storeUserPhone(String phone) async {
    await _secureStorage.write(key: kUserPhoneKey, value: phone);
  }

  static Future<String?> getUserPhone() async {
    return await _secureStorage.read(key: kUserPhoneKey);
  }

  static Future<void> deleteUserPhone() async {
    await _secureStorage.delete(key: kUserPhoneKey);
  }

  /// Clear all secure storage
  static Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  /// Matches storage methods
  static Future<void> saveMatch(Match match) async {
    await _matchesBox.put(match.id, match.toJson());
  }

  static Future<Match?> getMatch(String matchId) async {
    final data = _matchesBox.get(matchId);
    if (data != null) {
      return Match.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static Future<void> saveMatches(List<Match> matches) async {
    for (final match in matches) {
      await _matchesBox.put(match.id, match.toJson());
    }
  }

  static List<Match> getMatches() {
    return _matchesBox.values
        .map((data) => Match.fromJson(Map<String, dynamic>.from(data)))
        .toList();
  }

  static Future<void> clearMatches() async {
    await _matchesBox.clear();
  }

  /// Player storage methods
  static Future<void> savePlayerProfile(UserProfile profile) async {
    await _playersBox.put(profile.userId, profile.toJson());
  }

  static Future<UserProfile?> getPlayerProfile(String userId) async {
    final data = _playersBox.get(userId);
    if (data != null) {
      return UserProfile.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static Future<void> savePlayerStats(PlayerStats stats) async {
    await _playersBox.put('stats_${stats.playerId}', stats.toJson());
  }

  static Future<PlayerStats?> getPlayerStats(String playerId) async {
    final data = _playersBox.get('stats_$playerId');
    if (data != null) {
      return PlayerStats.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  static Future<void> clearPlayers() async {
    await _playersBox.clear();
  }

  /// Offline queue methods for ball updates
  static Future<void> addToOfflineQueue(Map<String, dynamic> action) async {
    final queue = _offlineQueueBox.get('queue', defaultValue: <Map<String, dynamic>>[])
        .cast<Map<String, dynamic>>();
    queue.add(action);
    await _offlineQueueBox.put('queue', queue);
  }

  static List<Map<String, dynamic>> getOfflineQueue() {
    return _offlineQueueBox.get('queue', defaultValue: <Map<String, dynamic>>[])
        .cast<Map<String, dynamic>>();
  }

  static Future<void> clearOfflineQueue() async {
    await _offlineQueueBox.put('queue', <Map<String, dynamic>>[]);
  }

  /// Settings storage methods
  static Future<void> storeSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  static Future<void> deleteSetting(String key) async {
    await _settingsBox.delete(key);
  }

  /// Clear all storage (use with caution)
  static Future<void> clearAll() async {
    await _matchesBox.clear();
    await _playersBox.clear();
    await _offlineQueueBox.clear();
    await _settingsBox.clear();
    await clearSecureStorage();
  }
}