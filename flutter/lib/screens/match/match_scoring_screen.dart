import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/match_scoring_provider.dart';
import 'package:inswing/services/api_service.dart';
import 'package:inswing/theme/app_theme.dart';
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
  List<Ball> _currentOverBalls = [];
  bool _isLoadingCurrentOver = false;
  String? _lastLoadedSnapshot;

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
    final isWide = MediaQuery.sizeOf(context).width >= 960;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Scoring Console'),
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
          onRetry: () =>
              ref.read(matchScoringProvider.notifier).loadMatch(widget.matchId),
        ),
        data: (match) {
          _scheduleCurrentOverRefresh(match);
          return _buildScoringInterface(match, theme, isWide: isWide);
        },
      ),
    );
  }

  Widget _buildScoringInterface(Match match, ThemeData theme,
      {required bool isWide}) {
    // Get current batting team info from match
    final teamABatting = match.battingTeam == 'A';
    final teamBBatting = match.battingTeam == 'B';
    final battingTeamName =
        match.battingTeam == 'A' ? match.teamAName : (match.teamBName ?? 'TBD');
    final totalRuns = match.battingTeam == 'A'
        ? (match.teamARuns ?? 0)
        : (match.teamBRuns ?? 0);
    final wickets = match.battingTeam == 'A'
        ? (match.teamAWickets ?? 0)
        : (match.teamBWickets ?? 0);
    final overs = match.battingTeam == 'A'
        ? (match.teamAOvers ?? 0.0)
        : (match.teamBOvers ?? 0.0);
    final runRate = overs > 0 ? totalRuns / overs : 0.0;

    final scorePanel = Column(
      children: [
        _buildScoreHeader(
          match,
          teamABatting: teamABatting,
          teamBBatting: teamBBatting,
          battingTeamName: battingTeamName,
          runRate: runRate,
          overs: overs,
        ),
        const SizedBox(height: 12),
        _buildOverStrip(theme, overBallCount: _currentOverBalls.length),
        const SizedBox(height: 12),
        _buildMatchMetaCard(theme, battingTeamName, totalRuns, wickets, overs),
      ],
    );

    final controlsPanel = _buildControlDeck(theme, isWide: isWide);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5F8FD), Color(0xFFEFF5FC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5, child: SingleChildScrollView(child: scorePanel)),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: controlsPanel),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: scorePanel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: 360, child: controlsPanel),
                ],
              ),
      ),
    );
  }

  Widget _buildScoreHeader(
    Match match, {
    required bool teamABatting,
    required bool teamBBatting,
    required String battingTeamName,
    required double runRate,
    required double overs,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B4B9A), Color(0xFF1A6ED1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamScore(
                teamName: match.teamAName,
                score: '${match.teamARuns ?? 0}',
                wickets: match.teamAWickets ?? 0,
                overs: _formatOvers(match.teamAOvers ?? 0.0),
                isBatting: teamABatting,
                darkMode: true,
              ),
              Text(
                'VS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              _buildTeamScore(
                teamName: match.teamBName ?? 'TBD',
                score: '${match.teamBRuns ?? 0}',
                wickets: match.teamBWickets ?? 0,
                overs: _formatOvers(match.teamBOvers ?? 0.0),
                isBatting: teamBBatting,
                darkMode: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildHeaderPill('Batting', battingTeamName),
              const SizedBox(width: 10),
              _buildHeaderPill('Overs', _formatOvers(overs)),
              const SizedBox(width: 10),
              _buildHeaderPill('RR', runRate.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverStrip(ThemeData theme, {required int overBallCount}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('This Over', style: theme.textTheme.titleSmall),
              const SizedBox(width: 8),
              if (_isLoadingCurrentOver)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  '$overBallCount ball${overBallCount == 1 ? '' : 's'}',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _currentOverBalls.isEmpty
                ? Text(
                    'No balls recorded in this over yet',
                    key: const ValueKey('empty-over-strip'),
                    style: theme.textTheme.bodySmall,
                  )
                : Wrap(
                    key: ValueKey(
                        'over-strip-${_currentOverBalls.length}-${_lastLoadedSnapshot ?? ''}'),
                    spacing: 8,
                    runSpacing: 8,
                    children: _currentOverBalls.map((ball) {
                      final overValue = _formatBallForOverStrip(ball);
                      final totalRuns =
                          ball.totalRuns ?? (ball.runsOffBat + ball.extrasRuns);
                      return _OverBall(
                        value: overValue,
                        isWicket:
                            ball.isWicket == true || ball.wicketType != null,
                        isBoundary: totalRuns >= 4,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchMetaCard(ThemeData theme, String battingTeam, int runs,
      int wickets, double overs) {
    final targetInfo = (runs + (20 - overs).floor());
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _metaValue('Current', '$battingTeam $runs/$wickets'),
          ),
          Expanded(
            child: _metaValue('Overs', _formatOvers(overs)),
          ),
          Expanded(
            child: _metaValue('Projection', '$targetInfo'),
          ),
        ],
      ),
    );
  }

  Widget _metaValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: AppTheme.textSecondaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }

  Widget _buildControlDeck(ThemeData theme, {required bool isWide}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('Ball Input', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildScoringButton(
                    '0', const Color(0xFF718197), () => _recordRun(0)),
                _buildScoringButton(
                    '1', const Color(0xFF1868C8), () => _recordRun(1)),
                _buildScoringButton(
                    '2', const Color(0xFF0E9A77), () => _recordRun(2)),
                _buildScoringButton(
                    '3', const Color(0xFFF78D1E), () => _recordRun(3)),
                _buildScoringButton(
                    '4', const Color(0xFF0C4DA2), () => _recordRun(4)),
                _buildScoringButton(
                    '6', const Color(0xFFD04444), () => _recordRun(6)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSpecialButton(
                  'WICKET',
                  const Color(0xFFD04444),
                  () => _showWicketDialog(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSpecialButton(
                  'WIDE',
                  const Color(0xFFF78D1E),
                  () => _recordExtra('wide'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSpecialButton(
                  'NO BALL',
                  const Color(0xFFCE6A15),
                  () => _recordExtra('no_ball'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _recordExtra('bye'),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Bye'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _recordExtra('leg_bye'),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Leg Bye'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showUndoDialog(context),
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
              ),
            ],
          ),
          if (isWide) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tip: Use 0-6 for quick entry, then extras and wicket controls for precision scoring.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamScore({
    required String teamName,
    required String score,
    required int wickets,
    required String overs,
    required bool isBatting,
    required bool darkMode,
  }) {
    final primaryTextColor =
        darkMode ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = darkMode
        ? Colors.white.withValues(alpha: 0.8)
        : Theme.of(context).textTheme.bodySmall?.color;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBatting
            ? (darkMode
                ? Colors.white.withValues(alpha: 0.16)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1))
            : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBatting
              ? (darkMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Theme.of(context).colorScheme.primary)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            teamName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score/$wickets',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
          ),
          Text(
            '($overs overs)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: secondaryTextColor,
                ),
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
          fontSize: 22,
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
  Future<void> _recordRun(int runs) async {
    await _appendOptimisticBall(
      runsOffBat: runs,
      extrasRuns: 0,
    );
    await ref.read(matchScoringProvider.notifier).recordBall(
          matchId: widget.matchId,
          runs: runs,
          isExtra: false,
        );
    await _refreshCurrentOverFromLatestMatch(force: true);
  }

  Future<void> _recordExtra(String type) async {
    final isRunAwardedExtra = type == 'wide' || type == 'no_ball';
    await _appendOptimisticBall(
      runsOffBat: 0,
      extrasRuns: isRunAwardedExtra ? 1 : 0,
      extrasType: type,
    );
    await ref.read(matchScoringProvider.notifier).recordExtra(
          matchId: widget.matchId,
          type: type,
        );
    await _refreshCurrentOverFromLatestMatch(force: true);
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

  Future<void> _recordWicket(String type) async {
    await _appendOptimisticBall(
      runsOffBat: 0,
      extrasRuns: 0,
      wicketType: type,
    );
    await ref.read(matchScoringProvider.notifier).recordWicket(
          matchId: widget.matchId,
          type: type,
        );
    await _refreshCurrentOverFromLatestMatch(force: true);
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
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(matchScoringProvider.notifier)
                  .undoLastBall(widget.matchId);
              await _refreshCurrentOverFromLatestMatch(force: true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Undo'),
          ),
        ],
      ),
    );
  }

  void _showMatchSettings(BuildContext context) {
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
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(matchScoringProvider.notifier)
                  .switchInnings(widget.matchId);
              await _refreshCurrentOverFromLatestMatch(force: true);
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

  Future<void> _appendOptimisticBall({
    required int runsOffBat,
    required int extrasRuns,
    String? extrasType,
    String? wicketType,
  }) async {
    final currentMatch = ref.read(matchScoringProvider).value;
    final inningsId = currentMatch?.currentInningsId;
    if (currentMatch == null || inningsId == null || inningsId.isEmpty) return;

    final battingOvers = currentMatch.battingTeam == 'A'
        ? (currentMatch.teamAOvers ?? 0.0)
        : (currentMatch.teamBOvers ?? 0.0);

    final inferredOver = battingOvers.floor() + 1;
    final nextBallInOver = (_currentOverBalls.length % 6) + 1;

    final updated =
        await ref.read(matchScoringProvider.notifier).appendOptimisticBallEvent(
              matchId: currentMatch.id,
              inningsId: inningsId,
              overNumber: inferredOver,
              ballInOver: nextBallInOver,
              runsOffBat: runsOffBat,
              extrasRuns: extrasRuns,
              extrasType: extrasType,
              wicketType: wicketType,
            );

    updated.sort((a, b) {
      final overCompare = a.overNumber.compareTo(b.overNumber);
      if (overCompare != 0) return overCompare;
      return a.ballInOver.compareTo(b.ballInOver);
    });
    final latestOver = updated.map((b) => b.overNumber).reduce(math.max);
    final currentOver =
        updated.where((b) => b.overNumber == latestOver).toList();

    if (!mounted) return;
    setState(() {
      _currentOverBalls = currentOver;
      _lastLoadedSnapshot =
          '${currentMatch.currentInningsId}|${currentMatch.battingTeam}|optimistic_${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void _scheduleCurrentOverRefresh(Match match) {
    final snapshot =
        '${match.currentInningsId}|${match.battingTeam}|${match.teamAOvers}|${match.teamBOvers}|${match.updatedAt.millisecondsSinceEpoch}';

    if (_lastLoadedSnapshot == snapshot || _isLoadingCurrentOver) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadCurrentOverBalls(match, snapshot: snapshot);
    });
  }

  Future<void> _refreshCurrentOverFromLatestMatch({bool force = false}) async {
    final latestMatch = ref.read(matchScoringProvider).value;
    if (latestMatch == null) return;
    await _loadCurrentOverBalls(latestMatch, force: force);
  }

  Future<void> _loadCurrentOverBalls(
    Match match, {
    String? snapshot,
    bool force = false,
  }) async {
    final inningsId = match.currentInningsId;
    if (inningsId == null || inningsId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _currentOverBalls = [];
        _isLoadingCurrentOver = false;
        _lastLoadedSnapshot = snapshot ?? _lastLoadedSnapshot;
      });
      return;
    }

    if (!force && _isLoadingCurrentOver) return;

    if (mounted) {
      setState(() => _isLoadingCurrentOver = true);
    }

    // Show cached timeline immediately while fresh data loads.
    final cachedBalls = ref
        .read(matchScoringProvider.notifier)
        .getCachedInningsBalls(match.id, inningsId);
    if (cachedBalls.isNotEmpty && mounted) {
      cachedBalls.sort((a, b) {
        final overCompare = a.overNumber.compareTo(b.overNumber);
        if (overCompare != 0) return overCompare;
        return a.ballInOver.compareTo(b.ballInOver);
      });

      final cachedLatestOver =
          cachedBalls.map((b) => b.overNumber).reduce(math.max);
      final cachedCurrentOver =
          cachedBalls.where((b) => b.overNumber == cachedLatestOver).toList();

      setState(() {
        _currentOverBalls = cachedCurrentOver;
      });
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      final balls = await apiService.getInningsBalls(match.id, inningsId);

      balls.sort((a, b) {
        final overCompare = a.overNumber.compareTo(b.overNumber);
        if (overCompare != 0) return overCompare;
        return a.ballInOver.compareTo(b.ballInOver);
      });

      final latestOver = balls.isNotEmpty
          ? balls.map((b) => b.overNumber).reduce(math.max)
          : null;

      final currentOver = latestOver == null
          ? <Ball>[]
          : balls.where((b) => b.overNumber == latestOver).toList();

      await ref
          .read(matchScoringProvider.notifier)
          .cacheInningsBalls(match.id, inningsId, balls);

      if (!mounted) return;
      setState(() {
        _currentOverBalls = currentOver;
        _lastLoadedSnapshot = snapshot ??
            '${match.currentInningsId}|${match.battingTeam}|${match.teamAOvers}|${match.teamBOvers}|${match.updatedAt.millisecondsSinceEpoch}';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        // Keep cached/last-known over if network fetch fails.
        _currentOverBalls = _currentOverBalls;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingCurrentOver = false);
      }
    }
  }

  String _formatBallForOverStrip(Ball ball) {
    if (ball.isWicket == true || ball.wicketType != null) return 'W';

    final extrasType = ball.extrasType;
    final totalRuns = ball.totalRuns ?? (ball.runsOffBat + ball.extrasRuns);

    switch (extrasType) {
      case 'wide':
        return totalRuns > 1 ? 'Wd$totalRuns' : 'Wd';
      case 'no_ball':
        return totalRuns > 1 ? 'Nb$totalRuns' : 'Nb';
      case 'bye':
        return 'B${ball.extrasRuns}';
      case 'leg_bye':
        return 'Lb${ball.extrasRuns}';
      default:
        return '$totalRuns';
    }
  }
}

class _OverBall extends StatelessWidget {
  final String value;
  final bool isBoundary;
  final bool isWicket;

  const _OverBall({
    required this.value,
    this.isBoundary = false,
    this.isWicket = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isWicket
        ? const Color(0xFFD04444)
        : isBoundary
            ? const Color(0xFF0C4DA2)
            : const Color(0xFFE8EEF7);
    final textColor =
        isWicket || isBoundary ? Colors.white : const Color(0xFF0D1C33);

    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
