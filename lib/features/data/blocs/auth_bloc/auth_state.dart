part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthenticatingUser extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel userModel;

  const AuthSuccess({required this.userModel});
  @override
  List<Object> get props => [userModel];
}

final class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class LoggingOut extends AuthState {}

final class LogoutSuccess extends AuthState {
  final String message;

  const LogoutSuccess({required this.message});
}

final class LogoutFailure extends AuthState {
  final String errorMessage;

  const LogoutFailure({required this.errorMessage});
}
