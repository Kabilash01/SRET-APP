import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../theme/sret_theme.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Messages & Alerts',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          
          // Message tiles
          _buildMessageTile(
            context,
            title: 'Class Cancelled',
            subtitle: 'Database Systems class has been cancelled for today.',
            time: '2 min ago',
            isUnread: true,
          ),
          const SizedBox(height: 12),
          
          _buildMessageTile(
            context,
            title: 'Assignment Reminder',
            subtitle: 'Data Structures assignment due tomorrow.',
            time: '1 hour ago',
            isUnread: true,
          ),
          const SizedBox(height: 12),
          
          _buildMessageTile(
            context,
            title: 'Room Change',
            subtitle: 'Software Engineering moved to Room 208.',
            time: '3 hours ago',
            isUnread: false,
          ),
          const SizedBox(height: 12),
          
          _buildMessageTile(
            context,
            title: 'Department Meeting',
            subtitle: 'Faculty meeting scheduled for Friday 3 PM.',
            time: '1 day ago',
            isUnread: false,
          ),
          const SizedBox(height: 12),
          
          _buildMessageTile(
            context,
            title: 'New Course Material',
            subtitle: 'Computer Networks lecture notes uploaded.',
            time: '2 days ago',
            isUnread: false,
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMessageTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return LiquidGlass.card(
      child: Row(
        children: [
          // Unread indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isUnread ? AppTheme.burgundy : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Time
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
