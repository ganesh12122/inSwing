import 'package:flutter/material.dart';
import 'package:inswing/models/match_model.dart';
import 'package:inswing/theme/app_theme.dart';
import 'package:inswing/utils/constants.dart';
import 'package:intl/intl.dart';

/// Match card widget — handles all match statuses including dual-captain lifecycle.
class MatchCardWidget extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchCardWidget({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLive = match.status == 'live';
    final isFinished = match.status == 'finished';
    final isDualCaptain = match.isDualCaptain;
    final hasScores = isLive || isFinished;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: status badge + match type + live indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(theme, match.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kMatchStatusLabels[match.status]?.toUpperCase() ?? match.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isDualCaptain)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people, size: 12, color: theme.colorScheme.primary),
                          const SizedBox(width: 3),
                          Text(
                            'DUAL',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      kMatchTypeLabels[match.matchType]?.toUpperCase() ?? match.matchType.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                  const Spacer(),
                  if (isLive) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // Team names + scores
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.teamAName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (hasScores) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${match.teamARuns ?? 0}/${match.teamAWickets ?? 0} (${match.teamAOvers ?? 0.0})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'VS',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          match.teamBName ?? '?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontStyle: match.teamBName == null ? FontStyle.italic : null,
                            color: match.teamBName == null
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                        if (hasScores) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${match.teamBRuns ?? 0}/${match.teamBWickets ?? 0} (${match.teamBOvers ?? 0.0})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              // Dual-captain progress hint
              if (isDualCaptain && _isDualCaptainInProgress(match.status)) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(theme, match.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusHint(match.status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(theme, match.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              // Venue
              if (match.venue != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        match.venue!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),

              // Footer: time + scheduled + arrow
              Row(
                children: [
                  Icon(Icons.schedule, size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  Text(
                    _formatMatchTime(match.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (match.scheduledAt != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.event, size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Text(
                      _formatScheduledTime(match.scheduledAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDualCaptainInProgress(String status) {
    return ['created', 'invited', 'accepted', 'teams_ready',
            'rules_proposed', 'rules_approved', 'toss_done'].contains(status);
  }

  String _getStatusHint(String status) {
    switch (status) {
      case 'created':
        return '⏳ Waiting to invite opponent';
      case 'invited':
        return '📨 Invitation sent, awaiting response';
      case 'accepted':
        return '👥 Setting up teams';
      case 'teams_ready':
        return '📋 Teams ready, negotiate rules';
      case 'rules_proposed':
        return '⚖️ Rules under negotiation';
      case 'rules_approved':
        return '🪙 Ready for toss';
      case 'toss_done':
        return '🏏 Ready to start';
      default:
        return '';
    }
  }

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status) {
      case 'live':
        return AppTheme.errorColor;
      case 'finished':
        return AppTheme.successColor;
      case 'toss_done':
        return AppTheme.infoColor;
      case 'created':
        return AppTheme.warningColor;
      case 'invited':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'teams_ready':
        return Colors.teal;
      case 'rules_proposed':
        return Colors.purple;
      case 'rules_approved':
        return Colors.green.shade600;
      case 'declined':
        return Colors.red.shade400;
      case 'cancelled':
        return Colors.grey;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  String _formatMatchTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  String _formatScheduledTime(DateTime scheduledAt) {
    return DateFormat('MMM d, h:mm a').format(scheduledAt);
  }
}
