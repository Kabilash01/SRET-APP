import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/apple_liquid_glass.dart';
import '../shared/glass_chip.dart';
import '../shared/liquid_pill_nav.dart';
import '../../theme/app_theme.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              slivers: [
                // App bar with date and avatar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: AppTheme.sretPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Monday, August 26',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.sretText.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        // Avatar with subtle glass effect
                        AppleLiquidGlass(
                          radius: const BorderRadius.all(Radius.circular(18)),
                          blur: 16.0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppTheme.sretText,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Next Class card with Apple liquid glass
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: AppleLiquidGlass(
                        radius: const BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Next Class',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: AppTheme.sretText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const GlassChip(
                                    text: 'Starts in 30m',
                                    radius: 18.0,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Data Structures & Algorithms',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.sretPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: AppTheme.sretAccent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '10:00 AM - 11:30 AM',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.sretText.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppTheme.sretAccent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Room 301, CS Building',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.sretText.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Schedule section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Today\'s Schedule',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.sretPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                
                // Schedule items (kept static for readability)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final scheduleItems = [
                        {
                          'time': '9:00 AM',
                          'title': 'Team Standup',
                          'description': 'Daily sync with development team',
                          'color': AppTheme.sretPrimary,
                        },
                        {
                          'time': '11:30 AM',
                          'title': 'Client Presentation',
                          'description': 'Q4 results and roadmap review',
                          'color': AppTheme.sretAccent,
                        },
                        {
                          'time': '2:00 PM',
                          'title': 'Design Review',
                          'description': 'Mobile app interface updates',
                          'color': AppTheme.sretPrimary,
                        },
                      ];
                      
                      if (index >= scheduleItems.length) return null;
                      
                      final item = scheduleItems[index];
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.sretSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.sretDivider,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['time'] as String,
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: AppTheme.sretAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['title'] as String,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: AppTheme.sretText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['description'] as String,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.sretText.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const GlassChip(
                                text: '⋯',
                                radius: 12.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: 3,
                  ),
                ),
                
                // Bottom actions with Apple liquid glass
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppleLiquidGlass(
                      radius: const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.sretPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Apply Leave'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.sretPrimary,
                                      side: const BorderSide(color: AppTheme.sretPrimary),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Navigate to Room'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Bottom padding for floating nav
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
            
            // Floating liquid pill navigation
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: LiquidPillNav(
                selectedIndex: 0, // Today page is selected
                onChanged: (index) {
                  // Handle navigation using GoRouter
                  switch (index) {
                    case 0:
                      // Already on Today page
                      break;
                    case 1:
                      // Navigate to Timetable
                      context.go('/timetable');
                      break;
                    case 2:
                      // Navigate to Calendar
                      context.go('/calendar');
                      break;
                    case 3:
                      // Navigate to Inbox
                      context.go('/inbox');
                      break;
                    case 4:
                      // Navigate to Department
                      context.go('/dept');
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
