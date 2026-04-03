import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_repo.dart';
import 'models/app_user_model.dart';

class FirebaseAuthRepoImpl implements AuthRepo {
  FirebaseAuthRepoImpl({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().map(AppUser.fromFirebaseUserOrNull);

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
