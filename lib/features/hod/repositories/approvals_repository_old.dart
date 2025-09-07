import '../models/hod_models.dart';

abstract class ApprovalsRepository {
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<List<SwapRequest>> getSwapRequests();
  Future<void> approveLeave(String id);
  Future<void> rejectLeave(String id, String reason);
  Future<void> approveSwap(String id);
  Future<void> rejectSwap(String id, String reason);
}

class MockApprovalsRepository implements ApprovalsRepository {
  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    final now = DateTime.now();
    return [
      LeaveRequest(
        id: '1',
        facultyId: 'f001',
        facultyName: 'Dr. Priya Sharma',
        reason: 'Medical Emergency',
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 4)),
        status: LeaveStatus.pending,
        affectedClasses: ['CS101-A', 'CS201-B', 'CS301-C'],
        impactCount: 120, // students affected
        hasAttachments: true,
        requestedAt: now.subtract(const Duration(hours: 2)),
      ),
      LeaveRequest(
        id: '2',
        facultyId: 'f002',
        facultyName: 'Prof. Ravi Kumar',
        reason: 'Conference Attendance',
        startDate: now.add(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 9)),
        status: LeaveStatus.pending,
        affectedClasses: ['ME301-A', 'ME401-A'],
        impactCount: 80,
        hasAttachments: false,
        requestedAt: now.subtract(const Duration(minutes: 45)),
      ),
      LeaveRequest(
        id: '3',
        facultyId: 'f003',
        facultyName: 'Dr. Anitha Reddy',
        reason: 'Personal Work',
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 1)),
        status: LeaveStatus.pending,
        affectedClasses: ['CS202-C'],
        impactCount: 40,
        hasAttachments: false,
        requestedAt: now.subtract(const Duration(hours: 8)),
      ),
    ];
  }

  @override
  Future<List<SwapRequest>> getSwapRequests() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final now = DateTime.now();
    return [
      SwapRequest(
        id: '1',
        requesterName: 'Dr. Suresh Babu',
        targetFacultyName: 'Prof. Venkat Rao',
        requesterSlot: 'Mon 10:00-11:00 (EC301-A)',
        targetSlot: 'Mon 14:00-15:00 (Math201-B)',
        reason: 'Doctor appointment',
        status: LeaveStatus.pending,
        impactCount: 60,
        requestedAt: now.subtract(const Duration(minutes: 30)),
      ),
      SwapRequest(
        id: '2',
        requesterName: 'Dr. Kavitha Priya',
        targetFacultyName: 'Dr. Lakshmi Devi',
        requesterSlot: 'Tue 09:00-10:00 (CS101-B)',
        targetSlot: 'Tue 15:00-16:00 (CS201-A)',
        reason: 'Personal emergency',
        status: LeaveStatus.pending,
        impactCount: 45,
        requestedAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }

  @override
  Future<void> approveLeave(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual approval logic
  }

  @override
  Future<void> rejectLeave(String id, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual rejection logic
  }

  @override
  Future<void> approveSwap(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual approval logic
  }

  @override
  Future<void> rejectSwap(String id, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Implement actual rejection logic
  }
}
