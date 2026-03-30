import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/auth_provider.dart';
import 'package:inswing/providers/matches_provider.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/match_card_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMatches();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMatches() async {
    await ref.read(matchesProvider.notifier).loadMatches();
  }

  Future<void> _refreshMatches() async {
    await ref.read(matchesProvider.notifier).refreshMatches();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final matchesState = ref.watch(matchesProvider);
    final currentUserId = authState.user?.id;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('inSwing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              if (authState.user != null) {
                context.push('/profile/${authState.user!.id}');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Live'),
            Tab(text: 'Completed'),
            Tab(text: 'My Matches'),
            Tab(icon: Icon(Icons.mail_outline, size: 18), text: 'Invitations'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Quick', 'quick'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Dual Captain', 'dual_captain'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Tournament', 'tournament'),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _refreshMatches,
                  ),
                ],
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: matchesState.when(
              loading: () => const LoadingWidget(message: 'Loading matches...'),
              error: (message) => widgets.ErrorDisplay(
                message: message.toString(),
                onRetry: _loadMatches,
              ),
              data: (matches) {
                // Apply type filter
                final filtered = _selectedFilter == 'all'
                    ? matches
                    : matches.where((m) => m.matchType == _selectedFilter).toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Live matches
                    _buildMatchesList(
                      filtered.where((m) => m.status == 'live').toList(),
                      'No live matches',
                      'Live matches will appear here',
                      Icons.sports_cricket_outlined,
                    ),

                    // Completed matches
                    _buildMatchesList(
                      filtered.where((m) => m.status == 'finished').toList(),
                      'No completed matches',
                      'Completed matches will appear here',
                      Icons.emoji_events_outlined,
                    ),

                    // My matches (hosted by me or I'm opponent captain)
                    _buildMatchesList(
                      filtered.where((m) =>
                          m.hostUserId == currentUserId ||
                          m.opponentCaptainId == currentUserId).toList(),
                      'No matches yet',
                      'Matches you create or join will appear here',
                      Icons.person_outline,
                    ),

                    // Invitations (I'm the opponent captain, status = invited)
                    _buildMatchesList(
                      matches.where((m) =>
                          m.opponentCaptainId == currentUserId &&
                          m.status == 'invited').toList(),
                      'No pending invitations',
                      'Match invitations from other captains will appear here',
                      Icons.mail_outline,
                      isInvitations: true,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/create-match'),
        icon: const Icon(Icons.add),
        label: const Text('Create Match'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == filter,
      onSelected: (selected) {
        setState(() => _selectedFilter = selected ? filter : 'all');
        ref.read(matchesProvider.notifier).filterMatches(selected ? filter : 'all');
      },
    );
  }

  Widget _buildMatchesList(
    List<Match> matches,
    String emptyTitle,
    String emptySubtitle,
    IconData emptyIcon, {
    bool isInvitations = false,
  }) {
    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyIcon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMatches,
      child: ListView.builder(
        padding: const EdgeInsets.all(kDefaultPadding),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MatchCardWidget(
              match: match,
              onTap: () {
                // Dual captain matches in progress → go to lobby
                if (match.isDualCaptain && _isDualCaptainInProgress(match.status)) {
                  context.push('/match/${match.id}/lobby');
                } else {
                  context.push('/match/${match.id}');
                }
              },
            ),
          );
        },
      ),
    );
  }

  bool _isDualCaptainInProgress(String status) {
    return ['created', 'invited', 'accepted', 'teams_ready',
            'rules_proposed', 'rules_approved', 'toss_done'].contains(status);
  }
}
