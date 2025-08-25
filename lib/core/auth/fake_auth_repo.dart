import 'dart:math';
import '../../../features/auth/options.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ name.hashCode ^ photoUrl.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';
}

class FakeAuthRepo {
  User? _currentUser;
  final Random _random = Random();

  /// TODO: Replace with real Firebase/Google Sign-In implementation
  /// This would integrate with firebase_auth and google_sign_in packages
  /// Example:
  /// ```dart
  /// Future<User?> signInWithGoogle() async {
  ///   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  ///   if (googleUser == null) return null;
  ///   
  ///   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  ///   final credential = GoogleAuthProvider.credential(
  ///     accessToken: googleAuth.accessToken,
  ///     idToken: googleAuth.idToken,
  ///   );
  ///   
  ///   final UserCredential userCredential = 
  ///       await FirebaseAuth.instance.signInWithCredential(credential);
  ///   
  ///   return User(
  ///     id: userCredential.user!.uid,
  ///     email: userCredential.user!.email!,
  ///     name: userCredential.user!.displayName!,
  ///     photoUrl: userCredential.user!.photoURL,
  ///   );
  /// }
  /// ```
  Future<User?> signInWithGoogle() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(400)));
    
    // Simulate 10% failure rate
    if (_random.nextInt(10) == 0) {
      throw Exception('Sign-in failed');
    }
    
    // Mock successful sign-in
    final mockUsers = [
      const User(
        id: '1',
        email: 'john.doe@sret.edu',
        name: 'John Doe',
        photoUrl: null,
      ),
      const User(
        id: '2',
        email: 'jane.smith@sret.edu',
        name: 'Jane Smith',
        photoUrl: null,
      ),
      const User(
        id: '3',
        email: 'prof.wilson@sret.edu',
        name: 'Prof. Wilson',
        photoUrl: null,
      ),
    ];
    
    _currentUser = mockUsers[_random.nextInt(mockUsers.length)];
    return _currentUser;
  }

  /// TODO: Replace with real Firebase sign-out
  /// ```dart
  /// Future<void> signOut() async {
  ///   await Future.wait([
  ///     FirebaseAuth.instance.signOut(),
  ///     GoogleSignIn().signOut(),
  ///   ]);
  /// }
  /// ```
  Future<void> signOut() async {
    // Simulate sign-out delay
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  /// TODO: Replace with real password reset functionality
  /// ```dart
  /// Future<void> sendResetEmail(String email) async {
  ///   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  /// }
  /// ```
  Future<void> sendResetEmail(String email) async {
    // Simulate network delay for password reset
    await Future.delayed(const Duration(milliseconds: 900));
    // In real implementation, this would send an actual reset email
  }

  /// TODO: Replace with real user registration functionality
  /// ```dart
  /// Future<void> register({
  ///   required String name,
  ///   required String empId,
  ///   required String phone,
  ///   required String email,
  ///   required String password,
  ///   String? deptCode,
  ///   required StaffRole role,
  /// }) async {
  ///   final UserCredential userCredential = await FirebaseAuth.instance
  ///       .createUserWithEmailAndPassword(email: email, password: password);
  ///   
  ///   await userCredential.user?.updateDisplayName(name);
  ///   
  ///   // Store additional user data in Firestore
  ///   await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
  ///     'name': name,
  ///     'empId': empId,
  ///     'phone': phone,
  ///     'email': email,
  ///     'deptCode': deptCode,
  ///     'role': role.name,
  ///     'createdAt': FieldValue.serverTimestamp(),
  ///   });
  /// }
  /// ```
  Future<void> register({
    required String name,
    required String empId,
    required String phone,
    required String email,
    required String password,
    String? deptCode,
    required StaffRole role,
  }) async {
    // Simulate network delay for registration
    await Future.delayed(const Duration(milliseconds: 900));
    
    // Simulate 5% failure rate
    if (_random.nextInt(20) == 0) {
      throw Exception('Registration failed');
    }
    
    // Mock successful registration - create new user
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email.toLowerCase(),
      name: name,
      photoUrl: null,
    );
    
    // In real implementation, additional user data (empId, phone, deptCode, role) 
    // would be stored in a database like Firestore
  }

  /// TODO: Replace with real account creation functionality
  /// ```dart
  /// Future<void> createAccount({
  ///   required String fullName,
  ///   required String employeeId,
  ///   required String phoneNumber,
  ///   required String email,
  ///   required String password,
  ///   required String department,
  ///   required String role,
  /// }) async {
  ///   final UserCredential userCredential = await FirebaseAuth.instance
  ///       .createUserWithEmailAndPassword(email: email, password: password);
  ///   
  ///   await userCredential.user?.updateDisplayName(fullName);
  ///   
  ///   // Store additional user data in Firestore
  ///   await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
  ///     'fullName': fullName,
  ///     'employeeId': employeeId,
  ///     'phoneNumber': phoneNumber,
  ///     'email': email,
  ///     'department': department,
  ///     'role': role,
  ///     'createdAt': FieldValue.serverTimestamp(),
  ///   });
  /// }
  /// ```
  Future<void> createAccount({
    required String fullName,
    required String employeeId,
    required String phoneNumber,
    required String email,
    required String password,
    required String department,
    required String role,
  }) async {
    // Simulate network delay for account creation
    await Future.delayed(const Duration(milliseconds: 900));
    
    // Simulate 5% failure rate
    if (_random.nextInt(20) == 0) {
      throw Exception('Account creation failed');
    }
    
    // In real implementation, this would create an account in Firebase/backend
    // For now, we just simulate the delay and success
  }

  User? get currentUser => _currentUser;
}
