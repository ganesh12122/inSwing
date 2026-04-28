import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/match_scoring_provider.dart';
import 'package:inswing/theme/app_theme.dart';
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
    final isWide = MediaQuery.sizeOf(context).width >= 920;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Match Overview'),
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
        data: (match) => _buildMatchDetails(match, theme, isWide: isWide),
      ),
    );
  }

  Widget _buildMatchDetails(Match match, ThemeData theme,
      {required bool isWide}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeroHeader(match, theme),
        const SizedBox(height: 16),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildScorePanel(match, theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildRulesPanel(match, theme)),
            ],
          )
        else ...[
          _buildScorePanel(match, theme),
          const SizedBox(height: 12),
          _buildRulesPanel(match, theme),
        ],
        const SizedBox(height: 16),
        _buildActionBar(),
      ],
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6F9FE), Color(0xFFEFF5FC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isWide ? 1000 : double.infinity),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(Match match, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C4DA2), Color(0xFF1566CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${match.teamAName} vs ${match.teamBName ?? "TBD"}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _heroChip('Type', match.matchType.toUpperCase()),
              _heroChip('Status', match.status.toUpperCase()),
              _heroChip('Created', _formatDate(match.createdAt)),
              if (match.venue != null) _heroChip('Venue', match.venue!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildScorePanel(Match match, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Scoreboard',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildTeamScoreCard(
                    teamName: match.teamAName,
                    runs: match.teamARuns ?? 0,
                    wickets: match.teamAWickets ?? 0,
                    overs: match.teamAOvers ?? 0.0,
                    isBatting: match.battingTeam == 'A',
                    theme: theme,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'VS',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildTeamScoreCard(
                    teamName: match.teamBName ?? 'TBD',
                    runs: match.teamBRuns ?? 0,
                    wickets: match.teamBWickets ?? 0,
                    overs: match.teamBOvers ?? 0.0,
                    isBatting: match.battingTeam == 'B',
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesPanel(Match match, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Rules',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _ruleRow('Overs', '${match.rules['overs_limit'] ?? 'Not set'}'),
            _ruleRow(
                'Powerplay', '${match.rules['powerplay_overs'] ?? 0} overs'),
            _ruleRow(
                'Wide Ball', '${match.rules['wide_ball_runs'] ?? 1} run(s)'),
            _ruleRow('No Ball', '${match.rules['no_ball_runs'] ?? 1} run(s)'),
            _ruleRow('Free Hit',
                match.rules['free_hit'] == true ? 'Enabled' : 'Disabled'),
          ],
        ),
      ),
    );
  }

  Widget _ruleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    if (widget.isHost) {
      return Row(
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
      );
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _joinMatch(context),
        icon: const Icon(Icons.group_add),
        label: const Text('Join Match'),
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
