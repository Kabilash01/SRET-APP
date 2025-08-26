final sretEmailRegex = RegExp(r'^[A-Za-z0-9._%+-]+@sret\.edu\.in$', caseSensitive: false);

String? validateSretEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final email = value.trim().toLowerCase();
  if (!sretEmailRegex.hasMatch(email)) {
    return 'Please enter a valid @sret.edu.in email';
  }
  return null;
}

String? validateNotEmpty(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
  if (digitsOnly.length < 10 || digitsOnly.length > 15) {
    return 'Phone number must be 10-15 digits';
  }
  return null;
}

String? validateEmpId(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Employee ID is required';
  }
  final empIdRegex = RegExp(r'^[A-Za-z0-9_-]{3,20}$');
  if (!empIdRegex.hasMatch(value.trim())) {
    return 'Employee ID must be 3-20 characters (letters, numbers, _, -)';
  }
  return null;
}

String? validateFullName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Full name is required';
  }
  if (value.trim().length < 3) {
    return 'Name must be at least 3 characters';
  }
  return null;
}
