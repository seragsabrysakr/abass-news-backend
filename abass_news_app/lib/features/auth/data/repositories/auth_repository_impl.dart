import 'dart:developer';

import 'package:abass_news_app/features/auth/data/models/auth_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final ApiClient _apiClient;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._apiClient,
  );

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final authModel = await _remoteDataSource.login(email, password);

      // Save token and user data, then set token in API client
      await _localDataSource.saveToken(authModel.token);
      await _localDataSource.saveUser({
        'id': authModel.user.id,
        'email': authModel.user.email,
        'username': authModel.user.username,
        'role': authModel.user.role,
      });
      _apiClient.setAuthToken(authModel.token);

      return Right(authModel.toEntity());
    } catch (e, t) {
      log(e.toString());
      log(t.toString());

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(
    String name,
    String email,
    String password, {
    String? role,
  }) async {
    try {
      final authModel = await _remoteDataSource.register(
        name,
        email,
        password,
        role: role,
      );

      // Save token and user data, then set token in API client
      await _localDataSource.saveToken(authModel.token);
      await _localDataSource.saveUser({
        'id': authModel.user.id,
        'email': authModel.user.email,
        'username': authModel.user.username,
        'role': authModel.user.role,
      });
      _apiClient.setAuthToken(authModel.token);

      return Right(authModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      await _remoteDataSource.resetPassword(token, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearToken();
      await _localDataSource.clearUser();
      _apiClient.removeAuthToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    try {
      final token = await _localDataSource.getToken();
      final userData = await _localDataSource.getUser();

      if (token == null || userData == null) {
        return const Right(null);
      }

      // Set token in API client
      _apiClient.setAuthToken(token);

      // Create AuthEntity from stored user data
      final userEntity = UserEntity(
        id: userData['id'] as int,
        email: userData['email'] as String,
        username: userData['username'] as String,
        role: userData['role'] as String,
      );

      final authEntity = AuthEntity(token: token, user: userEntity);
      return Right(authEntity);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _localDataSource.saveToken(token);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await _localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearToken() async {
    try {
      await _localDataSource.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
