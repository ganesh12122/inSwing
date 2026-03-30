# 📱 inSwing — Flutter Development Guide

## Setup

### Prerequisites

- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode (for mobile)
- VS Code with Flutter extension

### First Time Setup

```bash
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Run in Development

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# All available devices
flutter devices
```

---

## Project Structure

```
lib/
├── main.dart                      # Entry point, ProviderScope, MaterialApp
├── models/                        # Data classes (Freezed)
│   ├── user_model.dart            # User, UserProfile, PlayerStats, BattingStats, etc.
│   └── match_model.dart           # Match, Innings, Ball, PlayerInMatch
├── providers/                     # State management (Riverpod)
│   ├── auth_provider.dart         # AuthState: user, isAuthenticated, isLoading
│   ├── matches_provider.dart      # Match list with filtering
│   ├── match_scoring_provider.dart # Live scoring state
│   ├── create_match_provider.dart # Match creation form
│   ├── connectivity_provider.dart # Network state monitoring
│   ├── offline_sync_provider.dart # Offline queue processing
│   └── player_stats_provider.dart # Player statistics
├── routes/
│   └── app_router.dart            # GoRouter with auth redirect
├── screens/                       # Full-page UI
│   ├── auth/auth_screen.dart      # Phone input + OTP verification
│   ├── home/home_screen.dart      # Match list with tabs (Live/Completed/My)
│   ├── match/
│   │   ├── create_match_screen.dart   # Match creation form
│   │   ├── match_detail_screen.dart   # Match info + scorecard
│   │   └── match_scoring_screen.dart  # Ball-by-ball scoring UI
│   ├── player/player_profile_screen.dart
│   ├── profile/profile_screen.dart
│   ├── scoring/                   # (Additional scoring views)
│   └── settings/settings_screen.dart
├── services/
│   ├── api_service.dart           # Dio HTTP client with interceptors
│   └── storage_service.dart       # Hive boxes + SecureStorage
├── theme/
│   └── app_theme.dart             # Material 3 light + dark themes
├── utils/
│   └── constants.dart             # All app constants
└── widgets/
    └── common/                    # Reusable components
        ├── app_button.dart
        ├── app_text_field.dart
        ├── error_widget.dart
        ├── loading_widget.dart
        └── match_card_widget.dart
```

---

## Key Patterns

### 1. Riverpod with Code Generation

```dart
// Define provider with @riverpod annotation
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    // Initial state
    return const AuthState();
  }

  Future<void> login(String phone) async {
    state = state.copyWith(isLoading: true);
    // ... business logic
    state = state.copyWith(isLoading: false, isAuthenticated: true);
  }
}

// Use in widget
class MyWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // ...
  }
}
```

### 2. Freezed Models

```dart
@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String teamAName,
    required String teamBName,
    // ...
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
```

After changing models, **always run:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. GoRouter with Auth Guard

```dart
GoRouter(
  redirect: (context, state) {
    final isAuthenticated = authState.isAuthenticated;
    final isLoginPage = state.matchedLocation == '/login';

    if (!isAuthenticated && !isLoginPage) return '/login';
    if (isAuthenticated && isLoginPage) return '/home';
    return null;
  },
  routes: [/* ... */],
);
```

### 4. Dio with Auto Token Refresh

The `ApiService` class handles:

- Automatic Bearer token injection on every request
- Auto refresh token on 401 response
- Automatic logout on refresh failure
- Request/response logging in debug mode

### 5. Offline-First with Hive

```dart
// Save locally
await StorageService.saveMatch(match);

// Read from local
final matches = StorageService.getMatches();

// Queue for sync
await StorageService.addToOfflineQueue(action);
```

---

## Adding a New Feature (Checklist)

1. **Model**: Create/update Freezed model in `lib/models/`
2. **Run**: `dart run build_runner build`
3. **API**: Add API method in `lib/services/api_service.dart`
4. **Provider**: Create Riverpod provider in `lib/providers/`
5. **Screen**: Build UI in `lib/screens/`
6. **Route**: Add route in `lib/routes/app_router.dart`
7. **Test**: Write widget test in `test/`

---

## Theme Usage

```dart
// Colors
Theme.of(context).colorScheme.primary       // Blue
Theme.of(context).colorScheme.secondary     // Green
Theme.of(context).colorScheme.error         // Red

// Text styles
Theme.of(context).textTheme.headlineLarge   // 32px bold
Theme.of(context).textTheme.titleMedium     // 16px semibold
Theme.of(context).textTheme.bodyMedium      // 14px regular

// Custom constants
AppTheme.primaryColor                        // #2563EB
AppTheme.successColor                        // #10B981
AppTheme.errorColor                          // #EF4444
```

---

## Common Commands

```bash
# Get packages
flutter pub get

# Code generation (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild on save)
dart run build_runner watch --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

---

## Dependencies Quick Reference

| Package                  | Purpose           | Docs                                                                                       |
| ------------------------ | ----------------- | ------------------------------------------------------------------------------------------ |
| `flutter_riverpod`       | State management  | [riverpod.dev](https://riverpod.dev)                                                       |
| `go_router`              | Navigation        | [pub.dev/packages/go_router](https://pub.dev/packages/go_router)                           |
| `freezed`                | Immutable models  | [pub.dev/packages/freezed](https://pub.dev/packages/freezed)                               |
| `dio`                    | HTTP client       | [pub.dev/packages/dio](https://pub.dev/packages/dio)                                       |
| `hive`                   | Local database    | [pub.dev/packages/hive](https://pub.dev/packages/hive)                                     |
| `flutter_secure_storage` | Encrypted storage | [pub.dev/packages/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) |
| `google_fonts`           | Typography        | [pub.dev/packages/google_fonts](https://pub.dev/packages/google_fonts)                     |
| `connectivity_plus`      | Network state     | [pub.dev/packages/connectivity_plus](https://pub.dev/packages/connectivity_plus)           |
