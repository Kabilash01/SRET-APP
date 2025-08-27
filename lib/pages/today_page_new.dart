import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/liquid_glass.dart';
import '../theme/sret_theme.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.beige,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.beige,
              AppTheme.sand.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Today title and profile icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today',
                          style: GoogleFonts.robotoSerif(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.burgundy,
                          ),
                        ),
                        Text(
                          'Monday, August 26',
                          style: GoogleFonts.robotoSerif(
                            fontSize: 16,
                            color: AppTheme.burgundy.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.burgundy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      
                      // Next Class Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Next Class',
                            style: GoogleFonts.robotoSerif(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.burgundy,
                            ),
                          ),
                          Text(
                            'Starts in 30m',
                            style: GoogleFonts.robotoSerif(
                              fontSize: 14,
                              color: AppTheme.burgundy.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Next Class Card
                      LiquidGlass.card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Structures & Algorithms',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.burgundy,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 18,
                                    color: AppTheme.burgundy.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '10:00 AM - 11:30 AM',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      color: AppTheme.burgundy.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: AppTheme.burgundy.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Room 301, CS Building',
                                    style: GoogleFonts.robotoSerif(
                                      fontSize: 16,
                                      color: AppTheme.burgundy.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Today's Schedule Section
                      Text(
                        'Today\'s Schedule',
                        style: GoogleFonts.robotoSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.burgundy,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Schedule Items
                      _buildScheduleItem(
                        time: '9:00 AM',
                        title: 'Team Standup',
                        subtitle: 'Daily sync with development team',
                        color: AppTheme.burgundy,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildScheduleItem(
                        time: '11:30 AM',
                        title: 'Client Presentation',
                        subtitle: 'Q4 results and roadmap review',
                        color: Colors.orange,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildScheduleItem(
                        time: '2:00 PM',
                        title: 'Design Review',
                        subtitle: 'Mobile app interface updates',
                        color: AppTheme.burgundy,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Apply Leave functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.burgundy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Apply Leave',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Navigate to Room functionality
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppTheme.burgundy,
                                  width: 1.5,
                                ),
                                foregroundColor: AppTheme.burgundy,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Navigate to Room',
                                style: GoogleFonts.robotoSerif(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return LiquidGlass.card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: GoogleFonts.robotoSerif(
                      fontSize: 14,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.robotoSerif(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.burgundy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.robotoSerif(
                      fontSize: 14,
                      color: AppTheme.burgundy.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.more_horiz,
              color: AppTheme.burgundy.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
