import '../models/hod_models.dart';

abstract class DeptRepository {
  Future<DashboardKPIs> getDashboardKPIs();
  Future<List<OngoingClass>> getOngoingClasses();
  Future<List<FreeFaculty>> getFreeFaculty();
  Future<List<OngoingClass>> getVacantSlots();
}

class MockDeptRepository implements DeptRepository {
  @override
  Future<DashboardKPIs> getDashboardKPIs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return const DashboardKPIs(
      ongoingClasses: 24,
      freeFaculty: 8,
      vacantSlots: 3,
      pendingApprovals: 7,
      overdueApprovals: 2,
    );
  }

  @override
  Future<List<OngoingClass>> getOngoingClasses() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return [
      OngoingClass(
        id: '1',
        course: 'CS101',
        subject: 'Data Structures',
        section: 'A',
        semester: '3rd',
        room: 'CR-301',
        faculty: 'Dr. Priya Sharma',
        facultyName: 'Dr. Priya Sharma',
        status: ClassStatus.onTime,
        startTime: '09:00',
        endTime: '10:00',
        program: 'B.Tech CSE',
        courseType: 'Core',
        roomBlock: 'A',
      ),
      OngoingClass(
        id: '2',
        course: 'EE201',
        subject: 'Circuit Analysis',
        section: 'B',
        semester: '4th',
        room: 'CR-205',
        faculty: null,
        status: ClassStatus.vacant,
        startTime: now.subtract(const Duration(minutes: 7)),
        endTime: now.add(const Duration(minutes: 53)),
        vacantMinutes: 7,
        program: 'B.Tech EEE',
        courseType: 'Core',
        roomBlock: 'B',
      ),
      OngoingClass(
        id: '3',
        course: 'ME301 - Thermodynamics',
        section: 'A',
        semester: '5th',
        room: 'CR-401',
        faculty: 'Prof. Ravi Kumar',
        status: ClassStatus.delay,
        startTime: now.subtract(const Duration(minutes: 20)),
        endTime: now.add(const Duration(minutes: 40)),
        program: 'B.Tech ME',
        courseType: 'Core',
        roomBlock: 'C',
      ),
      OngoingClass(
        id: '4',
        course: 'CS202 - Database Systems',
        section: 'C',
        semester: '4th',
        room: 'LAB-CS1',
        faculty: 'Dr. Anitha Reddy',
        status: ClassStatus.roomChange,
        startTime: now.subtract(const Duration(minutes: 10)),
        endTime: now.add(const Duration(minutes: 50)),
        program: 'B.Tech CSE',
        courseType: 'Lab',
        roomBlock: 'A',
      ),
      OngoingClass(
        id: '5',
        course: 'EC301 - Communication Systems',
        section: 'A',
        semester: '6th',
        room: 'CR-501',
        faculty: 'Dr. Suresh Babu',
        status: ClassStatus.conflict,
        startTime: now.subtract(const Duration(minutes: 5)),
        endTime: now.add(const Duration(minutes: 55)),
        program: 'B.Tech ECE',
        courseType: 'Core',
        roomBlock: 'B',
      ),
    ];
  }

  @override
  Future<List<FreeFaculty>> getFreeFaculty() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    return [
      FreeFaculty(
        id: '1',
        name: 'Dr. Lakshmi Devi',
        department: 'Computer Science',
        nextClassTime: now.add(const Duration(hours: 2)),
        skills: ['CS101', 'CS201', 'Programming'],
        proximity: 'Block A',
      ),
      FreeFaculty(
        id: '2',
        name: 'Prof. Venkat Rao',
        department: 'Mathematics',
        nextClassTime: now.add(const Duration(hours: 1, minutes: 30)),
        skills: ['Math101', 'Statistics', 'Calculus'],
        proximity: 'Block B',
      ),
      FreeFaculty(
        id: '3',
        name: 'Dr. Sita Mahalakshmi',
        department: 'Electronics',
        nextClassTime: null,
        notes: 'Available all day',
        skills: ['EC101', 'EC201', 'Signals'],
        proximity: 'Block B',
      ),
      FreeFaculty(
        id: '4',
        name: 'Prof. Rajesh Kumar',
        department: 'Mechanical',
        nextClassTime: now.add(const Duration(hours: 3)),
        skills: ['ME101', 'Thermodynamics', 'Mechanics'],
        proximity: 'Block C',
      ),
      FreeFaculty(
        id: '5',
        name: 'Dr. Kavitha Priya',
        department: 'Computer Science',
        nextClassTime: now.add(const Duration(minutes: 45)),
        skills: ['CS101', 'Web Development', 'Database'],
        proximity: 'Block A',
      ),
    ];
  }

  @override
  Future<List<OngoingClass>> getVacantSlots() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final classes = await getOngoingClasses();
    return classes.where((c) => c.status == ClassStatus.vacant).toList();
  }
}
