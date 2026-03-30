import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inswing/providers/auth_provider.dart';
import 'package:inswing/screens/auth/auth_screen.dart';
import 'package:inswing/screens/home/home_screen.dart';
import 'package:inswing/screens/match/create_match_screen.dart';
import 'package:inswing/screens/match/match_detail_screen.dart';
import 'package:inswing/screens/match/match_lobby_screen.dart';
import 'package:inswing/screens/match/match_scoring_screen.dart';
import 'package:inswing/screens/player/player_profile_screen.dart';
import 'package:inswing/screens/profile/profile_screen.dart';
import 'package:inswing/screens/settings/settings_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// App router configuration using go_router
@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/verify-otp';

      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const AuthScreen(isLoginMode: true),
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return AuthScreen(isLoginMode: false, phoneNumber: phoneNumber);
        },
      ),

      // Main app routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'create-match',
            name: 'create-match',
            builder: (context, state) => const CreateMatchScreen(),
          ),
        ],
      ),

      // Match routes
      GoRoute(
        path: '/match/:id',
        name: 'match-detail',
        builder: (context, state) {
          final matchId = state.pathParameters['id']!;
          final isHost = state.uri.queryParameters['host'] == 'true';
          return MatchDetailScreen(matchId: matchId, isHost: isHost);
        },
      ),

      // Match lobby — dual captain lifecycle hub
      GoRoute(
        path: '/match/:id/lobby',
        name: 'match-lobby',
        builder: (context, state) {
          final matchId = state.pathParameters['id']!;
          return MatchLobbyScreen(matchId: matchId);
        },
      ),

      GoRoute(
        path: '/match/:id/score',
        name: 'match-scoring',
        builder: (context, state) {
          final matchId = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>? ?? {'is_host': false};
          return MatchScoringScreen(
            matchId: matchId,
            isHost: extra['is_host'] as bool,
          );
        },
      ),

      // Profile routes
      GoRoute(
        path: '/profile/:id',
        name: 'profile',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return ProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/player/:id',
        name: 'player-profile',
        builder: (context, state) {
          final playerId = state.pathParameters['id']!;
          return PlayerProfileScreen(playerId: playerId);
        },
      ),

      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Root redirect
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.uri.path}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
