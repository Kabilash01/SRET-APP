enum ClassStatus {
  onTime,
  vacant,
  delay,
  conflict,
  roomChange,
  lateStart,
  running,
  scheduled,
  completed,

  String get displayName {
    switch (this) {
      case ClassStatus.onTime:
        return 'On Time';
      case ClassStatus.vacant:
        return 'Vacant';
      case ClassStatus.delay:
        return 'Delayed';
      case ClassStatus.conflict:
        return 'Conflict';
      case ClassStatus.roomChange:
        return 'Room Change';
      case ClassStatus.lateStart:
        return 'Late Start';
      case ClassStatus.running:
        return 'Running';
      case ClassStatus.scheduled:
        return 'Scheduled';
      case ClassStatus.completed:
        return 'Completed';
    }
  }
}

enum Priority {
  low,
  medium,
  high,
  urgent,

  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }
}

enum LeaveStatus {
  pending,
  approved,
  rejected,

  String get displayName {
    switch (this) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
    }
  }
}

enum SubstitutionStatus {
  pending,
  accepted,
  declined,
  noResponse,
  manualOverride,
  approved,
  rejected,
  active,
  completed,

  String get displayName {
    switch (this) {
      case SubstitutionStatus.pending:
        return 'Pending';
      case SubstitutionStatus.accepted:
        return 'Accepted';
      case SubstitutionStatus.declined:
        return 'Declined';
      case SubstitutionStatus.noResponse:
        return 'No Response';
      case SubstitutionStatus.manualOverride:
        return 'Manual Override';
      case SubstitutionStatus.approved:
        return 'Approved';
      case SubstitutionStatus.rejected:
        return 'Rejected';
      case SubstitutionStatus.active:
        return 'Active';
      case SubstitutionStatus.completed:
        return 'Completed';
    }
  }
}

class OngoingClass {
  final String id;
  final String course;
  final String subject; // Add subject property
  final String section;
  final String semester;
  final String room;
  final String? faculty;
  final String? facultyName; // Add facultyName property
  final ClassStatus status;
  final String startTime; // Change to String to match usage
  final String endTime; // Change to String to match usage
  final int? vacantMinutes;
  final String program;
  final String courseType;
  final String roomBlock;

  const OngoingClass({
    required this.id,
    required this.course,
    required this.subject,
    required this.section,
    required this.semester,
    required this.room,
    this.faculty,
    this.facultyName,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.vacantMinutes,
    required this.program,
    required this.courseType,
    required this.roomBlock,
  });

  String get statusDisplay {
    switch (status) {
      case ClassStatus.onTime:
        return 'ON TIME';
      case ClassStatus.vacant:
        return 'VACANT';
      case ClassStatus.delay:
        return 'DELAY';
      case ClassStatus.conflict:
        return 'CONFLICT';
      case ClassStatus.roomChange:
        return 'ROOM CHANGE';
      case ClassStatus.lateStart:
        return 'LATE START';
    }
  }

  String get vacantDisplay {
    if (vacantMinutes == null) return '';
    return 'Vacant for ${vacantMinutes!.toString().padLeft(2, '0')}m';
  }
}

class FreeFaculty {
  final String id;
  final String name;
  final String department;
  final DateTime? nextClassTime;
  final String? notes;
  final List<String> skills;
  final String proximity;

  const FreeFaculty({
    required this.id,
    required this.name,
    required this.department,
    this.nextClassTime,
    this.notes,
    this.skills = const [],
    this.proximity = 'nearby',
  });

  String get nextClassDisplay {
    if (nextClassTime == null) return 'No classes today';
    final time = '${nextClassTime!.hour.toString().padLeft(2, '0')}:${nextClassTime!.minute.toString().padLeft(2, '0')}';
    return 'Next class: $time';
  }
}

class LeaveRequest {
  final String id;
  final String facultyId;
  final String facultyName;
  final String reason;
  final String startDate; // Change to String to match usage
  final String endDate; // Change to String to match usage
  final LeaveStatus status;
  final List<String> affectedClasses;
  final int impactCount;
  final bool hasAttachments;
  final DateTime requestedAt;
  final DateTime submittedAt; // Add submittedAt property
  final Priority priority; // Add priority property

  const LeaveRequest({
    required this.id,
    required this.facultyId,
    required this.facultyName,
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.affectedClasses,
    required this.impactCount,
    this.hasAttachments = false,
    required this.requestedAt,
    required this.submittedAt,
    required this.priority,
  });

  String get durationDisplay {
    final days = endDate.difference(startDate).inDays + 1;
    if (days == 1) return '1 day';
    return '$days days';
  }
}

class SwapRequest {
  final String id;
  final String requesterId; // Add requesterId property
  final String requesterName;
  final String targetFacultyId; // Add targetFacultyId property
  final String targetFacultyName;
  final String requesterSlot;
  final String targetSlot;
  final String requestedDate; // Add requestedDate property
  final String reason;
  final SubstitutionStatus status; // Change to SubstitutionStatus
  final int impactCount;
  final DateTime requestedAt;
  final Priority priority; // Add priority property

  const SwapRequest({
    required this.id,
    required this.requesterId,
    required this.requesterName,
    required this.targetFacultyId,
    required this.targetFacultyName,
    required this.requesterSlot,
    required this.targetSlot,
    required this.requestedDate,
    required this.reason,
    required this.status,
    required this.impactCount,
    required this.requestedAt,
    required this.priority,
  });
}

class SubstitutionAttempt {
  final String facultyId;
  final String facultyName;
  final SubstitutionStatus status;
  final DateTime attemptedAt;
  final String? response;

  const SubstitutionAttempt({
    required this.facultyId,
    required this.facultyName,
    required this.status,
    required this.attemptedAt,
    this.response,
  });
}

class SubstitutionConsole {
  final String vacancyId;
  final String course;
  final String section;
  final String room;
  final DateTime slotTime;
  final int priority;
  final List<SubstitutionAttempt> attempts;
  final bool isStalled;
  final bool isUrgent;
  final int minutesStalled;

  const SubstitutionConsole({
    required this.vacancyId,
    required this.course,
    required this.section,
    required this.room,
    required this.slotTime,
    required this.priority,
    required this.attempts,
    this.isStalled = false,
    this.isUrgent = false,
    this.minutesStalled = 0,
  });

  String get priorityDisplay {
    return 'P$priority';
  }

  String get stalledDisplay {
    if (!isStalled) return '';
    return 'Stalled for ${minutesStalled}m';
  }
}

class Announcement {
  final String id;
  final String title;
  final String content;
  final Priority priority;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<String> targetGroups;
  final bool isActive;
  final int views;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    this.expiresAt,
    this.targetGroups = const [],
    this.isActive = true,
    this.views = 0,
  });

  String get priorityDisplay {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }

  String get statusDisplay {
    if (!isActive) return 'Expired';
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) {
      return 'Expired';
    }
    return 'Active';
  }
}

class DashboardKPIs {
  final int ongoingClasses;
  final int freeFaculty;
  final int vacantSlots;
  final int pendingApprovals;
  final int overdueApprovals;

  const DashboardKPIs({
    required this.ongoingClasses,
    required this.freeFaculty,
    required this.vacantSlots,
    required this.pendingApprovals,
    this.overdueApprovals = 0,
  });
}
