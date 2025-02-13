part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

final class LogoutRequested extends AuthEvent {
  final int id;

  const LogoutRequested({required this.id});
}
