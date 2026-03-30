import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inswing/providers/create_match_provider.dart';
import 'package:inswing/theme/app_theme.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/app_button.dart';
import 'package:inswing/widgets/common/app_text_field.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;

/// Create Match Screen — now with mode selection (Quick Match vs Dual Captain).
/// Quick Match: both team names, basic rules, jump to scoring.
/// Dual Captain: only your team name, create match, navigate to lobby for invitation.
class CreateMatchScreen extends ConsumerStatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  // Current step: 0 = mode selection, 1 = match details
  int _currentStep = 0;

  final _teamAController = TextEditingController();
  final _teamBController = TextEditingController();
  final _venueController = TextEditingController();
  final _oversController = TextEditingController(text: '6');

  String _matchMode = 'quick'; // 'quick' or 'dual_captain'
  double? _latitude;
  double? _longitude;
  final List<Map<String, dynamic>> _teamAPlayers = [];
  final List<Map<String, dynamic>> _teamBPlayers = [];
  bool _isCreating = false;

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    _venueController.dispose();
    _oversController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permission denied. Please enter venue manually.')),
      );
    }
  }

  void _addPlayer(String team) {
    showDialog(
      context: context,
      builder: (_) => _PlayerDialog(
        onAdd: (player) {
          setState(() {
            if (team == 'A') {
              _teamAPlayers.add(player);
            } else {
              _teamBPlayers.add(player);
            }
          });
        },
      ),
    );
  }

  bool _validateForm() {
    if (_teamAController.text.trim().isEmpty) {
      _showError('Please enter your team name');
      return false;
    }
    if (_matchMode == 'quick' && _teamBController.text.trim().isEmpty) {
      _showError('Please enter opponent team name');
      return false;
    }
    final overs = int.tryParse(_oversController.text);
    if (overs == null || overs < kMinOvers || overs > kMaxOvers) {
      _showError('Overs must be between $kMinOvers and $kMaxOvers');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorColor),
    );
  }

  Future<void> _createMatch() async {
    if (!_validateForm()) return;

    setState(() => _isCreating = true);
    final overs = int.tryParse(_oversController.text) ?? 6;

    final matchData = <String, dynamic>{
      'match_type': _matchMode,
      'team_a_name': _teamAController.text.trim(),
      'venue': _venueController.text.trim().isEmpty
          ? null
          : _venueController.text.trim(),
      'latitude': _latitude,
      'longitude': _longitude,
      'rules': {
        'overs_limit': overs,
        'powerplay_overs': 0,
        'wide_ball_runs': 1,
        'no_ball_runs': 1,
        'free_hit': true,
        'super_over': false,
        'last_man_batting': false,
        'tennis_ball': true,
        'scorer_permission': 'host_only',
        'min_players_per_team': 2,
        'max_players_per_team': 11,
        'boundary_runs': 4,
        'max_overs_per_bowler': 0,
      },
    };

    // Quick match includes team B + players
    if (_matchMode == 'quick') {
      matchData['team_b_name'] = _teamBController.text.trim();
      matchData['players'] = {
        'team_a': _teamAPlayers,
        'team_b': _teamBPlayers,
      };
    }

    try {
      final match =
          await ref.read(createMatchProvider.notifier).createMatch(matchData);
      if (!mounted) return;

      if (_matchMode == 'dual_captain') {
        // Navigate to the match lobby for invitation flow
        context.push('/match/${match.id}/lobby');
      } else {
        // Quick match → go straight to scoring
        context.push('/match/${match.id}/score', extra: {'is_host': true});
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to create match: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createMatchState = ref.watch(createMatchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep = 0);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: createMatchState.when(
        loading: () => const LoadingWidget(message: 'Creating match...'),
        error: (error, stack) => widgets.ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.read(createMatchProvider.notifier).reset(),
        ),
        data: (_) => _currentStep == 0
            ? _buildModeSelection(theme)
            : _buildMatchDetails(theme),
      ),
    );
  }

  // ===========================================================================
  // STEP 0: Mode Selection
  // ===========================================================================

  Widget _buildModeSelection(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose Match Mode',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'How do you want to set up this match?',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Quick Match Card
          _ModeCard(
            title: 'Quick Match',
            description:
                kMatchTypeDescriptions['quick'] ?? 'You control everything',
            icon: Icons.bolt,
            iconColor: Colors.amber,
            isSelected: _matchMode == 'quick',
            features: const [
              'You set both team names',
              'You manage all players',
              'You control scoring',
              'Perfect for casual games',
            ],
            onTap: () => setState(() => _matchMode = 'quick'),
          ),

          const SizedBox(height: 16),

          // Dual Captain Card
          _ModeCard(
            title: 'Dual Captain',
            description: kMatchTypeDescriptions['dual_captain'] ??
                'Both captains collaborate',
            icon: Icons.people,
            iconColor: theme.colorScheme.primary,
            isSelected: _matchMode == 'dual_captain',
            features: const [
              'Invite opponent captain',
              'Each captain manages their team',
              'Negotiate rules together',
              'Professional match experience',
            ],
            onTap: () => setState(() => _matchMode = 'dual_captain'),
          ),

          const SizedBox(height: 32),

          AppButton(
            onPressed: () => setState(() => _currentStep = 1),
            text: 'Continue',
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 1: Match Details
  // ===========================================================================

  Widget _buildMatchDetails(ThemeData theme) {
    final isDualCaptain = _matchMode == 'dual_captain';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mode indicator chip
          Row(
            children: [
              Chip(
                avatar:
                    Icon(isDualCaptain ? Icons.people : Icons.bolt, size: 16),
                label: Text(isDualCaptain ? 'Dual Captain' : 'Quick Match'),
                backgroundColor: isDualCaptain
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : Colors.amber.withValues(alpha: 0.15),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: const Text('Change Mode'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Team names section
          Text(
            isDualCaptain ? 'Your Team' : 'Team Names',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (isDualCaptain) ...[
            // Dual captain: only team A name
            AppTextField(
              controller: _teamAController,
              label: 'Your Team Name',
              hint: 'e.g. Thunder XI',
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Opponent team name will be set when they accept your invitation.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Quick match: both team names
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _teamAController,
                    label: 'Team A',
                    hint: 'Team A Name',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _teamBController,
                    label: 'Team B',
                    hint: 'Team B Name',
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Overs
          Text(
            'Match Configuration',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _oversController,
            label: 'Number of Overs',
            hint: '6',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          if (isDualCaptain)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Overs can be finalized during rules negotiation',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),

          const SizedBox(height: 24),

          // Venue
          Text(
            'Venue',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          AppTextField(
            controller: _venueController,
            label: 'Venue Location',
            hint: 'Cricket Ground Name or Address',
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _requestLocationPermission,
            ),
          ),

          // Players section — only for quick match
          if (!isDualCaptain) ...[
            const SizedBox(height: 24),
            Text(
              'Players (Optional)',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildPlayersList('Team A', _teamAPlayers, 'A'),
            const SizedBox(height: 16),
            _buildPlayersList('Team B', _teamBPlayers, 'B'),
          ],

          const SizedBox(height: 32),

          // Create button
          AppButton(
            onPressed: _isCreating ? null : _createMatch,
            text: isDualCaptain ? 'Create & Invite Opponent' : 'Create Match',
            icon: isDualCaptain ? Icons.people : Icons.sports_cricket,
            isLoading: _isCreating,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlayersList(
      String title, List<Map<String, dynamic>> players, String team) {
    return Column(
      children: [
        Row(
          children: [
            Text('$title Players (${players.length})',
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addPlayer(team),
            ),
          ],
        ),
        if (players.isNotEmpty)
          ...players.map((player) => Card(
                child: ListTile(
                  title: Text(player['name'] ?? ''),
                  subtitle: Text(kPlayerRoleLabels[player['role']] ??
                      player['role'] ??
                      'Player'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => players.remove(player)),
                  ),
                ),
              )),
      ],
    );
  }
}

// =============================================================================
// MODE SELECTION CARD
// =============================================================================

class _ModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final List<String> features;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? iconColor : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          color: isSelected ? iconColor.withValues(alpha: 0.06) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: iconColor, size: 28),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check,
                          size: 16,
                          color: isSelected ? iconColor : Colors.grey),
                      const SizedBox(width: 8),
                      Text(f, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PLAYER DIALOG (preserved from original)
// =============================================================================

class _PlayerDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  const _PlayerDialog({required this.onAdd});

  @override
  State<_PlayerDialog> createState() => _PlayerDialogState();
}

class _PlayerDialogState extends State<_PlayerDialog> {
  final _nameController = TextEditingController();
  String _selectedRole = 'batsman';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Player'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Player Name',
            hint: 'Enter player name',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
                labelText: 'Role', border: OutlineInputBorder()),
            items: ['batsman', 'bowler', 'allrounder', 'wicketkeeper']
                .map((role) => DropdownMenuItem(
                      value: role,
                      child:
                          Text(kPlayerRoleLabels[role] ?? role.toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedRole = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd(
                  {'name': _nameController.text.trim(), 'role': _selectedRole});
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
