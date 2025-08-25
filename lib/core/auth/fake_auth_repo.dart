import 'dart:math';

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

  User? get currentUser => _currentUser;
}
