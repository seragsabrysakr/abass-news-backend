part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? role;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.role,
  });

  @override
  List<Object> get props => [name, email, password, role ?? ''];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
