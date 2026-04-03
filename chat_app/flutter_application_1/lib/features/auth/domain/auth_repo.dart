import 'auth_user.dart';

abstract class AuthRepo {
  Stream<AppUser?> get authStateChanges;

  Future<void> signInWithEmail({required String email, required String password});

  Future<void> registerWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
