import '../models/hod_models.dart';

abstract class SubstitutionRepository {
  Future<List<SubstitutionConsole>> getSubstitutionConsoles();
  Future<void> assignManualSubstitution(String vacancyId, String facultyId);
  Future<void> applyPriorityOverride(String vacancyId);
}

class MockSubstitutionRepository implements SubstitutionRepository {
  @override
  Future<List<SubstitutionConsole>> getSubstitutionConsoles() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final now = DateTime.now();
    return [
      SubstitutionConsole(
        vacancyId: 'v001',
        course: 'CS101 - Data Structures',
        section: 'B',
        room: 'CR-202',
        slotTime: now.add(const Duration(hours: 1)),
        priority: 2,
        isStalled: true,
        minutesStalled: 15,
        attempts: [
          SubstitutionAttempt(
            facultyId: 'f001',
            facultyName: 'Dr. Priya Sharma',
            status: SubstitutionStatus.declined,
            attemptedAt: now.subtract(const Duration(minutes: 15)),
            response: 'Already teaching',
          ),
          SubstitutionAttempt(
            facultyId: 'f002',
            facultyName: 'Dr. Lakshmi Devi',
            status: SubstitutionStatus.noResponse,
            attemptedAt: now.subtract(const Duration(minutes: 10)),
          ),
        ],
      ),
      SubstitutionConsole(
        vacancyId: 'v002',
        course: 'EE201 - Circuit Analysis',
        section: 'A',
        room: 'CR-301',
        slotTime: now.add(const Duration(hours: 2)),
        priority: 1,
        attempts: [
          SubstitutionAttempt(
            facultyId: 'f003',
            facultyName: 'Prof. Ravi Kumar',
            status: SubstitutionStatus.pending,
            attemptedAt: now.subtract(const Duration(minutes: 5)),
          ),
        ],
      ),
      SubstitutionConsole(
        vacancyId: 'v003',
        course: 'ME301 - Thermodynamics',
        section: 'C',
        room: 'CR-401',
        slotTime: now.add(const Duration(minutes: 30)),
        priority: 3,
        isUrgent: true,
        attempts: [
          SubstitutionAttempt(
            facultyId: 'f004',
            facultyName: 'Dr. Sita Mahalakshmi',
            status: SubstitutionStatus.accepted,
            attemptedAt: now.subtract(const Duration(minutes: 8)),
            response: 'Will take the class',
          ),
        ],
      ),
    ];
  }

  @override
  Future<void> assignManualSubstitution(String vacancyId, String facultyId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: Implement actual manual assignment logic
  }

  @override
  Future<void> applyPriorityOverride(String vacancyId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement priority override logic
  }
}
