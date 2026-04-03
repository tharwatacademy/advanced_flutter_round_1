import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

import '../../../data/firebase_auth_error_mapper.dart';
import '../../../domain/auth_repo.dart';

part 'auth_state.dart';

/// Handles sign-in / register / sign-out calls only. Does **not** listen to
/// [AuthRepo.authStateChanges]; use [StreamBuilder] (or similar) for session routing.
class AuthCubit extends Cubit<AuthOperationState> {
  AuthCubit({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(const AuthOperationInitial());

  final AuthRepo _authRepo;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthOperationLoading());
    try {
      await _authRepo.signInWithEmail(email: email, password: password);
      emit(AuthOperationSuccess());
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthOperationFailure(message: mapFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthOperationFailure(message: e.toString()));
    }
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthOperationLoading());
    try {
      await _authRepo.registerWithEmail(email: email, password: password);
      emit(AuthOperationSuccess());
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthOperationFailure(message: mapFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthOperationFailure(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(const AuthOperationLoading());
    try {
      await _authRepo.signOut();
      emit(AuthOperationSuccess());
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthOperationFailure(message: mapFirebaseAuthException(e)));
    } catch (e) {
      emit(AuthOperationFailure(message: e.toString()));
    }
  }

  void clearFailure() {
    if (state is AuthOperationFailure) {
      emit(const AuthOperationInitial());
    }
  }

  void clearSuccess() {
    if (state is AuthOperationSuccess) {
      emit(const AuthOperationInitial());
    }
  }
}
