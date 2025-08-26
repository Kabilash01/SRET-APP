import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/schedule/schedule_providers.dart';
import '../../core/schedule/models.dart';
import '../../theme/app_theme.dart';
import '../shared/liquid_glass.dart';
import '../shell/app_shell.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: Stack(
        children: [
          // Background with subtle blobs
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 2.0,
                  colors: [
                    Color(0x0A7A0E2A), // Burgundy 4%
                    Color(0x05DFA06E), // Copper 2%
                  ],
                ),
              ),
            ),
          ),
          
          CustomScrollView(
            slivers: [
              // AppBar on frosted glass
              SliverAppBar(
                expandedHeight: 100,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: FrostedGlass(
                    borderRadius: BorderRadius.zero,
                    opacity: 0.85,
                    child: Container(
                      padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                      child: Row(
                        children: [
                          Text(
                            'Today',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.sretPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Refresh data
                              ref.invalidate(todayScheduleProvider);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: AppTheme.sretPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Content
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Hero card for next class
                    _NextClassHeroCard(),
                    
                    const SizedBox(height: 32),
                    
                    // Today's schedule section
                    _TodayScheduleSection(),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextClassHeroCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextSession = ref.watch(nextSessionProvider);
    final countdownAsync = ref.watch(countdownStreamProvider);
    final allDone = ref.watch(allClassesDoneProvider);

    if (allDone) {
      return _AllDoneCard();
    }

    if (nextSession == null) {
      return _NoClassesCard();
    }

    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: LiquidGlass(
          radius: const BorderRadius.all(Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  nextSession.isInProgress ? 'Current class' : 'Next class',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.sretTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subject and section
                Text(
                  nextSession.subject,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.sretPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Section ${nextSession.section} • ${nextSession.code}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.sretTextSecondary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Time and room row
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.sretTextSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      nextSession.timeRange,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.sretText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.sretAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppTheme.sretAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            nextSession.room,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.sretAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Countdown badge
                countdownAsync.when(
                  data: (countdown) {
                    if (countdown == null) return const SizedBox.shrink();
                    
                    final isInProgress = nextSession.isInProgress;
                    final minutes = countdown.inMinutes;
                    final seconds = countdown.inSeconds % 60;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isInProgress 
                            ? Colors.green.withValues(alpha: 0.1)
                            : AppTheme.sretPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isInProgress 
                              ? Colors.green.withValues(alpha: 0.3)
                              : AppTheme.sretPrimary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isInProgress ? Icons.play_circle : Icons.timer,
                            size: 16,
                            color: isInProgress ? Colors.green : AppTheme.sretPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isInProgress 
                                ? 'Now • ends ${nextSession.endTimeFormatted}'
                                : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} until start',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isInProgress ? Colors.green : AppTheme.sretPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                
                const SizedBox(height: 20),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.go('/timetable');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sretPrimary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.schedule, size: 18),
                        label: const Text('View timetable'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showLeaveDialog(context, ref, nextSession);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.sretPrimary,
                          side: BorderSide(color: AppTheme.sretPrimary),
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.event_busy, size: 18),
                        label: const Text('Apply leave'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().slideY(
      begin: 0.3,
      end: 0,
      duration: 300.ms,
      curve: Curves.easeOut,
    ).fadeIn(duration: 300.ms);
  }

  void _showLeaveDialog(BuildContext context, WidgetRef ref, ClassSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Leave'),
        content: Text('Apply for leave for ${session.subject} on ${session.start.relativeDateFormat}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Mock leave application
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leave application submitted!'),
                ),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _AllDoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: FrostedGlass(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'All done for today! 🎉',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.sretPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ve completed all your scheduled classes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sretTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: 400.ms,
      curve: Curves.elasticOut,
    ).fadeIn(duration: 300.ms);
  }
}

class _NoClassesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: FrostedGlass(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.sretAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.free_breakfast,
                  size: 40,
                  color: AppTheme.sretAccent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No classes scheduled',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.sretPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enjoy your free day!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sretTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayScheduleSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayScheduleAsync = ref.watch(todayScheduleProvider);

    return todayScheduleAsync.when(
      data: (schedule) {
        if (!schedule.hasClasses) {
          return const SizedBox.shrink();
        }

        final sessions = schedule.sortedSessions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s schedule',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.sretPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ...sessions.asMap().entries.map((entry) {
              final index = entry.key;
              final session = entry.value;
              
              return Padding(
                padding: EdgeInsets.only(bottom: index < sessions.length - 1 ? 12 : 0),
                child: _SessionCard(session: session),
              );
            }),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load schedule',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(todayScheduleProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final ClassSession session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final isActive = session.isInProgress;
    final isNext = session.isUpcoming;
    final isCompleted = session.hasEnded;

    return FrostedGlass(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      color: isActive 
          ? Colors.green.withValues(alpha: 0.05)
          : isNext 
              ? AppTheme.sretPrimary.withValues(alpha: 0.05)
              : AppTheme.sretSurface,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: isActive || isNext 
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive 
                      ? Colors.green.withValues(alpha: 0.3)
                      : AppTheme.sretPrimary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              )
            : null,
        child: Row(
          children: [
            // Time column
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.startTimeFormatted,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isCompleted 
                          ? AppTheme.sretTextSecondary
                          : AppTheme.sretText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    session.endTimeFormatted,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.sretTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Status indicator
            Container(
              width: 4,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive 
                    ? Colors.green
                    : isNext 
                        ? AppTheme.sretPrimary
                        : AppTheme.sretDivider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.subject,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isCompleted 
                          ? AppTheme.sretTextSecondary
                          : AppTheme.sretText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${session.code} • Section ${session.section}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.sretTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppTheme.sretTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.room,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.sretTextSecondary,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NOW',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().slideX(
      begin: 0.3,
      end: 0,
      duration: 300.ms,
      curve: Curves.easeOut,
    ).fadeIn(duration: 300.ms);
  }
}
