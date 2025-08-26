import 'dart:async';
import 'dart:math';
import 'models.dart';

/// Repository for managing schedule data
class ScheduleRepo {
  final Random _random = Random();

  /// Mock subjects for Computer Science department
  static const _subjects = [
    {'name': 'Data Structures & Algorithms', 'code': 'CSE301'},
    {'name': 'Operating Systems', 'code': 'CSE302'},
    {'name': 'Computer Networks', 'code': 'CSE303'},
    {'name': 'Database Management Systems', 'code': 'CSE304'},
    {'name': 'Theory of Computation', 'code': 'CSE305'},
    {'name': 'Software Engineering', 'code': 'CSE306'},
    {'name': 'Machine Learning', 'code': 'CSE307'},
    {'name': 'Computer Graphics', 'code': 'CSE308'},
    {'name': 'Artificial Intelligence', 'code': 'CSE309'},
    {'name': 'Web Technologies', 'code': 'CSE310'},
  ];

  static const _rooms = [
    'Lab-101', 'Lab-102', 'Lab-103', 'CR-201', 'CR-202', 
    'CR-203', 'Seminar Hall', 'Conference Room', 'Library Hall'
  ];

  static const _sections = ['A', 'B', 'C'];

  /// Get schedule for a specific date
  Future<DaySchedule> getScheduleForDate(DateTime date) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Don't generate classes for weekends
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return DaySchedule(date: date, sessions: []);
    }

    final sessions = _generateSessionsForDate(date);
    return DaySchedule(date: date, sessions: sessions);
  }

  /// Get today's schedule
  Future<DaySchedule> getTodaysSchedule() async {
    final today = DateTime.now();
    return getScheduleForDate(DateTime(today.year, today.month, today.day));
  }

  /// Get schedule for current week
  Future<List<DaySchedule>> getWeekSchedule([DateTime? startDate]) async {
    startDate ??= DateTime.now();
    
    // Get Monday of the week
    final monday = startDate.subtract(Duration(days: startDate.weekday - 1));
    
    final weekSchedules = <DaySchedule>[];
    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final schedule = await getScheduleForDate(date);
      weekSchedules.add(schedule);
    }
    
    return weekSchedules;
  }

  /// Generate mock sessions for a given date
  List<ClassSession> _generateSessionsForDate(DateTime date) {
    final sessions = <ClassSession>[];
    
    // Determine number of classes based on day (fewer on Friday)
    int numClasses;
    switch (date.weekday) {
      case DateTime.monday:
      case DateTime.tuesday:
      case DateTime.wednesday:
      case DateTime.thursday:
        numClasses = 4 + _random.nextInt(3); // 4-6 classes
        break;
      case DateTime.friday:
        numClasses = 2 + _random.nextInt(3); // 2-4 classes
        break;
      default:
        return []; // No classes on weekends
    }

    // Standard time slots
    final timeSlots = [
      {'start': 9, 'duration': 60},   // 9:00-10:00
      {'start': 10, 'duration': 60},  // 10:00-11:00
      {'start': 11, 'duration': 60},  // 11:00-12:00
      {'start': 14, 'duration': 90},  // 2:00-3:30 (Lab)
      {'start': 15, 'duration': 60},  // 3:00-4:00
      {'start': 16, 'duration': 60},  // 4:00-5:00
    ];

    // Select random time slots
    final selectedSlots = timeSlots.take(numClasses).toList();
    selectedSlots.shuffle(_random);

    for (int i = 0; i < numClasses; i++) {
      final slot = selectedSlots[i];
      final subject = _subjects[_random.nextInt(_subjects.length)];
      final room = _rooms[_random.nextInt(_rooms.length)];
      final section = _sections[_random.nextInt(_sections.length)];

      final startTime = DateTime(
        date.year,
        date.month,
        date.day,
        slot['start'] as int,
        _random.nextInt(2) * 30, // 0 or 30 minutes
      );

      final endTime = startTime.add(Duration(minutes: slot['duration'] as int));

      // For today's schedule, ensure some realistic timing
      DateTime actualStart = startTime;
      DateTime actualEnd = endTime;

      if (date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day) {
        // If it's today, adjust times to be more realistic
        actualStart = _adjustTimeForToday(startTime, i);
        actualEnd = actualStart.add(Duration(minutes: slot['duration'] as int));
      }

      final session = ClassSession(
        id: 'session_${date.day}_$i',
        subject: subject['name']!,
        code: subject['code']!,
        section: section,
        room: room,
        start: actualStart,
        end: actualEnd,
      );

      sessions.add(session);
    }

    // Sort sessions by start time
    sessions.sort((a, b) => a.start.compareTo(b.start));

    return sessions;
  }

  /// Adjust times for today to make them more realistic
  DateTime _adjustTimeForToday(DateTime originalTime, int index) {
    final now = DateTime.now();
    
    // If it's before 9 AM, start sessions from 9 AM
    if (now.hour < 9) {
      return DateTime(now.year, now.month, now.day, 9 + index, 0);
    }
    
    // If it's after 5 PM, generate past sessions
    if (now.hour >= 17) {
      return DateTime(now.year, now.month, now.day, 9 + index, 0);
    }
    
    // Mix of past, current, and future sessions
    final baseHour = now.hour - 2 + index;
    final hour = baseHour.clamp(9, 17);
    
    return DateTime(now.year, now.month, now.day, hour, originalTime.minute);
  }

  /// Stream that emits countdown updates for a specific session
  Stream<Duration> getCountdownStream(ClassSession session) async* {
    while (session.isUpcoming) {
      final timeUntil = session.timeUntilStart;
      if (timeUntil != null) {
        yield timeUntil;
        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    }
  }

  /// Get user role (mock implementation)
  Future<UserRole> getCurrentUserRole() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // For demo purposes, return FACULTY. In real app, this would come from auth
    return UserRole.faculty;
  }

  /// Apply for leave (mock implementation)
  Future<bool> applyForLeave({
    required DateTime date,
    required String reason,
    required String sessionId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock success (90% success rate)
    return _random.nextDouble() > 0.1;
  }

  /// Get department statistics (for dept access roles)
  Future<Map<String, dynamic>> getDepartmentStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return {
      'totalFaculty': 25,
      'totalStudents': 450,
      'classesScheduled': 32,
      'leaveRequests': 3,
      'attendanceRate': 92.5,
    };
  }
}

/// Extension to add helper methods for time formatting
extension DateTimeFormatting on DateTime {
  /// Format as "HH:MM"
  String get timeFormat {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format as "DD MMM YYYY"
  String get dateFormat {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${day.toString().padLeft(2, '0')} ${months[month - 1]} $year';
  }

  /// Format as "Today", "Tomorrow", or "DD MMM"
  String get relativeDateFormat {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisDate = DateTime(year, month, day);
    
    final difference = thisDate.difference(today).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${day.toString().padLeft(2, '0')} ${months[month - 1]}';
  }
}
