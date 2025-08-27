import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../theme/sret_theme.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/quick_schedule_tile.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Header
              _buildHeader(context),
              const SizedBox(height: 32),
              // Next Class Card
              _buildNextClassCard(),
              const SizedBox(height: 32),
              // Quick Schedule Section
              _buildQuickScheduleSection(),
              const SizedBox(height: 32),
              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 100), // Bottom padding for nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: GoogleFonts.robotoSerif(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.burgundy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monday, August 26',
                style: GoogleFonts.robotoSerif(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.burgundy.withOpacity(0.7),
                ),
              ),
            ],
          ),
          // Profile button
          GestureDetector(
            onTap: () {
              context.go('/profile');
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.burgundy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextClassCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiquidGlass.card(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.burgundy,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Next Class',
                    style: GoogleFonts.robotoSerif(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.burgundy,
                    ),
                  ),
                  const Spacer(),
                  LiquidGlass.pill(
                    height: 28,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      alignment: Alignment.center,
                      child: Text(
                        'Starts in 30m',
                        style: GoogleFonts.robotoSerif(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Data Structures & Algorithms',
                style: GoogleFonts.robotoSerif(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.burgundy,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '10:00 AM - 11:30 AM',
                    style: GoogleFonts.robotoSerif(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.burgundy.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Room 301, CS Building',
                    style: GoogleFonts.robotoSerif(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.burgundy.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickScheduleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Schedule',
            style: GoogleFonts.robotoSerif(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.burgundy,
            ),
          ),
          const SizedBox(height: 16),
          const QuickScheduleTile(
            time: '9:00 AM',
            title: 'Team Standup',
            subtitle: 'Daily sync with development team',
            barColor: AppTheme.burgundy,
          ),
          const SizedBox(height: 12),
          const QuickScheduleTile(
            time: '11:30 AM',
            title: 'Client Presentation',
            subtitle: 'Q4 results and roadmap review',
            barColor: AppTheme.gold,
          ),
          const SizedBox(height: 12),
          const QuickScheduleTile(
            time: '2:00 PM',
            title: 'Design Review',
            subtitle: 'Mobile app interface updates',
            barColor: AppTheme.burgundy,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.burgundy,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'Apply Leave',
                  style: GoogleFonts.robotoSerif(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.burgundy.withOpacity(0.3),
                  width: 1,
                ),
                color: Colors.white.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  'Navigate to Room',
                  style: GoogleFonts.robotoSerif(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.burgundy,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
