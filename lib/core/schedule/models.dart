import 'package:equatable/equatable.dart';

/// Extensions for DateTime formatting
extension DateTimeExtensions on DateTime {
  /// Format time as HH:MM AM/PM
  String get timeFormat {
    final hour = this.hour > 12 ? this.hour - 12 : (this.hour == 0 ? 12 : this.hour);
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Format relative date (e.g., "Today", "Tomorrow", or "Mon, Dec 4")
  String get relativeDateFormat {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(year, month, day);
    
    if (targetDay == today) {
      return 'Today';
    } else if (targetDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (targetDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${days[weekday - 1]}, ${months[month - 1]} $day';
    }
  }
}

/// Represents a single class session
class ClassSession extends Equatable {
  final String id;
  final String subject;
  final String code;
  final String section;
  final String room;
  final DateTime start;
  final DateTime end;

  const ClassSession({
    required this.id,
    required this.subject,
    required this.code,
    required this.section,
    required this.room,
    required this.start,
    required this.end,
  });

  /// Duration of the session
  Duration get duration => end.difference(start);

  /// Check if the session is currently in progress
  bool get isInProgress {
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  /// Check if the session is upcoming (hasn't started yet)
  bool get isUpcoming {
    return DateTime.now().isBefore(start);
  }

  /// Check if the session has ended
  bool get hasEnded {
    return DateTime.now().isAfter(end);
  }

  /// Time remaining until session starts (null if already started/ended)
  Duration? get timeUntilStart {
    if (!isUpcoming) return null;
    return start.difference(DateTime.now());
  }

  /// Time remaining until session ends (null if not in progress)
  Duration? get timeUntilEnd {
    if (!isInProgress) return null;
    return end.difference(DateTime.now());
  }

  /// Format time range as "HH:MM - HH:MM"
  String get timeRange {
    final startTime = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endTime = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startTime - $endTime';
  }

  /// Format start time as "HH:MM"
  String get startTimeFormatted {
    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
  }

  /// Format end time as "HH:MM"
  String get endTimeFormatted {
    return '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [id, subject, code, section, room, start, end];

  ClassSession copyWith({
    String? id,
    String? subject,
    String? code,
    String? section,
    String? room,
    DateTime? start,
    DateTime? end,
  }) {
    return ClassSession(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      code: code ?? this.code,
      section: section ?? this.section,
      room: room ?? this.room,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  String toString() {
    return 'ClassSession(id: $id, subject: $subject, code: $code, section: $section, room: $room, start: $start, end: $end)';
  }
}

/// Represents a day's complete schedule
class DaySchedule extends Equatable {
  final DateTime date;
  final List<ClassSession> sessions;

  const DaySchedule({
    required this.date,
    required this.sessions,
  });

  /// Get sessions sorted by start time
  List<ClassSession> get sortedSessions {
    final sorted = List<ClassSession>.from(sessions);
    sorted.sort((a, b) => a.start.compareTo(b.start));
    return sorted;
  }

  /// Get upcoming sessions (not started yet)
  List<ClassSession> get upcomingSessions {
    return sortedSessions.where((session) => session.isUpcoming).toList();
  }

  /// Get sessions currently in progress
  List<ClassSession> get currentSessions {
    return sessions.where((session) => session.isInProgress).toList();
  }

  /// Get sessions that have ended
  List<ClassSession> get completedSessions {
    return sessions.where((session) => session.hasEnded).toList();
  }

  /// Get the next upcoming session (null if none)
  ClassSession? get nextSession {
    final upcoming = upcomingSessions;
    return upcoming.isEmpty ? null : upcoming.first;
  }

  /// Get the current session (null if none in progress)
  ClassSession? get currentSession {
    final current = currentSessions;
    return current.isEmpty ? null : current.first;
  }

  /// Check if there are any classes today
  bool get hasClasses => sessions.isNotEmpty;

  /// Check if all classes for the day are completed
  bool get allClassesCompleted {
    return hasClasses && upcomingSessions.isEmpty && currentSessions.isEmpty;
  }

  /// Get the day name (e.g., "Monday")
  String get dayName {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  /// Check if this is today's schedule
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  List<Object?> get props => [date, sessions];

  DaySchedule copyWith({
    DateTime? date,
    List<ClassSession>? sessions,
  }) {
    return DaySchedule(
      date: date ?? this.date,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  String toString() {
    return 'DaySchedule(date: $date, sessions: ${sessions.length} sessions)';
  }
}

/// User roles for permission-based features
enum UserRole {
  dean('DEAN'),
  viceDean('VICE DEAN'),
  hod('HOD'),
  faculty('FACULTY'),
  staff('STAFF'),
  nonTeachingStaff('NON TEACHING STAFF'),
  guestFaculty('GUEST FACULTY');

  const UserRole(this.displayName);
  final String displayName;

  /// Check if this role has department access
  bool get hasDepartmentAccess {
    return this == UserRole.dean || 
           this == UserRole.viceDean || 
           this == UserRole.hod;
  }

  /// Check if this role can manage schedules
  bool get canManageSchedules {
    return hasDepartmentAccess;
  }

  /// Check if this role can approve leaves
  bool get canApproveLeaves {
    return hasDepartmentAccess;
  }
}
