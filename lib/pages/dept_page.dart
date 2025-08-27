import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/quick_action.dart';
import '../theme/sret_theme.dart';

class DeptPage extends StatelessWidget {
  const DeptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOD Dashboard',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          
          // Department overview
          LiquidGlass.card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Computer Science & Engineering',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '32',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.burgundy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Faculty Members',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '480',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.copper,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Students',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Actions
          Text(
            'Management',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              QuickAction(
                icon: Icons.assignment,
                label: 'Allocate Class',
                onTap: () {},
              ),
              QuickAction(
                icon: Icons.swap_horiz,
                label: 'Substitutions',
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Recent activities
          Text(
            'Recent Activities',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          
          _buildActivityTile(
            context,
            title: 'Class Substitution',
            subtitle: 'Dr. Kumar → Prof. Singh (CS301)',
            time: '10 min ago',
          ),
          const SizedBox(height: 12),
          
          _buildActivityTile(
            context,
            title: 'Room Allocation',
            subtitle: 'Lab 2 assigned to Computer Networks',
            time: '2 hours ago',
          ),
          const SizedBox(height: 12),
          
          _buildActivityTile(
            context,
            title: 'Faculty Leave',
            subtitle: 'Dr. Patel approved for tomorrow',
            time: '1 day ago',
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
  }) {
    return LiquidGlass.card(
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.burgundy.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.history,
              size: 16,
              color: AppTheme.burgundy,
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
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
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
