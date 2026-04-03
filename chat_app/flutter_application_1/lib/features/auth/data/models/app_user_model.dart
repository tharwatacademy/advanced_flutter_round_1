import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Domain snapshot of the signed-in user, with Firebase mapping.
class AppUser {
  const AppUser({required this.uid, this.email});

  final String uid;
  final String? email;

  factory AppUser.fromFirebaseUser(firebase_auth.User user) {
    return AppUser(uid: user.uid, email: user.email);
  }

  static AppUser? fromFirebaseUserOrNull(firebase_auth.User? user) {
    if (user == null) return null;
    return AppUser.fromFirebaseUser(user);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
