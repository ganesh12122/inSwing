import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/match_scoring_provider.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;

class MatchDetailScreen extends ConsumerStatefulWidget {
  final String matchId;
  final bool isHost;

  const MatchDetailScreen({
    super.key,
    required this.matchId,
    required this.isHost,
  });

  @override
  ConsumerState<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends ConsumerState<MatchDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load match data when screen initializes
    ref.read(matchScoringProvider.notifier).loadMatch(widget.matchId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoringState = ref.watch(matchScoringProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        actions: [
          if (widget.isHost) ...[
            IconButton(
              icon: const Icon(Icons.sports_score),
              onPressed: () => context.push('/match/${widget.matchId}/score',
                  extra: {'is_host': true}),
            ),
          ],
        ],
      ),
      body: scoringState.when(
        loading: () => const LoadingWidget(message: 'Loading match...'),
        error: (error, stack) => widgets.ErrorDisplay(
          message: error.toString(),
          onRetry: () =>
              ref.read(matchScoringProvider.notifier).loadMatch(widget.matchId),
        ),
        data: (match) => _buildMatchDetails(match, theme),
      ),
    );
  }

  Widget _buildMatchDetails(Match match, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Match info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${match.teamAName} vs ${match.teamBName ?? "TBD"}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Type: ${match.matchType.toUpperCase()}'),
                  if (match.venue != null) Text('Venue: ${match.venue}'),
                  Text('Status: ${match.status.toUpperCase()}'),
                  Text('Created: ${_formatDate(match.createdAt)}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Team scores card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scores',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTeamScoreCard(
                        teamName: match.teamAName,
                        runs: match.teamARuns ?? 0,
                        wickets: match.teamAWickets ?? 0,
                        overs: match.teamAOvers ?? 0.0,
                        isBatting: match.battingTeam == 'A',
                        theme: theme,
                      ),
                      Text(
                        'VS',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildTeamScoreCard(
                        teamName: match.teamBName ?? 'TBD',
                        runs: match.teamBRuns ?? 0,
                        wickets: match.teamBWickets ?? 0,
                        overs: match.teamBOvers ?? 0.0,
                        isBatting: match.battingTeam == 'B',
                        theme: theme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Match rules card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Match Rules',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Overs: ${match.rules['overs'] ?? 'Not set'}'),
                  Text(
                      'Powerplay: ${match.rules['powerplay_overs'] ?? 'Not set'}'),
                  Text('Extras: ${match.rules['extras_rules'] ?? 'Standard'}'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          if (widget.isHost) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startMatch(context),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Match'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editMatch(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Match'),
                  ),
                ),
              ],
            ),
          ] else ...[
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _joinMatch(context),
                icon: const Icon(Icons.group_add),
                label: const Text('Join Match'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamScoreCard({
    required String teamName,
    required int runs,
    required int wickets,
    required double overs,
    required bool isBatting,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isBatting ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBatting ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            teamName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$runs/$wickets',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '(${_formatOvers(overs)} overs)',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _startMatch(BuildContext context) {
    // Navigate to match scoring screen
    context.push('/match/${widget.matchId}/score', extra: {'is_host': true});
  }

  void _editMatch(BuildContext context) {
    // TODO: Implement edit match functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit match coming soon...')),
    );
  }

  void _joinMatch(BuildContext context) {
    // TODO: Implement join match functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Join match coming soon...')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatOvers(double overs) {
    final fullOvers = overs.floor();
    final balls = ((overs - fullOvers) * 6).round();
    return '$fullOvers.$balls';
  }
}
