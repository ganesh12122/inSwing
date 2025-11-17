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
    _tabController = TabController(length: 3, vsync: this);
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
          tabs: const [
            Tab(text: 'Live'),
            Tab(text: 'Completed'),
            Tab(text: 'My Matches'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedFilter == 'all',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'all');
                    ref.read(matchesProvider.notifier).filterMatches('all');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Quick'),
                  selected: _selectedFilter == 'quick',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'quick');
                    ref.read(matchesProvider.notifier).filterMatches('quick');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Tournament'),
                  selected: _selectedFilter == 'tournament',
                  onSelected: (selected) {
                    setState(() => _selectedFilter = 'tournament');
                    ref.read(matchesProvider.notifier).filterMatches('tournament');
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshMatches,
                ),
              ],
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
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Live matches
                    _buildMatchesList(
                      matches.where((m) => m.status == 'live').toList(),
                      'No live matches',
                      'Live matches will appear here',
                    ),
                    
                    // Completed matches
                    _buildMatchesList(
                      matches.where((m) => m.status == 'finished').toList(),
                      'No completed matches',
                      'Completed matches will appear here',
                    ),
                    
                    // My matches
                    _buildMatchesList(
                      matches.where((m) => m.hostUserId == authState.user?.id).toList(),
                      'No matches hosted by you',
                      'Matches you create will appear here',
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

  Widget _buildMatchesList(List<Match> matches, String emptyTitle, String emptySubtitle) {
    if (matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_cricket_outlined,
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
              onTap: () => context.push('/match/${match.id}'),
            ),
          );
        },
      ),
    );
  }
}