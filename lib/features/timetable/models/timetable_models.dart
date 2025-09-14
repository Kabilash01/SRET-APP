class TimetableClass {
  final String id;
  final String subjectName;
  final String facultyName;
  final String roomNumber;
  final DateTime startTime;
  final DateTime endTime;
  final String classType;
  final String dayOfWeek;
  final String department;
  final String section;
  final int semester;

  TimetableClass({
    required this.id,
    required this.subjectName,
    required this.facultyName,
    required this.roomNumber,
    required this.startTime,
    required this.endTime,
    required this.classType,
    required this.dayOfWeek,
    required this.department,
    required this.section,
    required this.semester,
  });

  factory TimetableClass.fromJson(Map<String, dynamic> json) {
    return TimetableClass(
      id: json['id'] ?? '',
      subjectName: json['subject_name'] ?? '',
      facultyName: json['faculty_name'] ?? '',
      roomNumber: json['room_number'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      classType: json['class_type'] ?? 'Lecture',
      dayOfWeek: json['day_of_week'] ?? '',
      department: json['department'] ?? '',
      section: json['section'] ?? '',
      semester: json['semester'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_name': subjectName,
      'faculty_name': facultyName,
      'room_number': roomNumber,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'class_type': classType,
      'day_of_week': dayOfWeek,
      'department': department,
      'section': section,
      'semester': semester,
    };
  }

  String get timeSlot {
    final startTimeFormatted = _formatTime(startTime);
    final endTimeFormatted = _formatTime(endTime);
    return '$startTimeFormatted - $endTimeFormatted';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  bool get isCurrentClass {
    final now = DateTime.now();
    final currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final classStart = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    final classEnd = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    
    return currentTime.isAfter(classStart) && currentTime.isBefore(classEnd);
  }
}

class TimetableFilters {
  final String department;
  final String section;
  final int semester;
  final String selectedDay;

  const TimetableFilters({
    this.department = 'MECH',
    this.section = 'A',
    this.semester = 6,
    this.selectedDay = 'Mon',
  });

  TimetableFilters copyWith({
    String? department,
    String? section,
    int? semester,
    String? selectedDay,
  }) {
    return TimetableFilters(
      department: department ?? this.department,
      section: section ?? this.section,
      semester: semester ?? this.semester,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}

class TimetableState {
  final List<TimetableClass> classes;
  final TimetableFilters filters;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  const TimetableState({
    this.classes = const [],
    this.filters = const TimetableFilters(),
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  TimetableState copyWith({
    List<TimetableClass>? classes,
    TimetableFilters? filters,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
  }) {
    return TimetableState(
      classes: classes ?? this.classes,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<TimetableClass> get filteredClasses {
    var filtered = classes.where((classItem) => 
      classItem.dayOfWeek.toLowerCase() == filters.selectedDay.toLowerCase()
    ).toList();

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((classItem) =>
        classItem.subjectName.toLowerCase().contains(searchQuery.toLowerCase()) ||
        classItem.facultyName.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Sort by start time
    filtered.sort((a, b) => a.startTime.compareTo(b.startTime));
    
    return filtered;
  }
}
