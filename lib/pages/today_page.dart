import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass.dart';

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

class _TodayPageState extends State<TodayPage> {
  Timer? _updateTimer;
  List<ClassSession> _todaysClasses = [];
  ClassSession? _heroClass;
  bool _isLoading = true;
  String? _error;
  bool _isOffline = false;
  bool _isOnline = true;
  List<SmartBanner> _smartBanners = [];
  DateTime _lastFetchTime = DateTime.now();
  final UserPreferences _userPreferences = UserPreferences();
  
  // Cache duration for smooth UX
  static const Duration _cacheTimeout = Duration(minutes: 3);
  
  // Device timezone check
  bool get _isTimezoneMatch => DateTime.now().timeZoneName == _userPreferences.timezone;

  @override
  void initState() {
    super.initState();
    _loadTodayData();
    _startUpdateTimer();
    
    // Listen to app lifecycle for refresh on resume
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(_onAppResumed));
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
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
            _updateSmartBanners(); // Initialize smart banners
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
    _heroClass = _findHeroClass();
    _smartBanners = _generateSmartBanners();
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

  ClassSession? _findHeroClass() {
    final currentClass = _todaysClasses.where((c) => c.status == ClassStatus.now).firstOrNull;
    if (currentClass != null) return currentClass;

    final upcomingClasses = _todaysClasses.where((c) => c.status == ClassStatus.upcoming).toList();
    if (upcomingClasses.isNotEmpty) return upcomingClasses.first;

    final completedClasses = _todaysClasses.where((c) => c.status == ClassStatus.completed).toList();
    if (completedClasses.isNotEmpty) return completedClasses.last;

    return null;
  }

  List<SmartBanner> _generateSmartBanners() {
    List<SmartBanner> banners = [];
    
    // Only show if user has opted in and not in DND (unless urgent)
    if (_userPreferences.substitutionOptIn && !_userPreferences.isDndEnabled) {
      banners.add(SmartBanner(
        id: '1',
        type: SmartBannerType.substitution,
        title: 'Substitution offer today at 2:00 PM',
        action: 'View',
        icon: Icons.swap_horiz,
        onTap: () => _handleBannerTap(SmartBannerType.substitution),
      ));
    }
    
    // Leave request banner (can bypass DND if urgent)
    banners.add(SmartBanner(
      id: '2',
      type: SmartBannerType.leaveRequest,
      title: 'Leave request pending for 11:00–11:50',
      action: 'View',
      icon: Icons.event_busy,
      urgency: BannerUrgency.high,
      onTap: () => _handleBannerTap(SmartBannerType.leaveRequest),
    ));
    
    if (!_userPreferences.isDndEnabled) {
      banners.add(SmartBanner(
        id: '3',
        type: SmartBannerType.classSwap,
        title: 'Swap with Dr. Rao awaiting response',
        action: 'View',
        icon: Icons.sync_alt,
        onTap: () => _handleBannerTap(SmartBannerType.classSwap),
      ));
    }
    
    return banners;
  }

  void _handleBannerTap(SmartBannerType type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${type.name} details...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _updateClassStatuses() {
    final now = TimeOfDay.now();
    bool hasChanges = false;
    
    for (int i = 0; i < _todaysClasses.length; i++) {
      final entry = _todaysClasses[i].entry;
      final newStatus = _getClassStatus(entry, now);
      final newTimeRemaining = _getTimeRemaining(entry, now);
      final newStatusText = _getStatusText(entry, now, newTimeRemaining);
      
      if (_todaysClasses[i].status != newStatus ||
          _todaysClasses[i].timeRemaining != newTimeRemaining) {
        _todaysClasses[i] = ClassSession(
          entry: entry,
          status: newStatus,
          timeRemaining: newTimeRemaining,
          statusText: newStatusText,
        );
        hasChanges = true;
      }
    }
    
    if (hasChanges && mounted) {
      setState(() {
        _heroClass = _findHeroClass();
        _updateSmartBanners(); // Update banners with new class statuses
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

  String _getFormattedTimeRemaining(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  bool _canApplyLeave(ClassSession classSession) {
    // Cannot apply leave for past classes or classes starting in less than 15 minutes
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = classSession.entry.startTime.hour * 60 + classSession.entry.startTime.minute;
    
    return startMinutes > currentMinutes + 15;
  }

  bool _canSwapClass(ClassSession classSession) {
    // Similar to leave application rules
    return _canApplyLeave(classSession);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Semantics(
        label: 'Today\'s Class Schedule',
        child: SafeArea(
          child: Column(
            children: [
              // Offline banner
              if (_isOffline)
                Semantics(
                  liveRegion: true,
                  label: 'You are offline, showing cached schedule',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.accent.withOpacity(0.1),
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
                  ),
                ),
              
              // Smart Banners
              if (_smartBanners.isNotEmpty)
                Semantics(
                  label: 'Smart notifications',
                  child: Column(
                    children: _smartBanners.map((banner) => _buildSmartBanner(banner)).toList(),
                  ),
                ),
            
              // Main Content
              Expanded(
                child: Semantics(
                  label: 'Class schedule content',
                  child: _isLoading 
                    ? _buildLoadingState()
                    : _error != null
                      ? _buildErrorState()
                      : _todaysClasses.isEmpty
                        ? _buildEmptyState()
                        : _buildMainContent(),
                ),
              ),
              
              // Bottom Navigation
              Semantics(
                label: 'Navigation menu',
                child: _buildBottomNavigation(Theme.of(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartBanner(SmartBanner banner) {
    Color borderColor;
    Color iconColor;
    
    switch (banner.urgency) {
      case BannerUrgency.critical:
        borderColor = Colors.red;
        iconColor = Colors.red;
        break;
      case BannerUrgency.high:
        borderColor = Colors.orange;
        iconColor = Colors.orange;
        break;
      case BannerUrgency.medium:
        borderColor = AppColors.primary;
        iconColor = AppColors.primary;
        break;
      case BannerUrgency.low:
        borderColor = AppColors.textSecondary;
        iconColor = AppColors.textSecondary;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LiquidGlass(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
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
        ),
      ),
    );
  }

  void _dismissBanner(String bannerId) {
    setState(() {
      _smartBanners.removeWhere((banner) => banner.id == bannerId);
    });
  }

  void _updateSmartBanners() {
    _smartBanners.clear();
    
    // Don't show banners if DND is enabled and user opted out
    if (_userPreferences.isDndEnabled && !_userPreferences.substitutionOptIn) {
      return;
    }
    
    final now = DateTime.now();
    final upcomingClasses = _todaysClasses.where((c) => 
      c.status == ClassStatus.upcoming && 
      c.timeRemaining != null && 
      c.timeRemaining!.inMinutes <= 120 // Next 2 hours
    ).toList();
    
    // Critical: Class starting very soon (less than 10 minutes)
    final urgentClasses = upcomingClasses.where((c) => 
      c.timeRemaining!.inMinutes <= 10
    ).toList();
    
    if (urgentClasses.isNotEmpty) {
      final urgentClass = urgentClasses.first;
      _smartBanners.add(SmartBanner(
        id: 'urgent_class_${urgentClass.entry.course.code}',
        type: SmartBannerType.urgent,
        title: '🚨 ${urgentClass.entry.course.code} starts in ${urgentClass.timeRemaining!.inMinutes} min!',
        action: 'Get Ready',
        icon: Icons.warning_amber,
        urgency: BannerUrgency.critical,
        onTap: () => _prepareForClass(urgentClass),
      ));
    }
    
    // High: Location change needed
    final locationChangeClasses = upcomingClasses.where((c) => 
      c.timeRemaining!.inMinutes <= 30 && 
      _needsLocationChange(c)
    ).toList();
    
    if (locationChangeClasses.isNotEmpty && urgentClasses.isEmpty) {
      final locationClass = locationChangeClasses.first;
      _smartBanners.add(SmartBanner(
        id: 'location_change_${locationClass.entry.course.code}',
        type: SmartBannerType.location,
        title: 'Time to head to ${locationClass.entry.building} for ${locationClass.entry.course.code}',
        action: 'Directions',
        icon: Icons.directions_walk,
        urgency: BannerUrgency.high,
        onTap: () => _getDirections(locationClass),
      ));
    }
    
    // Medium: Preparation reminders
    final preparationClasses = upcomingClasses.where((c) => 
      c.timeRemaining!.inMinutes <= 60 && 
      c.timeRemaining!.inMinutes > 30 &&
      c.entry.course.courseType == 'Lab'
    ).toList();
    
    if (preparationClasses.isNotEmpty && 
        urgentClasses.isEmpty && 
        locationChangeClasses.isEmpty) {
      final prepClass = preparationClasses.first;
      _smartBanners.add(SmartBanner(
        id: 'prep_${prepClass.entry.course.code}',
        type: SmartBannerType.preparation,
        title: 'Lab session coming up: ${prepClass.entry.course.code}',
        action: 'Prepare',
        icon: Icons.science,
        urgency: BannerUrgency.medium,
        onTap: () => _prepareForLab(prepClass),
      ));
    }
    
    // Low: General reminders
    final reminderClasses = upcomingClasses.where((c) => 
      c.timeRemaining!.inMinutes <= 90 && 
      c.timeRemaining!.inMinutes > 60
    ).toList();
    
    if (reminderClasses.isNotEmpty && 
        _smartBanners.length < 2) { // Limit total banners
      final reminderClass = reminderClasses.first;
      _smartBanners.add(SmartBanner(
        id: 'reminder_${reminderClass.entry.course.code}',
        type: SmartBannerType.reminder,
        title: 'Next class: ${reminderClass.entry.course.code} in ${(reminderClass.timeRemaining!.inMinutes / 60).round()}h',
        action: 'View',
        icon: Icons.schedule,
        urgency: BannerUrgency.low,
        onTap: () => _openClassDetails(reminderClass),
      ));
    }
    
    // Special banners for specific conditions
    _addSpecialBanners(now);
    
    // Sort banners by urgency
    _smartBanners.sort((a, b) => b.urgency.index.compareTo(a.urgency.index));
    
    // Limit to maximum 3 banners to avoid overwhelming UI
    if (_smartBanners.length > 3) {
      _smartBanners = _smartBanners.take(3).toList();
    }
  }

  void _addSpecialBanners(DateTime now) {
    // Free period banner
    final currentTime = TimeOfDay.now();
    final hasCurrentClass = _todaysClasses.any((c) => c.status == ClassStatus.now);
    final nextClass = _todaysClasses.where((c) => c.status == ClassStatus.upcoming).firstOrNull;
    
    if (!hasCurrentClass && nextClass != null && nextClass.timeRemaining != null) {
      final freeTimeMinutes = nextClass.timeRemaining!.inMinutes;
      if (freeTimeMinutes >= 30 && freeTimeMinutes <= 120) {
        _smartBanners.add(SmartBanner(
          id: 'free_period',
          type: SmartBannerType.general,
          title: 'Free for ${(freeTimeMinutes / 60).toStringAsFixed(1)}h until ${nextClass.entry.course.code}',
          action: 'Relax',
          icon: Icons.free_breakfast,
          urgency: BannerUrgency.low,
          onTap: () => _showFreeTimeSuggestions(),
        ));
      }
    }
    
    // Weekend reminder
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      if (_todaysClasses.isEmpty) {
        _smartBanners.add(SmartBanner(
          id: 'weekend_free',
          type: SmartBannerType.general,
          title: 'No classes today - enjoy your weekend! 🎉',
          action: 'OK',
          icon: Icons.celebration,
          urgency: BannerUrgency.low,
          onTap: () => _dismissBanner('weekend_free'),
        ));
      }
    }
    
    // Offline mode banner
    if (!_isOnline) {
      _smartBanners.add(SmartBanner(
        id: 'offline_mode',
        type: SmartBannerType.urgent,
        title: 'You\'re offline - showing cached schedule',
        action: 'Retry',
        icon: Icons.cloud_off,
        urgency: BannerUrgency.medium,
        onTap: () => _retryConnection(),
      ));
    }
  }

  bool _needsLocationChange(ClassSession classSession) {
    // This would typically check against user's current location
    // For demo purposes, assume location change needed for different buildings
    final currentLocation = 'Main Building'; // This would come from GPS/last known location
    return classSession.entry.building != currentLocation;
  }

  void _prepareForClass(ClassSession classSession) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Get Ready for Class'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class: ${classSession.entry.course.code}'),
            Text('Location: ${classSession.entry.room}, ${classSession.entry.building}'),
            Text('Time: ${_formatTimeRange(classSession.entry.startTime, classSession.entry.endTime)}'),
            const SizedBox(height: 16),
            const Text('Quick actions:'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _getDirections(classSession);
                    },
                    icon: Icon(Icons.directions),
                    label: Text('Directions'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _setReminder(classSession);
                    },
                    icon: Icon(Icons.notifications),
                    label: Text('Remind'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _getDirections(ClassSession classSession) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Getting directions to ${classSession.entry.building}...'),
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'Open Maps',
          textColor: Colors.white,
          onPressed: () {
            // Would integrate with maps app
          },
        ),
      ),
    );
  }

  void _prepareForLab(ClassSession classSession) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lab Preparation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lab: ${classSession.entry.course.code}'),
            Text('Room: ${classSession.entry.room}'),
            const SizedBox(height: 16),
            const Text('Reminders:'),
            const Text('• Bring lab manual'),
            const Text('• Complete pre-lab assignments'),
            const Text('• Bring safety equipment'),
            const Text('• Review lab procedures'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showFreeTimeSuggestions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Free Time Suggestions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You have some free time! Consider:'),
            const SizedBox(height: 12),
            _buildSuggestionItem(Icons.book, 'Review upcoming lectures'),
            _buildSuggestionItem(Icons.assignment, 'Work on assignments'),
            _buildSuggestionItem(Icons.restaurant, 'Get a snack'),
            _buildSuggestionItem(Icons.group, 'Meet with classmates'),
            _buildSuggestionItem(Icons.self_improvement, 'Take a break'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Thanks'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  void _retryConnection() {
    // Simulate connection retry
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOnline = true; // Simulate successful reconnection
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection restored!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  Widget _buildLoadingState() {
    return Semantics(
      label: 'Loading schedule',
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header skeleton
            Semantics(
              label: 'Loading header',
              child: Container(
                height: 24,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Hero card skeleton
            Semantics(
              label: 'Loading main class information',
              child: LiquidGlass.card(
                height: 200,
                child: Center(
                  child: Semantics(
                    label: 'Loading progress indicator',
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      semanticsLabel: 'Loading your schedule',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // List skeletons
            Semantics(
              label: 'Loading class list',
              child: Column(
                children: List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Semantics(
                    label: 'Loading class ${index + 1}',
                    child: LiquidGlass(
                      borderRadius: 16,
                      height: 80,
                      child: Container(),
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Semantics(
      label: 'Error loading schedule',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Error icon',
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                _error!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Retry loading schedule',
              child: LiquidGlass.pill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _loadTodayData,
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Semantics(
      label: 'No classes today',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Calendar icon',
              child: Icon(
                Icons.today_outlined,
                size: 80,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              header: true,
              child: Text(
                'No classes scheduled today',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your free day!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Semantics(
              button: true,
              label: 'View full timetable',
              child: LiquidGlass.pill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openTimetable(),
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_view_week,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'View Week',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: _buildHeader(),
          ),
        ),
        if (_heroClass != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _buildHeroCard(_heroClass!),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: _buildClassesList(Theme.of(context)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Semantics(
      header: true,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today · ${_getTodayDateString()}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!_isTimezoneMatch)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Times shown in ${_userPreferences.timezone}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          LiquidGlass.pill(
            height: 40,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _openTimetable,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_view_week,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'View Week',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(ClassSession heroClass) {
    final isNow = heroClass.status == ClassStatus.now;
    final progress = isNow ? _calculateProgress(heroClass) : 0.0;
    final canApplyLeave = _canApplyLeave(heroClass);
    final canSwapClass = _canSwapClass(heroClass);
    
    return LiquidGlass.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with course info and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${heroClass.entry.course.code} • ${heroClass.entry.course.name}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${heroClass.entry.section} • ${heroClass.entry.semester} Semester',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(heroClass, Theme.of(context)),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Time and location details
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimeRange(heroClass.entry.startTime, heroClass.entry.endTime),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${heroClass.entry.room}, ${heroClass.entry.building}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Course type and special flags
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildCourseTypeChip(heroClass.entry.course.courseType),
              if (heroClass.entry.isGuest) _buildSpecialChip('Guest', Icons.person),
              if (heroClass.entry.isOnline) _buildSpecialChip('Online', Icons.videocam),
              if (heroClass.entry.isSpecial) _buildSpecialChip('Special', Icons.star),
            ],
          ),
          
          // Time remaining and progress
          if (heroClass.timeRemaining != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isNow ? Icons.timelapse : Icons.access_time,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  heroClass.statusText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          
          // Progress bar for current class
          if (isNow && progress > 0) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4,
                semanticsLabel: 'Class progress: ${(progress * 100).round()}%',
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Primary action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Apply Leave',
                  Icons.event_busy,
                  canApplyLeave ? () => _applyLeave(heroClass) : null,
                  isPrimary: true,
                  tooltip: canApplyLeave ? 'Apply for leave' : 'Cannot apply leave for this class',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Swap Class',
                  Icons.sync_alt,
                  canSwapClass ? () => _swapClass(heroClass) : null,
                  isPrimary: false,
                  tooltip: canSwapClass ? 'Request class swap' : 'Cannot swap this class',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Secondary action icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSecondaryAction(
                Icons.info_outline, 
                'Details', 
                () => _openClassDetails(heroClass),
                'View class details',
              ),
              _buildSecondaryAction(
                Icons.notifications_none, 
                'Remind', 
                () => _setReminder(heroClass),
                'Set reminder',
              ),
              _buildSecondaryAction(
                Icons.calendar_view_week, 
                'Timetable', 
                () => _openTimetable(),
                'Open in timetable',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ClassSession classSession, ThemeData theme) {
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
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: chipColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCourseTypeChip(String courseType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
      ),
      child: Text(
        courseType,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildSpecialChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.accent,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback? onPressed,
    {required bool isPrimary, String? tooltip}
  ) {
    final button = isPrimary
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 16),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: onPressed != null ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 16),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              foregroundColor: onPressed != null ? AppColors.primary : AppColors.textSecondary,
              side: BorderSide(
                color: onPressed != null ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildSecondaryAction(IconData icon, String label, VoidCallback onPressed, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Semantics(
          button: true,
          label: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassesList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Classes',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ..._todaysClasses.map((classSession) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildClassRow(classSession, theme),
        )),
      ],
    );
  }

  Widget _buildClassRow(ClassSession classSession, ThemeData theme) {
    return LiquidGlass(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${classSession.entry.course.code} • ${classSession.entry.course.name}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeRange(classSession.entry.startTime, classSession.entry.endTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${classSession.entry.room}, ${classSession.entry.building}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
            Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusChip(classSession, theme),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCourseTypeColor(classSession.entry.course.courseType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  classSession.entry.course.courseType,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getCourseTypeColor(classSession.entry.course.courseType),
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: LiquidGlass.pill(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.today, 'Today', true, theme),
            _buildNavItem(Icons.calendar_view_week, 'Week', false, theme),
            _buildNavItem(Icons.schedule, 'Schedule', false, theme),
            _buildNavItem(Icons.inbox, 'Inbox', false, theme),
            _buildNavItem(Icons.person, 'Profile', false, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, ThemeData theme) {
    return GestureDetector(
      onTap: () => _handleNavTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive ? BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTimetable() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening timetable...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _applyLeave(ClassSession classSession) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apply leave for ${classSession.entry.course.code}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _swapClass(ClassSession classSession) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Swap class for ${classSession.entry.course.code}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  double _calculateProgress(ClassSession classSession) {
    if (classSession.status != ClassStatus.now) return 0.0;
    
    final now = DateTime.now();
    final start = classSession.entry.startTime;
    final end = classSession.entry.endTime;
    
    // Create DateTime objects for today with class times
    final startToday = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endToday = DateTime(now.year, now.month, now.day, end.hour, end.minute);
    
    final totalDuration = endToday.difference(startToday).inMinutes;
    final elapsed = now.difference(startToday).inMinutes;
    
    return elapsed / totalDuration;
  }

  void _openClassDetails(ClassSession classSession) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Class Details'),
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
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _setReminder(ClassSession classSession) {
    if (!_userPreferences.isDndEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${classSession.entry.course.code}'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Do Not Disturb is enabled. Reminder not set.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handleNavTap(String section) {
    if (section == 'Today') return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $section...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
