import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/player_stats_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart' as widgets;

class PlayerProfileScreen extends ConsumerWidget {
  final String playerId;

  const PlayerProfileScreen({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerStatsAsync = ref.watch(playerStatsProvider(playerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
      ),
      body: playerStatsAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => widgets.ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(playerStatsProvider(playerId)),
        ),
        data: (stats) {
          if (stats == null) {
            return const widgets.ErrorDisplay(
              message: 'Player not found',
              onRetry: null,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _PlayerHeader(stats: stats),
                const SizedBox(height: 16),
                
                // Batting Stats
                _BattingStats(stats: stats.battingStats),
                const SizedBox(height: 16),
                
                // Bowling Stats
                _BowlingStats(stats: stats.bowlingStats),
                const SizedBox(height: 16),
                
                // Fielding Stats
                _FieldingStats(stats: stats.fieldingStats),
                const SizedBox(height: 16),
                
                // Recent Matches
                _RecentMatches(matches: stats.recentMatches),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final PlayerStats stats;

  const _PlayerHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                stats.playerName.isNotEmpty ? stats.playerName[0].toUpperCase() : '?',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              stats.playerName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stats.primaryRole.toUpperCase(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  stats.overallRating.toStringAsFixed(1),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BattingStats extends StatelessWidget {
  final BattingStats stats;

  const _BattingStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports_cricket, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Batting Statistics',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Matches',
                  value: stats.matches.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Innings',
                  value: stats.innings.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Runs',
                  value: stats.runs.toString(),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Average',
                  value: stats.average.toStringAsFixed(2),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Strike Rate',
                  value: stats.strikeRate.toStringAsFixed(2),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Highest',
                  value: stats.highestScore.toString(),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: '100s',
                  value: stats.hundreds.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: '50s',
                  value: stats.fifties.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: '4s',
                  value: stats.fours.toString(),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: '6s',
                  value: stats.sixes.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Not Out',
                  value: stats.notOuts.toString(),
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BowlingStats extends StatelessWidget {
  final BowlingStats stats;

  const _BowlingStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports_baseball, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Bowling Statistics',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Matches',
                  value: stats.matches.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Innings',
                  value: stats.innings.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Wickets',
                  value: stats.wickets.toString(),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Average',
                  value: stats.average.toStringAsFixed(2),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Economy',
                  value: stats.economy.toStringAsFixed(2),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Strike Rate',
                  value: stats.strikeRate.toStringAsFixed(2),
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Best Bowling',
                  value: stats.bestBowling,
                  theme: theme,
                ),
                _StatItem(
                  label: '5 Wickets',
                  value: stats.fiveWicketHauls.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: '10 Wickets',
                  value: stats.tenWicketHauls.toString(),
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldingStats extends StatelessWidget {
  final FieldingStats stats;

  const _FieldingStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Fielding Statistics',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Catches',
                  value: stats.catches.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Stumpings',
                  value: stats.stumpings.toString(),
                  theme: theme,
                ),
                _StatItem(
                  label: 'Run Outs',
                  value: stats.runOuts.toString(),
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentMatches extends StatelessWidget {
  final List<MatchPerformance> matches;

  const _RecentMatches({required this.matches});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Recent Matches',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (matches.isEmpty)
              Text(
                'No recent matches found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            else
              Column(
                children: matches.take(5).map((match) => _RecentMatchItem(
                  match: match,
                  theme: theme,
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentMatchItem extends StatelessWidget {
  final MatchPerformance match;
  final ThemeData theme;

  const _RecentMatchItem({
    required this.match,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${match.teamAName} vs ${match.teamBName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recent performance',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  match.date,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (match.battingPerformance != null) ...[
                Text(
                  '${match.battingPerformance!.runs} runs',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              if (match.bowlingPerformance != null) ...[
                Text(
                  '${match.bowlingPerformance!.wickets}/${match.bowlingPerformance!.runs}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              if (match.fieldingPerformance != null) ...[
                Text(
                  '${match.fieldingPerformance!.catches} catches',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _StatItem({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}