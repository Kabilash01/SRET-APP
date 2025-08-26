import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../shell/app_shell.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
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
              // AppBar
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
                            'Timetable',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.sretPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.calendar_month,
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
                    _ComingSoonCard(
                      title: 'Weekly Timetable',
                      description: 'View your complete class schedule for the week with interactive calendar.',
                      icon: Icons.schedule,
                    ),
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

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
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
              // AppBar
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
                            'Inbox',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.sretPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mark_email_read,
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
                    _ComingSoonCard(
                      title: 'Notifications & Messages',
                      description: 'Stay updated with announcements, leave approvals, and important notices.',
                      icon: Icons.inbox,
                    ),
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

class DeptPage extends StatelessWidget {
  const DeptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
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
              // AppBar
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
                            'Department',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.sretPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.business,
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
                    _ComingSoonCard(
                      title: 'Department Management',
                      description: 'Manage class schedules, faculty assignments, and departmental resources.',
                      icon: Icons.admin_panel_settings,
                    ),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.sretBg,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
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
              // AppBar
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
                            'Profile',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.sretPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
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
                    _ComingSoonCard(
                      title: 'Profile & Settings',
                      description: 'Manage your account, preferences, and application settings.',
                      icon: Icons.person,
                    ),
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

class _ComingSoonCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _ComingSoonCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: FrostedGlass(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.sretPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: AppTheme.sretPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.sretPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.sretTextSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.sretAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Coming Soon',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.sretAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
