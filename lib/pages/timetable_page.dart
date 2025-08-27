import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/schedule_tile.dart';
import '../theme/sret_theme.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day/Week switch
          LiquidGlass.card(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.burgundy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Today',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Week',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Current Date
          Text(
            'Tuesday, Aug 27, 2025',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 20),
          
          // Period rows
          const ScheduleTile(
            time: '9:00 - 9:50 AM',
            title: 'Data Structures',
            subtitle: 'CSE-A • Room 204 • Dr. Kumar',
          ),
          const SizedBox(height: 12),
          const ScheduleTile(
            time: '10:00 - 10:50 AM',
            title: 'Mathematics III',
            subtitle: 'CSE-A • Room 201 • Prof. Sharma',
            accentColor: AppTheme.copper,
          ),
          const SizedBox(height: 12),
          const ScheduleTile(
            time: '11:30 - 12:20 PM',
            title: 'Database Systems',
            subtitle: 'CSE-B • Room 301 • Dr. Patel',
          ),
          const SizedBox(height: 12),
          
          // Lunch break
          LiquidGlass.card(
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '12:30 - 1:30 PM',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lunch Break',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          const ScheduleTile(
            time: '2:00 - 2:50 PM',
            title: 'Software Engineering',
            subtitle: 'CSE-A • Room 105 • Prof. Singh',
          ),
          const SizedBox(height: 12),
          const ScheduleTile(
            time: '3:00 - 3:50 PM',
            title: 'Computer Networks',
            subtitle: 'CSE-B • Lab 2 • Dr. Reddy',
            accentColor: AppTheme.copper,
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
