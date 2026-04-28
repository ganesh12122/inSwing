import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/providers/auth_provider.dart';
import 'package:inswing/providers/matches_provider.dart';
import 'package:inswing/services/storage_service.dart';
import 'package:inswing/theme/app_theme.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/loading_widget.dart';
import 'package:inswing/widgets/common/match_card_widget.dart';
import 'package:inswing/widgets/common/error_widget.dart' as widgets;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Delay loadMatches to avoid modifying provider during build phase
    Future.microtask(() => _loadMatches());
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
    final isTablet = MediaQuery.sizeOf(context).width >= 920;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('inSwing Live Desk'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () async {
              final userId =
                  authState.user?.id ?? await StorageService.getUserId();
              if (userId != null && context.mounted) {
                context.push('/profile/$userId');
              }
            },
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: matchesState.when(
        loading: () => const LoadingWidget(message: 'Loading matches...'),
        error: (message) => widgets.ErrorDisplay(
          message: message.toString(),
          onRetry: _loadMatches,
        ),
        data: (matches) {
          final filtered = _selectedFilter == 'all'
              ? matches
              : matches.where((m) => m.matchType == _selectedFilter).toList();

          final liveMatches =
              filtered.where((m) => m.status == 'live').toList();
          final completedMatches =
              filtered.where((m) => m.status == 'finished').toList();
          final myMatches = filtered
              .where((m) =>
                  m.hostUserId == currentUserId ||
                  m.opponentCaptainId == currentUserId)
              .toList();
          final invitations = matches
              .where((m) =>
                  m.opponentCaptainId == currentUserId && m.status == 'invited')
              .toList();

          final tabs = [liveMatches, completedMatches, myMatches, invitations];

          if (isTablet) {
            return Row(
              children: [
                SizedBox(
                  width: 300,
                  child: _buildTabletRail(
                    liveCount: liveMatches.length,
                    invitesCount: invitations.length,
                  ),
                ),
                Expanded(
                  child: _buildMainContent(
                    tabs,
                    isTablet: true,
                  ),
                ),
              ],
            );
          }

          return _buildMainContent(
            tabs,
            isTablet: false,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/create-match'),
        icon: const Icon(Icons.add),
        label: const Text('New Match'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildMainContent(List<List<Match>> tabs, {required bool isTablet}) {
    return Column(
      children: [
        _buildHeroStrip(),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: TabBar(
            controller: _tabController,
            isScrollable: !isTablet,
            tabAlignment: isTablet ? TabAlignment.fill : null,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'Live'),
              Tab(text: 'Completed'),
              Tab(text: 'My Matches'),
              Tab(text: 'Invites'),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(
              kDefaultPadding, 10, kDefaultPadding, 12),
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
                OutlinedButton.icon(
                  onPressed: _refreshMatches,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMatchesList(
                tabs[0],
                'No live matches',
                'Start a match to begin scoring in real time.',
                Icons.sports_cricket_outlined,
              ),
              _buildMatchesList(
                tabs[1],
                'No completed matches',
                'Finished scorecards will appear here.',
                Icons.emoji_events_outlined,
              ),
              _buildMatchesList(
                tabs[2],
                'No matches yet',
                'Matches you host or join appear here.',
                Icons.person_outline,
              ),
              _buildMatchesList(
                tabs[3],
                'No pending invitations',
                'Invites from other captains appear here.',
                Icons.mail_outline,
                isInvitations: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletRail({required int liveCount, required int invitesCount}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Control Room', style: textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Track every game in one place with instant access to live scoring actions.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            _buildMetricTile(
                'Live Matches', liveCount.toString(), AppTheme.errorColor),
            const SizedBox(height: 10),
            _buildMetricTile(
                'Invitations', invitesCount.toString(), AppTheme.accentColor),
            const SizedBox(height: 10),
            _buildMetricTile(
                'Filter', _selectedFilter.toUpperCase(), AppTheme.infoColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStrip() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 12),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin:
            const EdgeInsets.fromLTRB(kDefaultPadding, 10, kDefaultPadding, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF0C4DA2), Color(0xFF1566CD), Color(0xFF0E9A77)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.sports_cricket, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Professional Live Scoring',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fast entry, clear scoreboards, and match-ready control for every level of cricket.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == filter,
      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.16),
      onSelected: (selected) {
        setState(() => _selectedFilter = selected ? filter : 'all');
        ref
            .read(matchesProvider.notifier)
            .filterMatches(selected ? filter : 'all');
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
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
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
        padding: const EdgeInsets.fromLTRB(
            kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 220 + (index * 45)),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * 10),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MatchCardWidget(
                match: match,
                onTap: () {
                  // Dual captain matches in progress → go to lobby
                  if (match.isDualCaptain &&
                      _isDualCaptainInProgress(match.status)) {
                    context.push('/match/${match.id}/lobby');
                  } else {
                    context.push('/match/${match.id}');
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isDualCaptainInProgress(String status) {
    return [
      'created',
      'invited',
      'accepted',
      'teams_ready',
      'rules_proposed',
      'rules_approved',
      'toss_done'
    ].contains(status);
  }
}
