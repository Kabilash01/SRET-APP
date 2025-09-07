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
        status: ClassStatus.running,
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
        facultyName: null,
        status: ClassStatus.vacant,
        startTime: '10:00',
        endTime: '11:00',
        vacantMinutes: 7,
        program: 'B.Tech EEE',
        courseType: 'Core',
        roomBlock: 'B',
      ),
      OngoingClass(
        id: '3',
        course: 'ME301',
        subject: 'Thermodynamics',
        section: 'A',
        semester: '5th',
        room: 'CR-401',
        faculty: 'Prof. Ravi Kumar',
        facultyName: 'Prof. Ravi Kumar',
        status: ClassStatus.delay,
        startTime: '11:00',
        endTime: '12:00',
        program: 'B.Tech ME',
        courseType: 'Core',
        roomBlock: 'C',
      ),
      OngoingClass(
        id: '4',
        course: 'CS202',
        subject: 'Database Systems',
        section: 'C',
        semester: '4th',
        room: 'LAB-CS1',
        faculty: 'Dr. Anitha Reddy',
        facultyName: 'Dr. Anitha Reddy',
        status: ClassStatus.roomChange,
        startTime: '12:00',
        endTime: '13:00',
        program: 'B.Tech CSE',
        courseType: 'Lab',
        roomBlock: 'A',
      ),
      OngoingClass(
        id: '5',
        course: 'EC301',
        subject: 'Communication Systems',
        section: 'A',
        semester: '6th',
        room: 'CR-501',
        faculty: 'Dr. Suresh Babu',
        facultyName: 'Dr. Suresh Babu',
        status: ClassStatus.conflict,
        startTime: '13:00',
        endTime: '14:00',
        program: 'B.Tech ECE',
        courseType: 'Core',
        roomBlock: 'B',
      ),
      OngoingClass(
        id: '6',
        course: 'CS303',
        subject: 'Operating Systems',
        section: 'B',
        semester: '5th',
        room: 'CR-502',
        faculty: 'Dr. Vikram Singh',
        facultyName: 'Dr. Vikram Singh',
        status: ClassStatus.scheduled,
        startTime: '14:00',
        endTime: '15:00',
        program: 'B.Tech CSE',
        courseType: 'Core',
        roomBlock: 'B',
      ),
    ];
  }

  @override
  Future<List<FreeFaculty>> getFreeFaculty() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      FreeFaculty(
        id: 'f1',
        name: 'Dr. Rajesh Kumar',
        department: 'Computer Science',
        nextClassTime: DateTime.now().add(const Duration(hours: 2)),
        skills: ['Python', 'Data Structures', 'Algorithms'],
        proximity: 'Same Floor',
        notes: 'Available for emergency assignments',
      ),
      FreeFaculty(
        id: 'f2',
        name: 'Prof. Meena Patel',
        department: 'Mathematics',
        nextClassTime: null,
        skills: ['Calculus', 'Statistics', 'Linear Algebra'],
        proximity: 'Adjacent Block',
      ),
      FreeFaculty(
        id: 'f3',
        name: 'Dr. Arjun Reddy',
        department: 'Electronics',
        nextClassTime: DateTime.now().add(const Duration(hours: 3)),
        skills: ['Digital Circuits', 'Microprocessors'],
        proximity: 'Same Floor',
        notes: 'Prefers technical subjects',
      ),
      FreeFaculty(
        id: 'f4',
        name: 'Prof. Kavitha Nair',
        department: 'Mechanical Engineering',
        nextClassTime: DateTime.now().add(const Duration(hours: 1)),
        skills: ['Thermodynamics', 'Heat Transfer'],
        proximity: 'Different Block',
      ),
      FreeFaculty(
        id: 'f5',
        name: 'Dr. Sunil Gupta',
        department: 'Electrical Engineering',
        nextClassTime: null,
        skills: ['Circuit Analysis', 'Power Systems'],
        proximity: 'Same Floor',
        notes: 'Available all day',
      ),
    ];
  }

  @override
  Future<List<OngoingClass>> getVacantSlots() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final allClasses = await getOngoingClasses();
    return allClasses.where((c) => c.status == ClassStatus.vacant).toList();
  }
}
