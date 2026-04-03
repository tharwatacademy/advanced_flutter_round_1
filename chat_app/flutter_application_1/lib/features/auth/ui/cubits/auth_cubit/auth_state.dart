part of 'auth_cubit.dart';

@immutable
sealed class AuthOperationState {
  const AuthOperationState();
}

final class AuthOperationInitial extends AuthOperationState {
  const AuthOperationInitial();
}

final class AuthOperationLoading extends AuthOperationState {
  const AuthOperationLoading();
}

final class AuthOperationSuccess extends AuthOperationState {}

final class AuthOperationFailure extends AuthOperationState {
  const AuthOperationFailure({required this.message});
  final String message;
}
