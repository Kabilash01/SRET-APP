import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/liquid_glass.dart';
import '../theme/sret_theme.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userDisplayName = 'Dr. Rajesh Kumar';
  String _userEmail = 'rajesh.kumar@sret.edu.in';
  String _userPhotoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await AuthService.getUserInfo();
    setState(() {
      _userDisplayName = userInfo['displayName']!;
      _userEmail = userInfo['email']!;
      _userPhotoUrl = userInfo['photoUrl']!;
    });
  }

  Future<void> _signOut() async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        backgroundColor: AppTheme.sand,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.burgundy),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AuthService.signOut();

        if (mounted) {
          context.go('/signin');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          LiquidGlass.card(
            child: Row(
              children: [
                _userPhotoUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          _userPhotoUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return LiquidGlass.circle(
                              padding: const EdgeInsets.all(20),
                              child: Icon(
                                Icons.person,
                                size: 32,
                                color: AppTheme.burgundy,
                              ),
                            );
                          },
                        ),
                      )
                    : LiquidGlass.circle(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: AppTheme.burgundy,
                        ),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userDisplayName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Associate Professor',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.burgundy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _userEmail,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: LiquidGlass.card(
                  child: Column(
                    children: [
                      Text(
                        '8',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.burgundy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Classes Today',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LiquidGlass.card(
                  child: Column(
                    children: [
                      Text(
                        '24',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.copper,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'This Week',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Settings List
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            context,
            icon: Icons.schedule,
            title: 'Schedule Preferences',
            subtitle: 'Set your availability and preferences',
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            context,
            icon: Icons.security,
            title: 'Privacy & Security',
            subtitle: 'Manage your account security',
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
          ),
          const SizedBox(height: 12),
          
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            isDestructive: true,
            onTap: _signOut,
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlass.card(
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : AppTheme.burgundy,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDestructive ? Colors.red : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
