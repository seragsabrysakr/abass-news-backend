import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String token;
  final UserEntity user;

  const AuthEntity({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String username;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, username, role, createdAt, updatedAt];
}
