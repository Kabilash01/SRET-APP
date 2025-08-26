import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'schedule_repo.dart';

/// Provider for the schedule repository
final scheduleRepoProvider = Provider<ScheduleRepo>((ref) {
  return ScheduleRepo();
});

/// Provider for the current user role
final userRoleProvider = FutureProvider<UserRole>((ref) async {
  final repo = ref.read(scheduleRepoProvider);
  return repo.getCurrentUserRole();
});

/// Provider for today's schedule
final todayScheduleProvider = FutureProvider<DaySchedule>((ref) async {
  final repo = ref.read(scheduleRepoProvider);
  return repo.getTodaysSchedule();
});

/// Provider for a specific date's schedule
final scheduleForDateProvider = FutureProvider.family<DaySchedule, DateTime>((ref, date) async {
  final repo = ref.read(scheduleRepoProvider);
  return repo.getScheduleForDate(date);
});

/// Provider for the current week's schedule
final weekScheduleProvider = FutureProvider<List<DaySchedule>>((ref) async {
  final repo = ref.read(scheduleRepoProvider);
  return repo.getWeekSchedule();
});

/// Provider for the next upcoming session
final nextSessionProvider = Provider<ClassSession?>((ref) {
  final todayScheduleAsync = ref.watch(todayScheduleProvider);
  
  return todayScheduleAsync.when(
    data: (schedule) {
      // First check for current session
      final current = schedule.currentSession;
      if (current != null) return current;
      
      // Then check for next upcoming
      return schedule.nextSession;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for countdown stream to next session
final countdownStreamProvider = StreamProvider<Duration?>((ref) async* {
  final nextSession = ref.watch(nextSessionProvider);
  
  if (nextSession == null) {
    yield null;
    return;
  }

  // If session is in progress, countdown to end
  if (nextSession.isInProgress) {
    while (nextSession.isInProgress) {
      final timeUntilEnd = nextSession.timeUntilEnd;
      if (timeUntilEnd != null) {
        yield timeUntilEnd;
        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    }
    yield null;
    return;
  }

  // If session is upcoming, countdown to start
  if (nextSession.isUpcoming) {
    while (nextSession.isUpcoming) {
      final timeUntilStart = nextSession.timeUntilStart;
      if (timeUntilStart != null) {
        yield timeUntilStart;
        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    }
  }
  
  yield null;
});

/// Provider for session status (current, upcoming, or none)
final sessionStatusProvider = Provider<SessionStatus>((ref) {
  final nextSession = ref.watch(nextSessionProvider);
  
  if (nextSession == null) {
    return SessionStatus.none;
  }
  
  if (nextSession.isInProgress) {
    return SessionStatus.current;
  }
  
  if (nextSession.isUpcoming) {
    return SessionStatus.upcoming;
  }
  
  return SessionStatus.none;
});

/// Provider for department statistics (only for authorized roles)
final departmentStatsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userRole = await ref.watch(userRoleProvider.future);
  
  if (!userRole.hasDepartmentAccess) {
    return null;
  }
  
  final repo = ref.read(scheduleRepoProvider);
  return repo.getDepartmentStats();
});

/// Provider for checking if user can access department features
final canAccessDepartmentProvider = Provider<bool>((ref) {
  final userRoleAsync = ref.watch(userRoleProvider);
  
  return userRoleAsync.when(
    data: (role) => role.hasDepartmentAccess,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for filtered today's sessions by status
final todaySessionsByStatusProvider = Provider<Map<String, List<ClassSession>>>((ref) {
  final todayScheduleAsync = ref.watch(todayScheduleProvider);
  
  return todayScheduleAsync.when(
    data: (schedule) {
      return {
        'completed': schedule.completedSessions,
        'current': schedule.currentSessions,
        'upcoming': schedule.upcomingSessions,
      };
    },
    loading: () => {
      'completed': <ClassSession>[],
      'current': <ClassSession>[],
      'upcoming': <ClassSession>[],
    },
    error: (_, __) => {
      'completed': <ClassSession>[],
      'current': <ClassSession>[],
      'upcoming': <ClassSession>[],
    },
  );
});

/// Provider for checking if all classes are done for today
final allClassesDoneProvider = Provider<bool>((ref) {
  final todayScheduleAsync = ref.watch(todayScheduleProvider);
  
  return todayScheduleAsync.when(
    data: (schedule) => schedule.allClassesCompleted,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Enum for session status
enum SessionStatus {
  none,
  upcoming,
  current,
}

/// Provider for auto-refreshing today's schedule every minute
final autoRefreshTodayScheduleProvider = StreamProvider<DaySchedule?>((ref) async* {
  // Initial load
  final initialSchedule = await ref.read(scheduleRepoProvider).getTodaysSchedule();
  yield initialSchedule;
  
  // Refresh every minute
  await for (final _ in Stream.periodic(const Duration(minutes: 1))) {
    try {
      final updatedSchedule = await ref.read(scheduleRepoProvider).getTodaysSchedule();
      yield updatedSchedule;
    } catch (e) {
      // Continue with last known schedule on error
      yield initialSchedule;
    }
  }
});

/// Provider for leave application status
final leaveApplicationProvider = StateNotifierProvider<LeaveApplicationNotifier, LeaveApplicationState>((ref) {
  final repo = ref.read(scheduleRepoProvider);
  return LeaveApplicationNotifier(repo);
});

/// State notifier for leave applications
class LeaveApplicationNotifier extends StateNotifier<LeaveApplicationState> {
  final ScheduleRepo _repo;
  
  LeaveApplicationNotifier(this._repo) : super(const LeaveApplicationState.initial());
  
  Future<void> applyForLeave({
    required DateTime date,
    required String reason,
    required String sessionId,
  }) async {
    state = const LeaveApplicationState.loading();
    
    try {
      final success = await _repo.applyForLeave(
        date: date,
        reason: reason,
        sessionId: sessionId,
      );
      
      if (success) {
        state = const LeaveApplicationState.success();
      } else {
        state = const LeaveApplicationState.error('Leave application failed');
      }
    } catch (e) {
      state = LeaveApplicationState.error(e.toString());
    }
  }
  
  void reset() {
    state = const LeaveApplicationState.initial();
  }
}

/// State for leave applications
sealed class LeaveApplicationState {
  const LeaveApplicationState();
  
  const factory LeaveApplicationState.initial() = LeaveApplicationInitial;
  const factory LeaveApplicationState.loading() = LeaveApplicationLoading;
  const factory LeaveApplicationState.success() = LeaveApplicationSuccess;
  const factory LeaveApplicationState.error(String message) = LeaveApplicationError;
}

class LeaveApplicationInitial extends LeaveApplicationState {
  const LeaveApplicationInitial();
}

class LeaveApplicationLoading extends LeaveApplicationState {
  const LeaveApplicationLoading();
}

class LeaveApplicationSuccess extends LeaveApplicationState {
  const LeaveApplicationSuccess();
}

class LeaveApplicationError extends LeaveApplicationState {
  final String message;
  const LeaveApplicationError(this.message);
}
