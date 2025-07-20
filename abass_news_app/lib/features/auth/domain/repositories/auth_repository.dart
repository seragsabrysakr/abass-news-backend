import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> register(
    String name,
    String email,
    String password, {
    String? role,
  });
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthEntity?>> getCurrentUser();
  Future<Either<Failure, void>> saveToken(String token);
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, void>> clearToken();
}
