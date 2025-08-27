import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../widgets/apple_liquid_glass.dart';
import '../widgets/glass_chip.dart';
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
          child: CustomScrollView(
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
                      // Avatar with subtle glass effect
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: AppleLiquidGlass(
                          radius: const BorderRadius.all(Radius.circular(18)),
                          blur: 16.0,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppTheme.burgundy,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
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
                                  style: GoogleFonts.robotoSerif(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.burgundy,
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
                              style: GoogleFonts.robotoSerif(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.burgundy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppTheme.burgundy.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '10:00 AM - 11:30 AM',
                                  style: GoogleFonts.robotoSerif(
                                    fontSize: 16,
                                    color: AppTheme.burgundy.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppTheme.burgundy.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
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
                        style: GoogleFonts.robotoSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.burgundy,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              
              // Schedule items
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final scheduleItems = [
                      {
                        'time': '9:00 AM',
                        'title': 'Team Standup',
                        'description': 'Daily sync with development team',
                        'color': AppTheme.burgundy,
                      },
                      {
                        'time': '11:30 AM',
                        'title': 'Client Presentation',
                        'description': 'Q4 results and roadmap review',
                        'color': Colors.orange,
                      },
                      {
                        'time': '2:00 PM',
                        'title': 'Design Review',
                        'description': 'Mobile app interface updates',
                        'color': AppTheme.burgundy,
                      },
                    ];
                    
                    if (index >= scheduleItems.length) return null;
                    
                    final item = scheduleItems[index];
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: AppleLiquidGlass(
                        radius: const BorderRadius.all(Radius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
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
                                      style: GoogleFonts.robotoSerif(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['title'] as String,
                                      style: GoogleFonts.robotoSerif(
                                        fontSize: 16,
                                        color: AppTheme.burgundy,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['description'] as String,
                                      style: GoogleFonts.robotoSerif(
                                        fontSize: 14,
                                        color: AppTheme.burgundy.withOpacity(0.7),
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
                                    backgroundColor: AppTheme.burgundy,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.burgundy,
                                    side: BorderSide(color: AppTheme.burgundy),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Bottom padding for navigation
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
