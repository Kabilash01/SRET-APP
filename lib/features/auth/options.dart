// Department and role constants for SRET authentication

const List<Map<String, String>> kDepartments = [
  {'code': 'E01', 'label': 'AIML'},
  {'code': 'E02', 'label': 'CYBER & IOT'},
  {'code': 'E03', 'label': 'AIDA'},
  {'code': 'E04', 'label': 'MEDICAL ENGINEERING'},
  {'code': 'E05', 'label': 'ECE'},
];

enum StaffRole {
  dean,
  viceDean,
  hod,
  facultyStaff,
  nonTeachingStaff,
  guestFaculty,
}

// Roles that don't require department selection
const List<StaffRole> kDeptOptional = [
  StaffRole.dean,
  StaffRole.viceDean,
];

// Helper extension to get display names for roles
extension StaffRoleExtension on StaffRole {
  String get displayName {
    switch (this) {
      case StaffRole.dean:
        return 'DEAN';
      case StaffRole.viceDean:
        return 'VICE DEAN';
      case StaffRole.hod:
        return 'HOD';
      case StaffRole.facultyStaff:
        return 'FACULTY STAFF';
      case StaffRole.nonTeachingStaff:
        return 'NON TEACHING STAFF';
      case StaffRole.guestFaculty:
        return 'GUEST FACULTY';
    }
  }
}

// Helper function to check if department is required for a role
bool isDepartmentRequired(StaffRole role) {
  return !kDeptOptional.contains(role);
}
