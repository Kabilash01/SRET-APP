import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/glass_pill_nav.dart';

// App lifecycle observer helper
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResumed;
  
  _AppLifecycleObserver(this.onResumed);
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}

// Mock data models
class Course {
  final String id;
  final String code;
  final String name;
  final String courseType;
  final int credits;
  final String faculty;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.courseType,
    required this.credits,
    required this.faculty,
  });
}

class TimetableEntry {
  final String id;
  final Course course;
  final int dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String section;
  final String semester;
  final String room;
  final String building;
  final String academicYear;
  final bool isGuest;
  final bool isOnline;
  final bool isSpecial;
  final String? notes;

  TimetableEntry({
    required this.id,
    required this.course,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.section,
    required this.semester,
    required this.room,
    required this.building,
    required this.academicYear,
    this.isGuest = false,
    this.isOnline = false,
    this.isSpecial = false,
    this.notes,
  });
}

enum ClassStatus {
  now,
  upcoming,
  completed,
}

class ClassSession {
  final TimetableEntry entry;
  final ClassStatus status;
  final Duration? timeRemaining;
  final String statusText;

  ClassSession({
    required this.entry,
    required this.status,
    this.timeRemaining,
    required this.statusText,
  });
}

enum SmartBannerType {
  substitution,
  leaveRequest,
  classSwap,
  urgent,
  location,
  preparation,
  reminder,
  general,
}

enum BannerUrgency {
  low,
  medium,
  high,
  critical,
}

class SmartBanner {
  final String id;
  final SmartBannerType type;
  final String title;
  final String action;
  final VoidCallback onTap;
  final BannerUrgency urgency;
  final IconData icon;

  SmartBanner({
    required this.id,
    required this.type,
    required this.title,
    required this.action,
    required this.onTap,
    this.urgency = BannerUrgency.low,
    required this.icon,
  });
}

class UserPreferences {
  final int reminderMinutes;
  final bool isDndEnabled;
  final bool substitutionOptIn;
  final String timezone;

  UserPreferences({
    this.reminderMinutes = 10,
    this.isDndEnabled = false,
    this.substitutionOptIn = true,
    this.timezone = 'Asia/Kolkata',
  });
}

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> with TickerProviderStateMixin, GlassPillNavMixin {
  Timer? _updateTimer;
  List<ClassSession> _todaysClasses = [];
  List<ClassSession> _upcomingClasses = [];
  List<ClassSession> _completedClasses = [];
  ClassSession? _heroClass;
  ClassSession? _currentClass;
  bool _isLoading = true;
  String? _error;
  bool _isOffline = false;
  bool _isOnline = true;
  List<SmartBanner> _smartBanners = [];
  DateTime _lastFetchTime = DateTime.now();
  final UserPreferences _userPreferences = UserPreferences();
  late AnimationController _actionCardController;
  late Animation<double> _actionCardAnimation;
  late AnimationController _heroProgressController;
  late Animation<double> _heroProgressAnimation;
  
  // Glass pill navigation
  @override
  int get selectedNavIndex => 0; // Today page is index 0
  
  // Cache duration for smooth UX
  static const Duration _cacheTimeout = Duration(minutes: 3);
  
  // Device timezone check
  bool get _isTimezoneMatch => DateTime.now().timeZoneName == _userPreferences.timezone;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _actionCardController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _actionCardAnimation = CurvedAnimation(
      parent: _actionCardController,
      curve: Curves.easeInOut,
    );
    
    _heroProgressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heroProgressAnimation = CurvedAnimation(
      parent: _heroProgressController,
      curve: Curves.easeInOut,
    );
    
    _loadTodayData();
    _startUpdateTimer();
    
    // Listen to app lifecycle for refresh on resume
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(_onAppResumed));
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _actionCardController.dispose();
    _heroProgressController.dispose();
    WidgetsBinding.instance.removeObserver(_AppLifecycleObserver(_onAppResumed));
    super.dispose();
  }

  void _onAppResumed() {
    final now = DateTime.now();
    if (now.difference(_lastFetchTime) > _cacheTimeout) {
      _loadTodayData();
    }
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateClassStatuses();
    });
  }

  void _loadTodayData() {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Simulate network call
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        try {
          _generateMockData();
          _lastFetchTime = DateTime.now();
          setState(() {
            _isLoading = false;
            _isOffline = false;
            _updateSmartBanners();
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
            _error = 'Failed to load schedule';
            _isOffline = true;
          });
        }
      }
    });
  }

  void _generateMockData() {
    final now = TimeOfDay.now();
    final today = DateTime.now();
    
    final courses = [
      Course(id: '1', code: 'CS101', name: 'Computer Programming', courseType: 'Theory', credits: 3, faculty: 'Dr. Smith'),
      Course(id: '2', code: 'CS102L', name: 'Programming Lab', courseType: 'Lab', credits: 2, faculty: 'Prof. Johnson'),
      Course(id: '3', code: 'MA201', name: 'Advanced Mathematics', courseType: 'Theory', credits: 4, faculty: 'Dr. Williams'),
      Course(id: '4', code: 'CS201P', name: 'Software Project', courseType: 'Project', credits: 2, faculty: 'Prof. Brown'),
    ];

    final timetableEntries = [
      TimetableEntry(
        id: '1',
        course: courses[0],
        dayOfWeek: today.weekday,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 50),
        section: 'A',
        semester: 'III',
        room: '101',
        building: 'CS Block',
        academicYear: '2024-25',
        notes: 'Regular theory class',
      ),
      TimetableEntry(
        id: '2',
        course: courses[1],
        dayOfWeek: today.weekday,
        startTime: const TimeOfDay(hour: 11, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 30),
        section: 'A',
        semester: 'III',
        room: 'Lab-2',
        building: 'CS Block',
        academicYear: '2024-25',
        isSpecial: true,
        notes: 'Advanced programming lab session',
      ),
      TimetableEntry(
        id: '3',
        course: courses[2],
        dayOfWeek: today.weekday,
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 14, minute: 50),
        section: 'B',
        semester: 'III',
        room: '205',
        building: 'Main Block',
        academicYear: '2024-25',
        isOnline: true,
        notes: 'Online mathematics lecture',
      ),
      TimetableEntry(
        id: '4',
        course: courses[3],
        dayOfWeek: today.weekday,
        startTime: const TimeOfDay(hour: 15, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 30),
        section: 'A',
        semester: 'III',
        room: '301',
        building: 'CS Block',
        academicYear: '2024-25',
        isGuest: true,
        notes: 'Guest lecture on software engineering',
      ),
    ];

    _todaysClasses = timetableEntries.map((entry) {
      final status = _getClassStatus(entry, now);
      final timeRemaining = _getTimeRemaining(entry, now);
      final statusText = _getStatusText(entry, now, timeRemaining);
      
      return ClassSession(
        entry: entry,
        status: status,
        timeRemaining: timeRemaining,
        statusText: statusText,
      );
    }).toList();

    _todaysClasses.sort((a, b) => _compareTimeOfDay(a.entry.startTime, b.entry.startTime));
    _organizeClasses();
    _smartBanners = _generateSmartBanners();
  }
  
  void _organizeClasses() {
    _currentClass = _todaysClasses.where((c) => c.status == ClassStatus.now).firstOrNull;
    
    // Upcoming classes (ascending by start time)
    _upcomingClasses = _todaysClasses.where((c) => c.status == ClassStatus.upcoming).toList()
      ..sort((a, b) => _compareTimeOfDay(a.entry.startTime, b.entry.startTime));
    
    // Completed classes (descending by end time)
    _completedClasses = _todaysClasses.where((c) => c.status == ClassStatus.completed).toList()
      ..sort((a, b) => _compareTimeOfDay(b.entry.endTime, a.entry.endTime));
    
    // Hero class: Current class if exists, else next upcoming class, else last completed
    if (_currentClass != null) {
      _heroClass = _currentClass;
    } else if (_upcomingClasses.isNotEmpty) {
      _heroClass = _upcomingClasses.first;
    } else if (_completedClasses.isNotEmpty) {
      _heroClass = _completedClasses.first;
    } else {
      _heroClass = null;
    }
    
    // Update action card visibility
    if (_currentClass != null) {
      _actionCardController.forward();
      _heroProgressController.forward();
    } else {
      _actionCardController.reverse();
      _heroProgressController.reverse();
    }
  }

  ClassStatus _getClassStatus(TimetableEntry entry, TimeOfDay now) {
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = entry.startTime.hour * 60 + entry.startTime.minute;
    final endMinutes = entry.endTime.hour * 60 + entry.endTime.minute;

    if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
      return ClassStatus.now;
    } else if (currentMinutes < startMinutes) {
      return ClassStatus.upcoming;
    } else {
      return ClassStatus.completed;
    }
  }

  Duration? _getTimeRemaining(TimetableEntry entry, TimeOfDay now) {
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = entry.startTime.hour * 60 + entry.startTime.minute;
    final endMinutes = entry.endTime.hour * 60 + entry.endTime.minute;

    if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
      return Duration(minutes: endMinutes - currentMinutes);
    } else if (currentMinutes < startMinutes) {
      return Duration(minutes: startMinutes - currentMinutes);
    }
    return null;
  }

  String _getStatusText(TimetableEntry entry, TimeOfDay now, Duration? timeRemaining) {
    final status = _getClassStatus(entry, now);
    
    switch (status) {
      case ClassStatus.now:
        if (timeRemaining != null) {
          final hours = timeRemaining.inHours;
          final minutes = timeRemaining.inMinutes % 60;
          if (hours > 0) {
            return 'Ends in ${hours}h ${minutes}m';
          } else {
            return 'Ends in ${minutes}m';
          }
        }
        return 'Now';
      case ClassStatus.upcoming:
        if (timeRemaining != null) {
          final hours = timeRemaining.inHours;
          final minutes = timeRemaining.inMinutes % 60;
          if (hours > 0) {
            return 'Starts in ${hours}h ${minutes}m';
          } else {
            return 'Starts in ${minutes}m';
          }
        }
        return 'Upcoming';
      case ClassStatus.completed:
        return 'Completed';
    }
  }

  List<SmartBanner> _generateSmartBanners() {
    // Return empty list - no demo banners needed
    return [];
  }

  void _updateClassStatuses() {
    final now = TimeOfDay.now();
    bool hasChanges = false;
    
    for (int i = 0; i < _todaysClasses.length; i++) {
      final entry = _todaysClasses[i].entry;
      final oldStatus = _todaysClasses[i].status;
      final newStatus = _getClassStatus(entry, now);
      final newTimeRemaining = _getTimeRemaining(entry, now);
      final newStatusText = _getStatusText(entry, now, newTimeRemaining);
      
      if (oldStatus != newStatus ||
          _todaysClasses[i].timeRemaining != newTimeRemaining) {
        _todaysClasses[i] = ClassSession(
          entry: entry,
          status: newStatus,
          timeRemaining: newTimeRemaining,
          statusText: newStatusText,
        );
        hasChanges = true;
        
        // Handle status transitions for smooth animations
        if (oldStatus == ClassStatus.upcoming && newStatus == ClassStatus.now) {
          // Class just started - show action card
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) _actionCardController.forward();
          });
        } else if (oldStatus == ClassStatus.now && newStatus == ClassStatus.completed) {
          // Class just ended - hide action card
          _actionCardController.reverse();
        }
      }
    }
    
    if (hasChanges && mounted) {
      setState(() {
        _organizeClasses();
        _updateSmartBanners();
      });
    }
  }

  int _compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
    final aMinutes = a.hour * 60 + a.minute;
    final bMinutes = b.hour * 60 + b.minute;
    return aMinutes.compareTo(bMinutes);
  }

  String _formatTimeRange(TimeOfDay start, TimeOfDay end) {
    return '${_formatTime(start)}–${_formatTime(end)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return DateFormat('EEE, d MMM yyyy').format(now);
  }

  Color _getCourseTypeColor(String courseType) {
    switch (courseType.toLowerCase()) {
      case 'theory':
        return Colors.blue;
      case 'lab':
        return Colors.purple;
      case 'project':
        return Colors.green;
      default:
        return AppColors.textSecondary;
    }
  }

  bool _canApplyLeave(ClassSession classSession) {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = classSession.entry.startTime.hour * 60 + classSession.entry.startTime.minute;
    
    return startMinutes > currentMinutes + 15;
  }

  bool _canSwapClass(ClassSession classSession) {
    return _canApplyLeave(classSession);
  }

  double _calculateProgress(ClassSession classSession) {
    if (classSession.status != ClassStatus.now) return 0.0;
    
    final now = DateTime.now();
    final start = classSession.entry.startTime;
    final end = classSession.entry.endTime;
    
    final startToday = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endToday = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    
    final totalDuration = endToday.difference(startToday).inMinutes;
    final elapsed = now.difference(startToday).inMinutes;
    
    return elapsed / totalDuration;
  }

  void _updateSmartBanners() {
    // Keep existing banners for demo
  }

  void _dismissBanner(String bannerId) {
    setState(() {
      _smartBanners.removeWhere((banner) => banner.id == bannerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      extendBody: true, // Allow body to extend behind navigation
      body: Stack(
        children: [
          // Main content with padding to avoid pill overlap
          SafeArea(
            child: Column(
              children: [
                // Offline banner
                if (_isOffline) _buildOfflineBanner(),
                
                // Smart Banners
                if (_smartBanners.isNotEmpty) _buildSmartBanners(),
              
                // Main Content with bottom padding for glass pill
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: glassPillBottomPadding),
                    child: _isLoading 
                      ? _buildLoadingState()
                      : _error != null
                        ? _buildErrorState()
                        : _todaysClasses.isEmpty
                          ? _buildEmptyState()
                          : _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Now Class Action Card
          if (_currentClass != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: glassPillBottomPadding + 8, // Position above glass pill
              child: AnimatedBuilder(
                animation: _actionCardAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - _actionCardAnimation.value) * 100),
                    child: Opacity(
                      opacity: _actionCardAnimation.value,
                      child: _buildNowClassActionCard(),
                    ),
                  );
                },
              ),
            ),
          
          // Glass Pill Navigation Overlay
          GlassPillNav(
            selectedIndex: selectedNavIndex,
            onItemTapped: handleNavTap,
            items: GlassPillNavMixin.navItems,
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.accent.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'You\'re offline — showing cached schedule',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartBanners() {
    return Column(
      children: _smartBanners.map((banner) => _buildSmartBanner(banner)).toList(),
    );
  }

  Widget _buildSmartBanner(SmartBanner banner) {
    Color iconColor;
    
    switch (banner.urgency) {
      case BannerUrgency.critical:
        iconColor = Colors.red;
        break;
      case BannerUrgency.high:
        iconColor = Colors.orange;
        break;
      case BannerUrgency.medium:
        iconColor = AppColors.primary;
        break;
      case BannerUrgency.low:
        iconColor = AppColors.textSecondary;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LiquidGlass(
        borderRadius: 12,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              banner.icon,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                banner.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: banner.urgency == BannerUrgency.critical 
                    ? FontWeight.w700 
                    : FontWeight.w500,
                ),
              ),
            ),
            if (banner.action.isNotEmpty) ...[
              TextButton(
                onPressed: banner.onTap,
                child: Text(
                  banner.action,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            IconButton(
              onPressed: () => _dismissBanner(banner.id),
              icon: Icon(
                Icons.close,
                size: 18,
                color: AppColors.textSecondary,
              ),
              tooltip: 'Dismiss',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowClassActionCard() {
    if (_currentClass == null) return const SizedBox.shrink();
    
    return LiquidGlass(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_currentClass!.entry.course.code} • ${_formatTimeRange(_currentClass!.entry.startTime, _currentClass!.entry.endTime)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_currentClass!.entry.room}, ${_currentClass!.entry.building}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _openClassDetails(_currentClass!),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _buildHeader(),
        ),
        
        // Hero Class Card
        if (_heroClass != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildHeroClassCard(),
            ),
          ),
        
        // Today's Classes List
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildClassesList(),
          ),
        ),
        
        // Bottom spacing for action card
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Today · ${_getTodayDateString()}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Round Logo Profile Button
              GestureDetector(
                onTap: _openProfile,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/brand/sret_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroClassCard() {
    if (_heroClass == null) return const SizedBox.shrink();
    
    final heroClass = _heroClass!;
    final isNow = heroClass.status == ClassStatus.now;
    final progress = isNow ? _calculateProgress(heroClass) : 0.0;
    final canApplyLeave = _canApplyLeave(heroClass);
    final canSwapClass = _canSwapClass(heroClass);
    
    return LiquidGlass(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course code + name (bold)
          Text(
            '${heroClass.entry.course.code} • ${heroClass.entry.course.name}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Section • Semester (lighter)
          Text(
            '${heroClass.entry.section} • ${heroClass.entry.semester} Semester',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Row: time range + location
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimeRange(heroClass.entry.startTime, heroClass.entry.endTime),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.location_on,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${heroClass.entry.room}, ${heroClass.entry.building}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Chips: Course type + optional flags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAccessibleCourseTypeChip(heroClass.entry.course.courseType),
              if (heroClass.entry.isGuest) _buildAccessibleFlagChip('Guest', Icons.person, Colors.blue),
              if (heroClass.entry.isOnline) _buildAccessibleFlagChip('Online', Icons.videocam, Colors.green),
              if (heroClass.entry.isSpecial) _buildAccessibleFlagChip('Special', Icons.star, Colors.orange),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Status with progress bar
          if (heroClass.timeRemaining != null) ...[
            Row(
              children: [
                Icon(
                  isNow ? Icons.timelapse : Icons.access_time,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  heroClass.statusText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            
            // Thin gold progress bar when in-progress
            if (isNow && progress > 0) ...[
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _heroProgressAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress * _heroProgressAnimation.value,
                      backgroundColor: Colors.amber.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                      minHeight: 3,
                    ),
                  );
                },
              ),
            ],
            
            const SizedBox(height: 20),
          ],
          
          // Primary Actions (NO 3-dot menu on Hero)
          Row(
            children: [
              Expanded(
                child: _buildHeroActionButton(
                  'Apply Leave',
                  Icons.event_busy,
                  canApplyLeave ? () => _applyLeave(heroClass) : null,
                  tooltip: canApplyLeave ? 'Apply for leave for this class' : _getLeaveDisabledReason(heroClass),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeroActionButton(
                  'Swap Class',
                  Icons.sync_alt,
                  canSwapClass ? () => _swapClass(heroClass) : null,
                  tooltip: canSwapClass ? 'Request to swap this class' : _getSwapDisabledReason(heroClass),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Secondary icons: Open in Week, Remind me
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeroSecondaryAction(
                Icons.calendar_view_week,
                'Open in Week',
                () => _openInWeek(heroClass),
              ),
              const SizedBox(width: 32),
              _buildHeroSecondaryAction(
                Icons.notifications_none,
                'Remind me',
                () => _setReminder(heroClass),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibleCourseTypeChip(String courseType) {
    Color chipColor = _getCourseTypeColor(courseType);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        courseType,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAccessibleFlagChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroActionButton(
    String label,
    IconData icon,
    VoidCallback? onPressed,
    {String? tooltip}
  ) {
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
        foregroundColor: Colors.white,
        elevation: onPressed != null ? 2 : 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    return tooltip != null
        ? Tooltip(
            message: tooltip,
            child: button,
          )
        : button;
  }

  Widget _buildHeroSecondaryAction(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLeaveDisabledReason(ClassSession classSession) {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = classSession.entry.startTime.hour * 60 + classSession.entry.startTime.minute;
    
    if (startMinutes <= currentMinutes) {
      return 'Leave cannot be applied for ongoing or past classes';
    } else if (startMinutes - currentMinutes < 15) {
      return 'Leave requests require at least 15 minutes notice';
    }
    return 'Leave application unavailable';
  }

  String _getSwapDisabledReason(ClassSession classSession) {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = classSession.entry.startTime.hour * 60 + classSession.entry.startTime.minute;
    
    if (startMinutes <= currentMinutes) {
      return 'Class swaps not available for ongoing or past classes';
    } else if (startMinutes - currentMinutes < 15) {
      return 'Class swaps require at least 15 minutes notice';
    }
    return 'Class swap unavailable';
  }

  void _openInWeek(ClassSession classSession) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${classSession.entry.course.code} in weekly view...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildClassesList() {
    // Filter out the current class (shown in hero card)
    final displayClasses = _todaysClasses.where((c) => c != _currentClass).toList();
    
    if (displayClasses.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        
        // Upcoming Classes Section
        if (_upcomingClasses.where((c) => c != _currentClass).isNotEmpty) ...[
          _buildSectionHeader('Upcoming'),
          const SizedBox(height: 12),
          ..._upcomingClasses.where((c) => c != _currentClass).map((classSession) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildUpcomingClassCard(classSession),
            ),
          ),
          const SizedBox(height: 24),
        ],
        
        // Completed Classes Section
        if (_completedClasses.isNotEmpty) ...[
          _buildSectionHeader('Completed'),
          const SizedBox(height: 12),
          ..._completedClasses.map((classSession) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCompletedClassCard(classSession),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );
  }

  Widget _buildUpcomingClassCard(ClassSession classSession) {
    final canApplyLeave = _canApplyLeave(classSession);
    final canSwapClass = _canSwapClass(classSession);
    
    return LiquidGlass(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line 1: Code • Name
                Text(
                  '${classSession.entry.course.code} • ${classSession.entry.course.name}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                
                // Line 2: Time — Room, trailing Course-type chip
                Row(
                  children: [
                    Text(
                      '${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)} — ${classSession.entry.room}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCourseTypeChip(classSession.entry.course.courseType),
                  ],
                ),
              ],
            ),
          ),
          
          // Status pill and 3-dot menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusChip(classSession),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onSelected: (value) => _handleClassMenuAction(value, classSession),
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'apply_leave',
                    enabled: canApplyLeave,
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 18,
                          color: canApplyLeave ? AppColors.primary : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Apply Leave',
                              style: TextStyle(
                                color: canApplyLeave ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (!canApplyLeave)
                              Text(
                                _getLeaveDisabledReason(classSession),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'swap_class',
                    enabled: canSwapClass,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sync_alt,
                          size: 18,
                          color: canSwapClass ? AppColors.primary : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Swap Class',
                              style: TextStyle(
                                color: canSwapClass ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (!canSwapClass)
                              Text(
                                _getSwapDisabledReason(classSession),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Details',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedClassCard(ClassSession classSession) {
    return LiquidGlass(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _openClassDetails(classSession),
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: 0.7,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${classSession.entry.course.code} • ${classSession.entry.course.name}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)} — ${classSession.entry.room}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildCourseTypeChip(classSession.entry.course.courseType),
                      ],
                    ),
                  ],
                ),
              ),
              _buildStatusChip(classSession),
            ],
          ),
        ),
      ),
    );
  }

  void _handleClassMenuAction(String action, ClassSession classSession) {
    switch (action) {
      case 'apply_leave':
        _applyLeave(classSession);
        break;
      case 'swap_class':
        _swapClass(classSession);
        break;
      case 'details':
        _openClassDetails(classSession);
        break;
    }
  }

  Widget _buildStatusChip(ClassSession classSession) {
    Color chipColor;
    String text;
    
    switch (classSession.status) {
      case ClassStatus.now:
        chipColor = Colors.green;
        text = 'Now';
        break;
      case ClassStatus.upcoming:
        chipColor = Colors.orange;
        text = classSession.statusText;
        break;
      case ClassStatus.completed:
        chipColor = AppColors.textSecondary;
        text = 'Completed';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildCourseTypeChip(String courseType) {
    final chipColor = _getCourseTypeColor(courseType);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        courseType,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadTodayData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No classes scheduled today',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _openTimetable,
            icon: const Icon(Icons.calendar_view_week),
            label: const Text('View Week'),
          ),
        ],
      ),
    );
  }

  void _openTimetable() {
    // Navigate to timetable/week view
    // For now, show a more informative message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Timetable feature coming soon...'),
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _openProfile() {
    // Navigate to profile page using glass pill navigation
    handleNavTap(3); // Profile is at index 3
  }

  void _applyLeave(ClassSession classSession) {
    // Show a proper dialog for leave application
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Leave'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${classSession.entry.course.code}'),
            Text('Time: ${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)}'),
            Text('Date: ${_getTodayDateString()}'),
            const SizedBox(height: 16),
            const Text('This will submit a leave request to the department.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Leave request submitted for ${classSession.entry.course.code}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }

  void _swapClass(ClassSession classSession) {
    // Show a proper dialog for class swap
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Class Swap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${classSession.entry.course.code}'),
            Text('Current Time: ${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)}'),
            Text('Date: ${_getTodayDateString()}'),
            const SizedBox(height: 16),
            const Text('This will request to swap this class with another available slot.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Swap request submitted for ${classSession.entry.course.code}'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }

  void _openClassDetails(ClassSession classSession) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Class Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${classSession.entry.course.code} - ${classSession.entry.course.name}'),
            Text('Faculty: ${classSession.entry.course.faculty}'),
            Text('Credits: ${classSession.entry.course.credits}'),
            Text('Section: ${classSession.entry.section}'),
            Text('Room: ${classSession.entry.room}, ${classSession.entry.building}'),
            Text('Time: ${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)}'),
            if (classSession.entry.notes?.isNotEmpty == true)
              Text('Notes: ${classSession.entry.notes}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _setReminder(ClassSession classSession) {
    // Show reminder options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${classSession.entry.course.code}'),
            Text('Time: ${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)}'),
            const SizedBox(height: 16),
            const Text('Choose reminder time:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildReminderOption('5 min before', 5, classSession),
                _buildReminderOption('10 min before', 10, classSession),
                _buildReminderOption('15 min before', 15, classSession),
              ],
            ),
            if (_userPreferences.isDndEnabled) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.do_not_disturb, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Do Not Disturb is enabled. Reminder may not notify.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange, 
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderOption(String label, int minutes, ClassSession classSession) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder set for $minutes minutes before ${classSession.entry.course.code}'),
            backgroundColor: Colors.green,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label, 
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
      ),
    );
  }
}
