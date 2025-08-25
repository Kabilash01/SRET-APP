import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fake_auth_repo.dart';

final fakeAuthRepoProvider = Provider<FakeAuthRepo>((ref) {
  return FakeAuthRepo();
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<User?> {
  late final FakeAuthRepo _authRepo;

  @override
  Future<User?> build() async {
    _authRepo = ref.read(fakeAuthRepoProvider);
    return _authRepo.currentUser;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    
    try {
      final user = await _authRepo.signInWithGoogle();
      state = AsyncData(user);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    
    try {
      await _authRepo.signOut();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
