import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/match_scoring_provider.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;

class MatchScoringScreen extends ConsumerStatefulWidget {
  final String matchId;
  final bool isHost;

  const MatchScoringScreen({
    super.key,
    required this.matchId,
    required this.isHost,
  });

  @override
  ConsumerState<MatchScoringScreen> createState() => _MatchScoringScreenState();
}

class _MatchScoringScreenState extends ConsumerState<MatchScoringScreen> {
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
        title: const Text('Match Scoring'),
        actions: [
          if (widget.isHost) ...[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showMatchSettings(context),
            ),
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () => _showInningsSwitchDialog(context),
            ),
          ],
        ],
      ),
      body: scoringState.when(
        loading: () => const LoadingWidget(message: 'Loading match...'),
        error: (error, stack) => widgets.ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.read(matchScoringProvider.notifier).loadMatch(widget.matchId),
        ),
        data: (match) => _buildScoringInterface(match, theme),
      ),
    );
  }

  Widget _buildScoringInterface(Match match, ThemeData theme) {
    // Get current batting team info from match
    final teamABatting = match.battingTeam == 'A';
    final teamBBatting = match.battingTeam == 'B';

    return Column(
      children: [
        // Match summary header
        Container(
          color: theme.colorScheme.primaryContainer,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              // Team scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTeamScore(
                    teamName: match.teamAName,
                    score: '${match.teamARuns ?? 0}',
                    wickets: match.teamAWickets ?? 0,
                    overs: _formatOvers(match.teamAOvers ?? 0.0),
                    isBatting: teamABatting,
                    theme: theme,
                  ),
                  Text(
                    'VS',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildTeamScore(
                    teamName: match.teamBName,
                    score: '${match.teamBRuns ?? 0}',
                    wickets: match.teamBWickets ?? 0,
                    overs: _formatOvers(match.teamBOvers ?? 0.0),
                    isBatting: teamBBatting,
                    theme: theme,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Current over details
              Text(
                'Current Innings: ${match.battingTeam == "A" ? match.teamAName : match.teamBName}',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Striker: Not set'),
                  const Text('Non-striker: Not set'),
                  const Text('Bowler: Not set'),
                ],
              ),
            ],
          ),
        ),
        
        const Divider(),
        
        // Current over balls
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 8),
          child: Row(
            children: [
              Text('This Over:', style: theme.textTheme.titleSmall),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('No balls recorded yet'),
              ),
            ],
          ),
        ),
        const Divider(),
        
        // Scoring buttons
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: [
                // Main scoring buttons (0-6)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _buildScoringButton('0', Colors.grey, () => _recordRun(0)),
                      _buildScoringButton('1', Colors.blue, () => _recordRun(1)),
                      _buildScoringButton('2', Colors.green, () => _recordRun(2)),
                      _buildScoringButton('3', Colors.orange, () => _recordRun(3)),
                      _buildScoringButton('4', Colors.purple, () => _recordRun(4)),
                      _buildScoringButton('6', Colors.red, () => _recordRun(6)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Special buttons row
                Row(
                  children: [
                    Expanded(
                      child: _buildSpecialButton(
                        'WICKET',
                        Colors.red.shade700,
                        () => _showWicketDialog(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSpecialButton(
                        'WIDE',
                        Colors.amber,
                        () => _recordExtra('wide'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSpecialButton(
                        'NO BALL',
                        Colors.deepOrange,
                        () => _recordExtra('no_ball'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _recordExtra('bye'),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('BYE'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _recordExtra('leg_bye'),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('LEG BYE'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showUndoDialog(context),
                        icon: const Icon(Icons.undo),
                        label: const Text('UNDO'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamScore({
    required String teamName,
    required String score,
    required int wickets,
    required String overs,
    required bool isBatting,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBatting ? theme.colorScheme.primary.withValues(alpha: 0.1) : null,
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
          const SizedBox(height: 4),
          Text(
            '$score/$wickets',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '($overs overs)',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildScoringButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(80, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSpecialButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Scoring methods
  void _recordRun(int runs) {
    ref.read(matchScoringProvider.notifier).recordBall(
      matchId: widget.matchId,
      runs: runs,
      isExtra: false,
    );
  }

  void _recordExtra(String type) {
    ref.read(matchScoringProvider.notifier).recordExtra(
      matchId: widget.matchId,
      type: type,
    );
  }

  void _showWicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wicket Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bowled'),
              onTap: () {
                Navigator.pop(context);
                _recordWicket('bowled');
              },
            ),
            ListTile(
              title: const Text('Caught'),
              onTap: () {
                Navigator.pop(context);
                _recordWicket('caught');
              },
            ),
            ListTile(
              title: const Text('LBW'),
              onTap: () {
                Navigator.pop(context);
                _recordWicket('lbw');
              },
            ),
            ListTile(
              title: const Text('Run Out'),
              onTap: () {
                Navigator.pop(context);
                _recordWicket('run_out');
              },
            ),
            ListTile(
              title: const Text('Stumped'),
              onTap: () {
                Navigator.pop(context);
                _recordWicket('stumped');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _recordWicket(String type) {
    ref.read(matchScoringProvider.notifier).recordWicket(
      matchId: widget.matchId,
      type: type,
    );
  }

  void _showUndoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Undo Last Ball'),
        content: const Text('Are you sure you want to undo the last ball?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(matchScoringProvider.notifier).undoLastBall(widget.matchId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Undo'),
          ),
        ],
      ),
    );
  }

  void _showMatchSettings(BuildContext context) {
    // TODO: Implement match settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Match settings coming soon...')),
    );
  }

  void _showInningsSwitchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Innings'),
        content: const Text('Are you sure you want to switch innings?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(matchScoringProvider.notifier).switchInnings(widget.matchId);
            },
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatOvers(double overs) {
    final fullOvers = overs.floor();
    final balls = ((overs - fullOvers) * 6).round();
    return '$fullOvers.$balls';
  }
}