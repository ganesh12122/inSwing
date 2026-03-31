import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/auth_provider.dart';
import 'package:inswing/providers/match_lobby_provider.dart';
import 'package:inswing/services/api_service.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/app_button.dart';
import 'package:inswing/widgets/common/app_text_field.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;

/// Match Lobby Screen — manages the full dual-captain match lifecycle.
/// Shows the current stage and appropriate actions:
/// created → invite → accept → team setup → rules → toss → go live
class MatchLobbyScreen extends ConsumerStatefulWidget {
  final String matchId;

  const MatchLobbyScreen({super.key, required this.matchId});

  @override
  ConsumerState<MatchLobbyScreen> createState() => _MatchLobbyScreenState();
}

class _MatchLobbyScreenState extends ConsumerState<MatchLobbyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchLobbyProvider.notifier).loadMatch(widget.matchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lobbyState = ref.watch(matchLobbyProvider);
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id;

    // Show success/error messages
    ref.listen(matchLobbyProvider, (prev, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(matchLobbyProvider.notifier).clearMessages();
      }
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    if (lobbyState.isLoading && lobbyState.match == null) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading match...'),
      );
    }

    if (lobbyState.match == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Match')),
        body: widgets.ErrorDisplay(
          message: lobbyState.error ?? 'Match not found',
          onRetry: () =>
              ref.read(matchLobbyProvider.notifier).loadMatch(widget.matchId),
        ),
      );
    }

    final match = lobbyState.match!;
    final isHost = currentUserId == match.hostUserId;
    final isOpponent = currentUserId == match.opponentCaptainId;
    final isCaptain = isHost || isOpponent;

    return Scaffold(
      appBar: AppBar(
        title: Text(match.teamBName != null
            ? '${match.teamAName} vs ${match.teamBName}'
            : match.teamAName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(matchLobbyProvider.notifier).refresh(),
          ),
          if (isCaptain && !['finished', 'cancelled'].contains(match.status))
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'cancel') _showCancelDialog(context);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'cancel', child: Text('Cancel Match')),
              ],
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(matchLobbyProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress stepper
              _buildProgressStepper(match),
              const SizedBox(height: 24),
              // Status-specific content
              _buildStatusContent(match, isHost, isOpponent, isCaptain,
                  currentUserId, lobbyState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStepper(Match match) {
    final steps = [
      _StepInfo('Created', Icons.add_circle_outline, 'created'),
      _StepInfo('Invited', Icons.send, 'invited'),
      _StepInfo('Accepted', Icons.check_circle_outline, 'accepted'),
      _StepInfo('Teams Ready', Icons.group, 'teams_ready'),
      _StepInfo('Rules Agreed', Icons.gavel, 'rules_approved'),
      _StepInfo('Toss', Icons.casino, 'toss_done'),
      _StepInfo('Live', Icons.sports_cricket, 'live'),
    ];

    final statusOrder = [
      'created',
      'invited',
      'accepted',
      'teams_ready',
      'rules_proposed',
      'rules_approved',
      'toss_done',
      'live',
      'finished',
    ];
    final currentIdx = statusOrder.indexOf(match.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: steps.asMap().entries.map((entry) {
              final idx = entry.key;
              final step = entry.value;
              final stepIdx = statusOrder.indexOf(step.statusKey);
              final isCompleted = currentIdx > stepIdx;
              final isCurrent = match.status == step.statusKey ||
                  (step.statusKey == 'rules_approved' &&
                      match.status == 'rules_proposed');

              return Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                        child: Icon(
                          isCompleted ? Icons.check : step.icon,
                          size: 16,
                          color: (isCompleted || isCurrent)
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step.label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrent
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                      ),
                    ],
                  ),
                  if (idx < steps.length - 1)
                    Container(
                      width: 24,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: isCompleted ? Colors.green : Colors.grey.shade300,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusContent(
    Match match,
    bool isHost,
    bool isOpponent,
    bool isCaptain,
    String? currentUserId,
    MatchLobbyState lobbyState,
  ) {
    switch (match.status) {
      case 'created':
        return isHost
            ? _buildInviteSection(match, lobbyState)
            : _buildWaitingCard(
                'Match created', 'Waiting for host to send invitation');

      case 'invited':
        return isOpponent
            ? _buildAcceptInvitationSection(match, lobbyState)
            : _buildWaitingCard(
                'Invitation Sent', 'Waiting for opponent to respond...');

      case 'accepted':
      case 'teams_ready':
        return _buildTeamSetupSection(match, isHost, lobbyState);

      case 'rules_proposed':
        return _buildRulesSection(match, currentUserId, lobbyState);

      case 'rules_approved':
        return _buildTossSection(match, isCaptain, lobbyState);

      case 'toss_done':
        return _buildPreLiveSection(match, isHost);

      case 'live':
        return _buildLiveSection(match, isCaptain);

      case 'finished':
        return _buildFinishedSection(match);

      case 'cancelled':
        return _buildWaitingCard(
            'Match Cancelled', 'This match has been cancelled');

      case 'declined':
        return _buildWaitingCard(
            'Invitation Declined', 'The opponent declined the invitation');

      default:
        return _buildWaitingCard('Unknown Status', match.status);
    }
  }

  // ===========================================================================
  // INVITE SECTION (host sees this when match is 'created')
  // ===========================================================================

  Widget _buildInviteSection(Match match, MatchLobbyState lobbyState) {
    return _InviteOpponentSection(
      isLoading: lobbyState.isActionLoading,
      onInvite: (userId, message) {
        ref
            .read(matchLobbyProvider.notifier)
            .inviteOpponent(userId, message: message);
      },
    );
  }

  // ===========================================================================
  // ACCEPT INVITATION (opponent sees this when match is 'invited')
  // ===========================================================================

  Widget _buildAcceptInvitationSection(
      Match match, MatchLobbyState lobbyState) {
    return _AcceptInvitationSection(
      match: match,
      isLoading: lobbyState.isActionLoading,
      onAccept: (teamBName) async {
        final success = await ref
            .read(matchLobbyProvider.notifier)
            .acceptInvitation(teamBName);
        if (success) ref.read(matchLobbyProvider.notifier).refresh();
      },
      onDecline: () async {
        final success =
            await ref.read(matchLobbyProvider.notifier).declineInvitation();
        if (success && mounted) context.pop();
      },
    );
  }

  // ===========================================================================
  // TEAM SETUP (both captains see this when match is 'accepted' or 'teams_ready')
  // ===========================================================================

  Widget _buildTeamSetupSection(
      Match match, bool isHost, MatchLobbyState lobbyState) {
    final teams = lobbyState.teams;
    final myTeam = isHost ? teams?.teamA : teams?.teamB;
    final otherTeam = isHost ? teams?.teamB : teams?.teamA;
    final isMyTeamReady =
        isHost ? match.hostTeamReady : match.opponentTeamReady;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // My Team
        Card(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Team: ${myTeam?.name ?? ""}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    if (isMyTeamReady)
                      const Chip(
                        label: Text('Ready ✅'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                    '${myTeam?.count ?? 0} players (min ${match.minPlayersPerTeam})'),
                const SizedBox(height: 8),
                if (myTeam != null)
                  ...myTeam.players.map((p) => ListTile(
                        dense: true,
                        leading: Icon(
                          p.isGuest ? Icons.person_outline : Icons.person,
                          color: p.role == 'captain' ? Colors.amber : null,
                        ),
                        title: Text(p.displayName ?? p.guestName ?? 'Player'),
                        subtitle: Text(kPlayerRoleLabels[p.role ?? 'batsman'] ??
                            p.role ??
                            ''),
                        trailing: p.role != 'captain'
                            ? IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () => ref
                                    .read(matchLobbyProvider.notifier)
                                    .removePlayer(p.id),
                              )
                            : null,
                      )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showAddPlayerDialog(),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add Player'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: lobbyState.isActionLoading
                            ? null
                            : () => ref
                                .read(matchLobbyProvider.notifier)
                                .setTeamReady(ready: !isMyTeamReady),
                        icon: Icon(isMyTeamReady ? Icons.undo : Icons.check),
                        label: Text(isMyTeamReady ? 'Unready' : 'Team Ready'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Opponent Team (read-only)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Opponent: ${otherTeam?.name ?? ""}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                          otherTeam?.ready == true ? 'Ready ✅' : 'Not Ready'),
                      backgroundColor: otherTeam?.ready == true
                          ? Colors.green
                          : Colors.grey.shade300,
                      labelStyle: TextStyle(
                        color: otherTeam?.ready == true
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                Text('${otherTeam?.count ?? 0} players'),
                if (otherTeam != null)
                  ...otherTeam.players.map((p) => ListTile(
                        dense: true,
                        leading: Icon(
                          p.isGuest ? Icons.person_outline : Icons.person,
                          color: p.role == 'captain' ? Colors.amber : null,
                        ),
                        title: Text(p.displayName ?? p.guestName ?? 'Player'),
                        subtitle: Text(kPlayerRoleLabels[p.role ?? 'batsman'] ??
                            p.role ??
                            ''),
                      )),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Propose rules button (when both teams ready)
        if (match.bothTeamsReady)
          AppButton(
            onPressed: () => _showProposeRulesDialog(match),
            text: 'Propose Match Rules',
            icon: Icons.gavel,
          ),
      ],
    );
  }

  // ===========================================================================
  // RULES SECTION
  // ===========================================================================

  Widget _buildRulesSection(
      Match match, String? currentUserId, MatchLobbyState lobbyState) {
    final proposedByMe = match.rulesProposedBy == currentUserId;
    final rules = match.proposedRules ?? match.rules;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rules ${proposedByMe ? "(You Proposed)" : "(Proposed by Opponent)"}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildRuleRow('Overs', '${rules['overs_limit'] ?? 6}'),
            _buildRuleRow(
                'Powerplay', '${rules['powerplay_overs'] ?? 0} overs'),
            _buildRuleRow(
                'Wide Ball', '${rules['wide_ball_runs'] ?? 1} run(s)'),
            _buildRuleRow('No Ball', '${rules['no_ball_runs'] ?? 1} run(s)'),
            _buildRuleRow('Free Hit', rules['free_hit'] == true ? 'Yes' : 'No'),
            _buildRuleRow('Last Man Batting',
                rules['last_man_batting'] == true ? 'Yes' : 'No'),
            _buildRuleRow(
                'Tennis Ball', rules['tennis_ball'] == true ? 'Yes' : 'No'),
            _buildRuleRow(
                'Min Players', '${rules['min_players_per_team'] ?? 2}'),
            _buildRuleRow(
                'Max Players', '${rules['max_players_per_team'] ?? 11}'),
            _buildRuleRow(
                'Scorer',
                kScorerPermissionLabels[rules['scorer_permission']] ??
                    'Host Only'),
            const Divider(),
            Row(
              children: [
                Icon(
                    match.hostRulesApproved
                        ? Icons.check_circle
                        : Icons.pending,
                    color:
                        match.hostRulesApproved ? Colors.green : Colors.orange,
                    size: 20),
                const SizedBox(width: 4),
                const Text('Host'),
                const SizedBox(width: 16),
                Icon(
                    match.opponentRulesApproved
                        ? Icons.check_circle
                        : Icons.pending,
                    color: match.opponentRulesApproved
                        ? Colors.green
                        : Colors.orange,
                    size: 20),
                const SizedBox(width: 4),
                const Text('Opponent'),
              ],
            ),
            const SizedBox(height: 16),
            if (!proposedByMe) ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: lobbyState.isActionLoading
                          ? null
                          : () => ref
                              .read(matchLobbyProvider.notifier)
                              .approveRules(),
                      text: 'Approve ✅',
                      isLoading: lobbyState.isActionLoading,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      onPressed: () => _showProposeRulesDialog(match),
                      text: 'Counter',
                      isOutlined: true,
                      icon: Icons.swap_horiz,
                    ),
                  ),
                ],
              ),
            ] else ...[
              _buildWaitingCard(
                  'Waiting', 'Waiting for opponent to approve or counter...'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRuleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOSS SECTION
  // ===========================================================================

  Widget _buildTossSection(
      Match match, bool isCaptain, MatchLobbyState lobbyState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rules Agreed! ✅',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Time for the toss!'),
            const SizedBox(height: 16),
            if (isCaptain)
              AppButton(
                onPressed: () => _showTossDialog(match),
                text: 'Record Toss',
                icon: Icons.casino,
                isLoading: lobbyState.isActionLoading,
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PRE-LIVE SECTION
  // ===========================================================================

  Widget _buildPreLiveSection(Match match, bool isHost) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toss Done! 🪙',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Winner: Team ${match.tossWinner}'),
            Text('Decision: ${match.tossDecision?.toUpperCase() ?? ""}'),
            const SizedBox(height: 16),
            AppButton(
              onPressed: () {
                context.push('/match/${match.id}/score',
                    extra: {'is_host': isHost});
              },
              text: 'Start Scoring 🏏',
              icon: Icons.play_arrow,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // LIVE & FINISHED SECTIONS
  // ===========================================================================

  Widget _buildLiveSection(Match match, bool isCaptain) {
    return Column(
      children: [
        _buildScoreCard(match),
        const SizedBox(height: 16),
        if (isCaptain)
          AppButton(
            onPressed: () => context
                .push('/match/${match.id}/score', extra: {'is_host': true}),
            text: 'Open Scoring',
            icon: Icons.sports_cricket,
          ),
      ],
    );
  }

  Widget _buildFinishedSection(Match match) {
    return Column(
      children: [
        _buildScoreCard(match),
        const SizedBox(height: 16),
        if (match.result != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Text('🏆 Result',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Team ${match.result!['winner']} won by ${match.result!['winning_margin']} ${match.result!['winning_type']}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScoreCard(Match match) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(match.teamAName,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text('${match.teamARuns ?? 0}/${match.teamAWickets ?? 0}',
                    style: Theme.of(context).textTheme.headlineMedium),
                Text('(${match.teamAOvers ?? 0.0} ov)',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Text('VS', style: Theme.of(context).textTheme.titleLarge),
            Column(
              children: [
                Text(match.teamBName ?? '?',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text('${match.teamBRuns ?? 0}/${match.teamBWickets ?? 0}',
                    style: Theme.of(context).textTheme.headlineMedium),
                Text('(${match.teamBOvers ?? 0.0} ov)',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingCard(String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // DIALOGS
  // ===========================================================================

  void _showAddPlayerDialog() {
    final nameController = TextEditingController();
    String selectedRole = 'batsman';
    bool isGuest = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Player'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                      value: true,
                      label: Text('Guest'),
                      icon: Icon(Icons.person_outline)),
                  ButtonSegment(
                      value: false,
                      label: Text('App User'),
                      icon: Icon(Icons.person)),
                ],
                selected: {isGuest},
                onSelectionChanged: (s) =>
                    setDialogState(() => isGuest = s.first),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: nameController,
                label: isGuest ? 'Player Name' : 'Search by phone/name',
                hint: isGuest ? 'Enter player name' : 'Search users...',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                    labelText: 'Role', border: OutlineInputBorder()),
                items: ['batsman', 'bowler', 'allrounder', 'wicketkeeper']
                    .map((r) => DropdownMenuItem(
                        value: r, child: Text(kPlayerRoleLabels[r] ?? r)))
                    .toList(),
                onChanged: (v) =>
                    setDialogState(() => selectedRole = v ?? 'batsman'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                if (isGuest) {
                  ref.read(matchLobbyProvider.notifier).addPlayer(
                        guestName: nameController.text.trim(),
                        role: selectedRole,
                      );
                } else {
                  // For now, use name as search — will improve with search API
                  ref.read(matchLobbyProvider.notifier).addPlayer(
                        guestName: nameController.text.trim(),
                        role: selectedRole,
                      );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProposeRulesDialog(Match match) {
    final currentRules = match.proposedRules ?? match.rules;
    final oversController =
        TextEditingController(text: '${currentRules['overs_limit'] ?? 6}');
    final powerplayController =
        TextEditingController(text: '${currentRules['powerplay_overs'] ?? 0}');
    bool freeHit = currentRules['free_hit'] ?? true;
    bool lastManBatting = currentRules['last_man_batting'] ?? false;
    bool tennisBall = currentRules['tennis_ball'] ?? true;
    bool superOver = currentRules['super_over'] ?? false;
    int wideBallRuns = currentRules['wide_ball_runs'] ?? 1;
    int noBallRuns = currentRules['no_ball_runs'] ?? 1;
    String scorerPermission = currentRules['scorer_permission'] ?? 'host_only';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Propose Rules'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                    controller: oversController,
                    label: 'Overs per innings',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                AppTextField(
                    controller: powerplayController,
                    label: 'Powerplay overs',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                SwitchListTile(
                    title: const Text('Free Hit'),
                    value: freeHit,
                    onChanged: (v) => setDialogState(() => freeHit = v)),
                SwitchListTile(
                    title: const Text('Last Man Batting'),
                    subtitle: const Text('Gully cricket special'),
                    value: lastManBatting,
                    onChanged: (v) => setDialogState(() => lastManBatting = v)),
                SwitchListTile(
                    title: const Text('Tennis Ball'),
                    value: tennisBall,
                    onChanged: (v) => setDialogState(() => tennisBall = v)),
                SwitchListTile(
                    title: const Text('Super Over on Tie'),
                    value: superOver,
                    onChanged: (v) => setDialogState(() => superOver = v)),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: wideBallRuns,
                  decoration: const InputDecoration(
                      labelText: 'Wide Ball Runs',
                      border: OutlineInputBorder()),
                  items: [1, 2]
                      .map((v) =>
                          DropdownMenuItem(value: v, child: Text('$v run(s)')))
                      .toList(),
                  onChanged: (v) => setDialogState(() => wideBallRuns = v ?? 1),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: scorerPermission,
                  decoration: const InputDecoration(
                      labelText: 'Who can score?',
                      border: OutlineInputBorder()),
                  items: kScorerPermissionLabels.entries
                      .map((e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => scorerPermission = v ?? 'host_only'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ref.read(matchLobbyProvider.notifier).proposeRules({
                  'overs_limit': int.tryParse(oversController.text) ?? 6,
                  'powerplay_overs':
                      int.tryParse(powerplayController.text) ?? 0,
                  'wide_ball_runs': wideBallRuns,
                  'no_ball_runs': noBallRuns,
                  'free_hit': freeHit,
                  'super_over': superOver,
                  'last_man_batting': lastManBatting,
                  'tennis_ball': tennisBall,
                  'scorer_permission': scorerPermission,
                  'min_players_per_team': 2,
                  'max_players_per_team': 11,
                  'boundary_runs': 4,
                  'max_overs_per_bowler': 0,
                });
              },
              child: const Text('Propose'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTossDialog(Match match) {
    String? tossWinner;
    String? tossDecision;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Record Toss'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Who won the toss?'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text(match.teamAName),
                      selected: tossWinner == 'A',
                      onSelected: (_) => setDialogState(() => tossWinner = 'A'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: Text(match.teamBName ?? 'Team B'),
                      selected: tossWinner == 'B',
                      onSelected: (_) => setDialogState(() => tossWinner = 'B'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Elected to?'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Bat'),
                      selected: tossDecision == 'bat',
                      onSelected: (_) =>
                          setDialogState(() => tossDecision = 'bat'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Bowl'),
                      selected: tossDecision == 'bowl',
                      onSelected: (_) =>
                          setDialogState(() => tossDecision = 'bowl'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: (tossWinner != null && tossDecision != null)
                  ? () {
                      Navigator.pop(ctx);
                      ref
                          .read(matchLobbyProvider.notifier)
                          .recordToss(tossWinner!, tossDecision!);
                    }
                  : null,
              child: const Text('Record'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Match?'),
        content: const Text(
            'Are you sure you want to cancel this match? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final success =
                  await ref.read(matchLobbyProvider.notifier).cancelMatch();
              if (success && mounted) {
                if (context.mounted) context.pop();
              }
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// INVITE OPPONENT SECTION (extracted widget)
// ===========================================================================

class _InviteOpponentSection extends ConsumerStatefulWidget {
  final bool isLoading;
  final Function(String userId, String? message) onInvite;

  const _InviteOpponentSection(
      {required this.isLoading, required this.onInvite});

  @override
  ConsumerState<_InviteOpponentSection> createState() =>
      _InviteOpponentSectionState();
}

class _InviteOpponentSectionState
    extends ConsumerState<_InviteOpponentSection> {
  final _searchController = TextEditingController();
  final _messageController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  String? _selectedUserId;

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final results = await ref.read(apiServiceProvider).searchUsers(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite Opponent Captain',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Search by phone number or name'),
            const SizedBox(height: 12),
            AppTextField(
              controller: _searchController,
              label: 'Search opponent',
              hint: 'Phone number or name',
              onChanged: _searchUsers,
              suffixIcon: _isSearching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : null,
            ),
            if (_searchResults.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    final isSelected = _selectedUserId == user.id;
                    return ListTile(
                      selected: isSelected,
                      leading: CircleAvatar(
                          child: Text((user.fullName ?? user.email ?? '??').substring(0, 2).toUpperCase())),
                      title: Text(user.fullName ?? user.email ?? 'Unknown'),
                      subtitle: Text(user.email ?? user.phoneNumber ?? ''),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() => _selectedUserId = user.id);
                      },
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            AppTextField(
              controller: _messageController,
              label: 'Invitation message (optional)',
              hint: 'Let\'s play a match!',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: _selectedUserId != null && !widget.isLoading
                  ? () => widget.onInvite(
                      _selectedUserId!,
                      _messageController.text.trim().isEmpty
                          ? null
                          : _messageController.text.trim())
                  : null,
              text: 'Send Invitation',
              icon: Icons.send,
              isLoading: widget.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// ACCEPT INVITATION SECTION (extracted widget)
// ===========================================================================

class _AcceptInvitationSection extends StatefulWidget {
  final Match match;
  final bool isLoading;
  final Function(String teamBName) onAccept;
  final VoidCallback onDecline;

  const _AcceptInvitationSection({
    required this.match,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<_AcceptInvitationSection> createState() =>
      _AcceptInvitationSectionState();
}

class _AcceptInvitationSectionState extends State<_AcceptInvitationSection> {
  final _teamNameController = TextEditingController();

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏏 Match Invitation!',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Team: ${widget.match.teamAName}',
                style: Theme.of(context).textTheme.titleMedium),
            if (widget.match.venue != null)
              Text('Venue: ${widget.match.venue}'),
            if (widget.match.invitationMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.format_quote, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(widget.match.invitationMessage!)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            AppTextField(
              controller: _teamNameController,
              label: 'Your Team Name',
              hint: 'Enter your team name',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: widget.isLoading ? null : widget.onDecline,
                    text: 'Decline',
                    isOutlined: true,
                    icon: Icons.close,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: widget.isLoading ||
                            _teamNameController.text.trim().isEmpty
                        ? null
                        : () =>
                            widget.onAccept(_teamNameController.text.trim()),
                    text: 'Accept',
                    icon: Icons.check,
                    isLoading: widget.isLoading,
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

class _StepInfo {
  final String label;
  final IconData icon;
  final String statusKey;

  _StepInfo(this.label, this.icon, this.statusKey);
}
