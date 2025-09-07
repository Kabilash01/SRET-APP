import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/glass_pill_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with GlassPillNavMixin {
  @override
  int get selectedNavIndex => 3; // Profile tab index

  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _weekendNotifications = false;
  bool _emergencyAlerts = true;
  bool _substitutionAlerts = true;
  bool _timetableChanges = true;
  
  String _notificationTime = '08:00';
  String _emergencyContactRole = 'Head of Department';
  String _selectedTheme = 'Auto';
  String _selectedLanguage = 'English';
  String _biometricsStatus = 'Enabled';
  String _lastPasswordChange = '2 months ago';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                floating: true,
                pinned: false,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
              ),
              
              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Identity Card
                      _buildIdentityCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Account & Security Section
                      _buildSectionTitle('Account & Security'),
                      const SizedBox(height: 12),
                      _buildAccountSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Notifications Section
                      _buildSectionTitle('Notifications'),
                      const SizedBox(height: 12),
                      _buildNotificationsSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Substitution Preferences
                      _buildSectionTitle('Substitution Preferences'),
                      const SizedBox(height: 12),
                      _buildSubstitutionSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Calendar Settings
                      _buildSectionTitle('Calendar & Schedule'),
                      const SizedBox(height: 12),
                      _buildCalendarSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Support & Information
                      _buildSectionTitle('Support & Information'),
                      const SizedBox(height: 12),
                      _buildSupportSection(),
                      
                      const SizedBox(height: 120), // Bottom navigation space
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Glass pill navigation overlay
          GlassPillNav(
            selectedIndex: selectedNavIndex,
            onItemTapped: handleNavTap,
            items: GlassPillNavMixin.navItems,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildIdentityCard() {
    return LiquidGlass(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Profile Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.burgundy,
                        AppColors.burgundy.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.burgundy.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Profile Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dr. Sarah Williams',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Associate Professor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Computer Science Department',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Quick actions
                      Row(
                        children: [
                          _buildQuickActionChip('ID: FAC2024001'),
                          const SizedBox(width: 8),
                          _buildQuickActionChip('Edit Profile'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Contact Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildContactRow(Icons.email_outlined, 'sarah.williams@sret.edu.in'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.phone_outlined, '+91 98765 43210'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.location_on_outlined, 'Office: Block A, Room 301'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.burgundy.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.burgundy.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.burgundy,
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.burgundy,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
            // TODO: Show copied feedback
          },
          icon: const Icon(
            Icons.copy_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return LiquidGlass(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingsTile(
              icon: Icons.lock_outlined,
              title: 'Change Password',
              subtitle: 'Last changed $_lastPasswordChange',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.fingerprint_outlined,
              title: 'Biometric Authentication',
              subtitle: 'Status: $_biometricsStatus',
              trailing: Switch(
                value: _biometricsStatus == 'Enabled',
                onChanged: (value) {
                  setState(() {
                    _biometricsStatus = value ? 'Enabled' : 'Disabled';
                  });
                  // TODO: Implement biometric toggle
                },
                activeColor: AppColors.burgundy,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.security_outlined,
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.devices_outlined,
              title: 'Connected Devices',
              subtitle: 'Manage your logged-in devices',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return LiquidGlass(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSwitchTile(
              'Email Notifications',
              'Receive updates via email',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              'Push Notifications',
              'Get instant app notifications',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              'Weekend Notifications',
              'Receive notifications on weekends',
              _weekendNotifications,
              (value) => setState(() => _weekendNotifications = value),
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              'Emergency Alerts',
              'Critical campus notifications',
              _emergencyAlerts,
              (value) => setState(() => _emergencyAlerts = value),
            ),
            
            const SizedBox(height: 20),
            
            // Notification Time Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Notification Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose when to receive daily schedule reminders',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // TODO: Show time picker
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.burgundy.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.burgundy.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _notificationTime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.burgundy,
                            ),
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            color: AppColors.burgundy,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubstitutionSection() {
    return LiquidGlass(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSwitchTile(
              'Substitution Alerts',
              'Get notified of class substitutions',
              _substitutionAlerts,
              (value) => setState(() => _substitutionAlerts = value),
            ),
            
            const SizedBox(height: 16),
            
            _buildSwitchTile(
              'Timetable Changes',
              'Receive updates on schedule modifications',
              _timetableChanges,
              (value) => setState(() => _timetableChanges = value),
            ),
            
            const SizedBox(height: 20),
            
            // Emergency Contact Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Emergency Contact Role',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your role in emergency situations',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Head of Department',
                      'Faculty Coordinator',
                      'Emergency Contact',
                      'Student Advisor',
                    ].map((role) => _buildChoiceChip(role, _emergencyContactRole)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return LiquidGlass(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingsTile(
              icon: Icons.calendar_today_outlined,
              title: 'Calendar Integration',
              subtitle: 'Sync with external calendars',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.schedule_outlined,
              title: 'Default View',
              subtitle: 'Week view selected',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.color_lens_outlined,
              title: 'Calendar Colors',
              subtitle: 'Customize event colors',
            ),
            
            const SizedBox(height: 20),
            
            // Working Hours Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Working Hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Define your available teaching hours',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeSelector('Start Time', '09:00'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimeSelector('End Time', '17:00'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return LiquidGlass(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help & FAQ',
              subtitle: 'Find answers to common questions',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Help us improve the app',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Learn how we protect your data',
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
            ),
            
            const SizedBox(height: 24),
            
            // App Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'App Preferences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Theme Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Theme',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _selectedTheme,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: _selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                          // TODO: Implement theme change
                        },
                        underline: const SizedBox(),
                        items: ['Auto', 'Light', 'Dark'].map((theme) {
                          return DropdownMenuItem<String>(
                            value: theme,
                            child: Text(theme),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Language Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Language',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _selectedLanguage,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                          // TODO: Implement language change
                        },
                        underline: const SizedBox(),
                        items: ['English', 'Hindi', 'Kannada'].map((language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign out
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.burgundy,
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, String selectedValue) {
    final isSelected = label == selectedValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _emergencyContactRole = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.burgundy.withOpacity(0.2)
              : AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? AppColors.burgundy
                : AppColors.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected 
                ? AppColors.burgundy
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, String time) {
    return GestureDetector(
      onTap: () {
        // TODO: Show time picker
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.burgundy.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.burgundy.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.burgundy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for consistent settings tiles
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.burgundy.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.burgundy,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing,
            ] else ...[
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
