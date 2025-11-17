// Authentication related constants
const String kAuthTokenKey = 'auth_token';
const String kRefreshTokenKey = 'refresh_token';
const String kUserIdKey = 'user_id';
const String kUserPhoneKey = 'user_phone';

// API related constants
const String kBaseUrl = 'http://localhost:8000/api/v1';
const String kWebSocketUrl = 'ws://localhost:8000';
const String kApiTimeout = '30';

// Storage related constants
const String kMatchesBox = 'matches_box';
const String kPlayersBox = 'players_box';
const String kOfflineQueueBox = 'offline_queue_box';
const String kSettingsBox = 'settings_box';

// Match related constants
const String kQuickMatch = 'quick';
const String kFriendlyMatch = 'friendly';
const String kTournamentMatch = 'tournament';

const List<String> kMatchTypes = [
  kQuickMatch,
  kFriendlyMatch,
  kTournamentMatch,
];

const List<String> kBattingStyles = [
  'right-handed',
  'left-handed',
];

const List<String> kBowlingStyles = [
  'fast',
  'spin',
  'pace',
  'none',
];

const List<String> kDominantHands = [
  'right',
  'left',
];

const List<String> kWicketTypes = [
  'bowled',
  'caught',
  'runout',
  'lbw',
  'stumped',
  'hit_wicket',
];

const List<String> kExtrasTypes = [
  'wide',
  'no_ball',
  'bye',
  'leg_bye',
];

const List<String> kMatchStatuses = [
  'created',
  'toss_done',
  'live',
  'finished',
  'cancelled',
];

// UI related constants
const double kDefaultPadding = 16.0;
const double kDefaultRadius = 12.0;
const double kDefaultElevation = 4.0;

const Duration kDefaultAnimationDuration = Duration(milliseconds: 300);
const Duration kApiTimeoutDuration = Duration(seconds: 30);
const Duration kWebSocketTimeoutDuration = Duration(seconds: 10);

// Scoring related constants
const int kMaxOvers = 50;
const int kMinOvers = 1;
const int kMaxPlayersPerTeam = 11;
const int kMinPlayersPerTeam = 1;

// Notification related constants
const String kNotificationChannelId = 'inswing_notifications';
const String kNotificationChannelName = 'inSwing Match Updates';
const String kNotificationChannelDescription = 'Notifications for match updates and events';