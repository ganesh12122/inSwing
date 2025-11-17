import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inswing/providers/auth_provider.dart';
import 'package:inswing/utils/constants.dart';
import 'package:inswing/widgets/common/loading_widget.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (authState.isLoading) {
            return const LoadingWidget(message: 'Loading profile...');
          }
          if (authState.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${authState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(authProvider.notifier).reloadUserData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return _buildProfileContent(context, authState, theme, ref);
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, AuthState state, ThemeData theme, WidgetRef ref) {
    final user = state.user;
    final userProfile = state.userProfile;

    if (user == null) {
      return const Center(child: Text('No user data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          // User header card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      user.name?.isNotEmpty == true ? user.name![0].toUpperCase() : '?',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name ?? 'Unknown User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (userProfile != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      userProfile.primaryRole.toUpperCase(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    user.phoneNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stats card
          if (userProfile != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Player Stats',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Rating',
                          userProfile.overallRating.toStringAsFixed(1),
                          theme,
                          icon: Icons.star,
                        ),
                        _buildStatItem(
                          'Level',
                          userProfile.playerLevel,
                          theme,
                          icon: Icons.trending_up,
                        ),
                        _buildStatItem(
                          'Joined',
                          _formatDate(userProfile.joinDate),
                          theme,
                          icon: Icons.calendar_today,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
          
          // Actions card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _editProfile(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _viewPlayerStats(context, ref),
                    icon: const Icon(Icons.sports_cricket),
                    label: const Text('View Cricket Stats'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _changePassword(context),
                    icon: const Icon(Icons.lock),
                    label: const Text('Change Password'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme, {IconData? icon}) {
    return Column(
      children: [
        if (icon != null) Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context) {
    // TODO: Implement edit profile functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile coming soon...')),
    );
  }

  void _viewPlayerStats(BuildContext context, WidgetRef ref) {
    final userId = ref.read(authProvider).user?.id;
    if (userId != null) {
      context.push('/player/$userId');
    }
  }

  void _changePassword(BuildContext context) {
    // TODO: Implement change password functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password coming soon...')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}