import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

String mapFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'That email address is not valid.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'email-already-in-use':
      return 'An account already exists for that email.';
    case 'weak-password':
      return 'Password should be at least 6 characters.';
    case 'operation-not-allowed':
      return 'Email/password sign-in is not enabled.';
    default:
      return e.message ?? 'Authentication failed.';
  }
}
