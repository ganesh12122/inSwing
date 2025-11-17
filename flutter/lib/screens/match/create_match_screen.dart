import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/providers/create_match_provider.dart';
import 'package:inswing/theme/app_theme.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/app_button.dart';
import 'package:inswing/widgets/common/app_text_field.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateMatchScreen extends ConsumerStatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  final _teamAController = TextEditingController();
  final _teamBController = TextEditingController();
  final _venueController = TextEditingController();
  final _oversController = TextEditingController(text: '6');
  
  String _selectedMatchType = 'quick';
  double? _latitude;
  double? _longitude;
  List<Map<String, dynamic>> _teamAPlayers = [];
  List<Map<String, dynamic>> _teamBPlayers = [];

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
    if (status.isGranted) {
      // TODO: Get current location
      // setState(() => _useGpsLocation = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied. Please enter venue manually.'),
        ),
      );
    }
  }

  void _addPlayer(String team) {
    showDialog(
      context: context,
      builder: (context) => _PlayerDialog(
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

  Future<void> _createMatch() async {
    if (_teamAController.text.isEmpty || _teamBController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter team names'),
        ),
      );
      return;
    }

    if (_oversController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter number of overs'),
        ),
      );
      return;
    }

    final overs = int.tryParse(_oversController.text);
    if (overs == null || overs < kMinOvers || overs > kMaxOvers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Overs must be between $kMinOvers and $kMaxOvers'),
        ),
      );
      return;
    }

    final matchData = {
      'match_type': _selectedMatchType,
      'team_a_name': _teamAController.text.trim(),
      'team_b_name': _teamBController.text.trim(),
      'venue': _venueController.text.trim(),
      'latitude': _latitude,
      'longitude': _longitude,
      'rules': {
        'overs': overs,
        'powerplay_overs': 0,
        'extras_rules': 'standard',
      },
      'players': {
        'team_a': _teamAPlayers,
        'team_b': _teamBPlayers,
      },
    };

    try {
      final match = await ref.read(createMatchProvider.notifier).createMatch(matchData);
      if (mounted) {
        context.push('/match/${match.id}/score', extra: {'is_host': true});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create match: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createMatchState = ref.watch(createMatchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: createMatchState.when(
        loading: () => const LoadingWidget(message: 'Creating match...'),
        error: (error, stack) => widgets.ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.read(createMatchProvider.notifier).reset(),
        ),
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Match type selection
              Text(
                'Match Type',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: kMatchTypes.map((type) {
                  final isSelected = _selectedMatchType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(type.toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedMatchType = type);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Team names
              Text(
                'Team Names',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
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
              
              const SizedBox(height: 24),
              
              // Overs configuration
              Text(
                'Match Configuration',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _oversController,
                label: 'Number of Overs',
                hint: '6',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Venue
              Text(
                'Venue',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
              
              const SizedBox(height: 24),
              
              // Players section
              Text(
                'Players (Optional)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              
              // Team A players
              Row(
                children: [
                  Text(
                    'Team A Players (${_teamAPlayers.length})',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _addPlayer('A'),
                  ),
                ],
              ),
              if (_teamAPlayers.isNotEmpty) ...[
                const SizedBox(height: 8),
                ..._teamAPlayers.map((player) => Card(
                  child: ListTile(
                    title: Text(player['name'] ?? ''),
                    subtitle: Text(player['role'] ?? 'Player'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          _teamAPlayers.remove(player);
                        });
                      },
                    ),
                  ),
                )).toList(),
              ],
              
              const SizedBox(height: 16),
              
              // Team B players
              Row(
                children: [
                  Text(
                    'Team B Players (${_teamBPlayers.length})',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _addPlayer('B'),
                  ),
                ],
              ),
              if (_teamBPlayers.isNotEmpty) ...[
                const SizedBox(height: 8),
                ..._teamBPlayers.map((player) => Card(
                  child: ListTile(
                    title: Text(player['name'] ?? ''),
                    subtitle: Text(player['role'] ?? 'Player'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          _teamBPlayers.remove(player);
                        });
                      },
                    ),
                  ),
                )).toList(),
              ],
              
              const SizedBox(height: 32),
              
              // Create match button
              AppButton(
                onPressed: _createMatch,
                text: 'Create Match',
                icon: Icons.sports_cricket,
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

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
              labelText: 'Role',
              border: OutlineInputBorder(),
            ),
            items: ['batsman', 'bowler', 'allrounder', 'wicketkeeper']
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role.toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedRole = value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd({
                'name': _nameController.text.trim(),
                'role': _selectedRole,
              });
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}