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

// Match type constants
const String kQuickMatch = 'quick';
const String kDualCaptainMatch = 'dual_captain';
const String kFriendlyMatch = 'friendly';
const String kTournamentMatch = 'tournament';

const List<String> kMatchTypes = [
  kQuickMatch,
  kDualCaptainMatch,
  kFriendlyMatch,
  kTournamentMatch,
];

// Match type display labels
const Map<String, String> kMatchTypeLabels = {
  kQuickMatch: 'Quick Match',
  kDualCaptainMatch: 'Dual Captain',
  kFriendlyMatch: 'Friendly',
  kTournamentMatch: 'Tournament',
};

const Map<String, String> kMatchTypeDescriptions = {
  kQuickMatch: 'Solo scoring — you manage everything',
  kDualCaptainMatch: 'Invite opponent captain — both manage teams',
  kFriendlyMatch: 'Casual match with friends',
  kTournamentMatch: 'Tournament match (coming soon)',
};

// Match status constants (expanded for dual captain)
const List<String> kMatchStatuses = [
  'created',
  'invited',
  'accepted',
  'teams_ready',
  'rules_proposed',
  'rules_approved',
  'toss_done',
  'live',
  'finished',
  'cancelled',
  'declined',
];

const Map<String, String> kMatchStatusLabels = {
  'created': 'Created',
  'invited': 'Invitation Sent',
  'accepted': 'Accepted',
  'teams_ready': 'Teams Ready',
  'rules_proposed': 'Rules Proposed',
  'rules_approved': 'Rules Agreed',
  'toss_done': 'Toss Done',
  'live': 'Live',
  'finished': 'Finished',
  'cancelled': 'Cancelled',
  'declined': 'Declined',
};

// Player role constants (includes captain)
const List<String> kPlayerRoles = [
  'captain',
  'batsman',
  'bowler',
  'allrounder',
  'wicketkeeper',
];

const Map<String, String> kPlayerRoleLabels = {
  'captain': 'Captain',
  'batsman': 'Batsman',
  'bowler': 'Bowler',
  'allrounder': 'All-Rounder',
  'wicketkeeper': 'Wicket Keeper',
};

// Scorer permission constants
const String kScorerHostOnly = 'host_only';
const String kScorerCaptains = 'captains';
const String kScorerDesignated = 'designated';
const String kScorerAllPlayers = 'all_players';

const Map<String, String> kScorerPermissionLabels = {
  kScorerHostOnly: 'Host Captain Only',
  kScorerCaptains: 'Either Captain',
  kScorerDesignated: 'Designated Scorer',
  kScorerAllPlayers: 'Any Player',
};

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
const int kMaxPlayersPerTeam = 15;
const int kMinPlayersPerTeam = 2;

// Notification related constants
const String kNotificationChannelId = 'inswing_notifications';
const String kNotificationChannelName = 'inSwing Match Updates';
const String kNotificationChannelDescription = 'Notifications for match updates and events';
