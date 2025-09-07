import '../models/hod_models.dart';

abstract class ApprovalsRepository {
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<List<SwapRequest>> getSwapRequests();
}

class MockApprovalsRepository implements ApprovalsRepository {
  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final now = DateTime.now();
    return [
      LeaveRequest(
        id: 'lr1',
        facultyId: 'f001',
        facultyName: 'Dr. Priya Sharma',
        reason: 'Medical emergency - family member hospitalized',
        startDate: '2024-01-15',
        endDate: '2024-01-17',
        status: LeaveStatus.pending,
        affectedClasses: ['CS101-A', 'CS102-B'],
        impactCount: 6,
        hasAttachments: true,
        requestedAt: now.subtract(const Duration(hours: 2)),
        submittedAt: now.subtract(const Duration(hours: 2)),
        priority: Priority.urgent,
      ),
      LeaveRequest(
        id: 'lr2',
        facultyId: 'f002',
        facultyName: 'Prof. Rajesh Kumar',
        reason: 'Conference attendance - IEEE International Conference',
        startDate: '2024-01-20',
        endDate: '2024-01-22',
        status: LeaveStatus.pending,
        affectedClasses: ['EE201-A', 'EE301-B'],
        impactCount: 4,
        hasAttachments: false,
        requestedAt: now.subtract(const Duration(hours: 5)),
        submittedAt: now.subtract(const Duration(hours: 5)),
        priority: Priority.medium,
      ),
      LeaveRequest(
        id: 'lr3',
        facultyId: 'f003',
        facultyName: 'Dr. Meena Patel',
        reason: 'Personal work - visa appointment',
        startDate: '2024-01-25',
        endDate: '2024-01-25',
        status: LeaveStatus.approved,
        affectedClasses: ['MA201-A'],
        impactCount: 2,
        hasAttachments: false,
        requestedAt: now.subtract(const Duration(days: 1)),
        submittedAt: now.subtract(const Duration(days: 1)),
        priority: Priority.low,
      ),
      LeaveRequest(
        id: 'lr4',
        facultyId: 'f004',
        facultyName: 'Dr. Suresh Babu',
        reason: 'Training program - Advanced Communication Systems',
        startDate: '2024-02-01',
        endDate: '2024-02-03',
        status: LeaveStatus.pending,
        affectedClasses: ['EC301-A', 'EC401-B'],
        impactCount: 8,
        hasAttachments: true,
        requestedAt: now.subtract(const Duration(hours: 8)),
        submittedAt: now.subtract(const Duration(hours: 8)),
        priority: Priority.high,
      ),
    ];
  }

  @override
  Future<List<SwapRequest>> getSwapRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    return [
      SwapRequest(
        id: 'sr1',
        requesterId: 'f005',
        requesterName: 'Dr. Anitha Reddy',
        targetFacultyId: 'f006',
        targetFacultyName: 'Prof. Vikram Singh',
        requesterSlot: 'CS202-C (Mon 2:00-3:00 PM)',
        targetSlot: 'CS303-A (Tue 10:00-11:00 AM)',
        requestedDate: '2024-01-16',
        reason: 'Doctor appointment scheduled during current slot',
        status: SubstitutionStatus.pending,
        impactCount: 2,
        requestedAt: now.subtract(const Duration(hours: 1)),
        priority: Priority.medium,
      ),
      SwapRequest(
        id: 'sr2',
        requesterId: 'f007',
        requesterName: 'Prof. Kavitha Nair',
        targetFacultyId: 'f008',
        targetFacultyName: 'Dr. Arjun Reddy',
        requesterSlot: 'ME301-A (Wed 11:00-12:00 PM)',
        targetSlot: 'EC201-B (Wed 2:00-3:00 PM)',
        requestedDate: '2024-01-18',
        reason: 'Family function - need to leave early',
        status: SubstitutionStatus.pending,
        impactCount: 1,
        requestedAt: now.subtract(const Duration(hours: 3)),
        priority: Priority.low,
      ),
      SwapRequest(
        id: 'sr3',
        requesterId: 'f009',
        requesterName: 'Dr. Ravi Kumar',
        targetFacultyId: 'f010',
        targetFacultyName: 'Prof. Sunil Gupta',
        requesterSlot: 'ME401-A (Thu 9:00-10:00 AM)',
        targetSlot: 'EE301-B (Thu 3:00-4:00 PM)',
        requestedDate: '2024-01-19',
        reason: 'Emergency travel - family emergency',
        status: SubstitutionStatus.approved,
        impactCount: 3,
        requestedAt: now.subtract(const Duration(hours: 6)),
        priority: Priority.urgent,
      ),
    ];
  }
}
