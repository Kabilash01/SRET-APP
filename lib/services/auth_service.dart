import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _rememberMeKey = 'rememberMe';
  static const String _savedEmailKey = 'savedEmail';
  static const String _userDisplayNameKey = 'userDisplayName';
  static const String _userPhotoUrlKey = 'userPhotoUrl';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    return isLoggedIn && rememberMe;
  }

  // Sign in with email and password
  static Future<bool> signInWithEmail(String email, String password, bool rememberMe) async {
    try {
      // Validate email domain
      if (!email.toLowerCase().endsWith('@sret.edu.in')) {
        throw Exception('Only @sret.edu.in emails are allowed');
      }
      
      // Simulate authentication
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // For demo purposes, accept any @sret.edu.in email/password
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setBool(_rememberMeKey, rememberMe);
      
      if (rememberMe) {
        await prefs.setString(_savedEmailKey, email);
        await prefs.setString(_userDisplayNameKey, email.split('@')[0]);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign in with Google
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account != null) {
        // Check if the email domain is @sret.edu.in
        if (!account.email.toLowerCase().endsWith('@sret.edu.in')) {
          // Sign out and show error
          await _googleSignIn.signOut();
          throw Exception('Only @sret.edu.in emails are allowed');
        }
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setBool(_rememberMeKey, true);
        await prefs.setString(_savedEmailKey, account.email);
        await prefs.setString(_userDisplayNameKey, account.displayName ?? account.email.split('@')[0]);
        await prefs.setString(_userPhotoUrlKey, account.photoUrl ?? '');
        
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Clear stored authentication data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Handle error silently for now
    }
  }

  // Get user info
  static Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_savedEmailKey) ?? 'user@sret.edu.in',
      'displayName': prefs.getString(_userDisplayNameKey) ?? 'SRET User',
      'photoUrl': prefs.getString(_userPhotoUrlKey) ?? '',
    };
  }

  // Get saved email for "Remember me" functionality
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (rememberMe) {
      return prefs.getString(_savedEmailKey);
    }
    return null;
  }

  // Send password reset email (mock)
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Simulate sending reset email
      await Future.delayed(const Duration(milliseconds: 2000));
      return true;
    } catch (e) {
      return false;
    }
  }
}
