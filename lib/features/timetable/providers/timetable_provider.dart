import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/timetable_models.dart';

// Supabase client provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.currentUser;
});

// Timetable state notifier
class TimetableNotifier extends StateNotifier<TimetableState> {
  final SupabaseClient _supabase;
  final String? _currentUserId;

  TimetableNotifier(this._supabase, this._currentUserId) : super(TimetableState()) {
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    if (_currentUserId == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'User not authenticated',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _supabase
          .from('master_timetable')
          .select('*')
          .eq('faculty_id', _currentUserId)
          .eq('department', state.filters.department)
          .eq('section', state.filters.section)
          .eq('semester', state.filters.semester);

      final classes = (response as List)
          .map((json) => TimetableClass.fromJson(json))
          .toList();

      state = state.copyWith(
        classes: classes,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load timetable: ${error.toString()}',
      );
    }
  }

  void updateFilters(TimetableFilters newFilters) {
    state = state.copyWith(filters: newFilters);
    loadTimetable();
  }

  void updateSelectedDay(String day) {
    final newFilters = state.filters.copyWith(selectedDay: day);
    state = state.copyWith(filters: newFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateDepartment(String department) {
    final newFilters = state.filters.copyWith(department: department);
    updateFilters(newFilters);
  }

  void updateSection(String section) {
    final newFilters = state.filters.copyWith(section: section);
    updateFilters(newFilters);
  }

  void updateSemester(int semester) {
    final newFilters = state.filters.copyWith(semester: semester);
    updateFilters(newFilters);
  }

  Future<void> refreshTimetable() async {
    await loadTimetable();
  }
}

// Timetable provider
final timetableProvider = StateNotifierProvider<TimetableNotifier, TimetableState>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final currentUser = ref.watch(currentUserProvider);
  return TimetableNotifier(supabase, currentUser?.id);
});

// Filtered classes provider
final filteredClassesProvider = Provider<List<TimetableClass>>((ref) {
  final timetableState = ref.watch(timetableProvider);
  return timetableState.filteredClasses;
});

// Days provider
final daysProvider = Provider<List<String>>((ref) {
  return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
});

// Departments provider
final departmentsProvider = Provider<List<String>>((ref) {
  return ['CSE', 'MECH', 'ECE', 'EEE', 'CIVIL', 'IT'];
});

// Sections provider
final sectionsProvider = Provider<List<String>>((ref) {
  return ['A', 'B', 'C', 'D'];
});

// Semesters provider
final semestersProvider = Provider<List<int>>((ref) {
  return [1, 2, 3, 4, 5, 6, 7, 8];
});

// Current day provider
final currentDayProvider = Provider<String>((ref) {
  final now = DateTime.now();
  final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final currentWeekday = weekdays[now.weekday - 1];
  return currentWeekday == 'Sun' ? 'Mon' : currentWeekday;
});
