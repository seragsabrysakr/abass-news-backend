import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../models/auth_model.dart';

@injectable
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final responseData = apiResponse.data as Map<String, dynamic>;
      final authData = {
        'token': responseData['token'],
        'user': responseData['user'],
      };
      return AuthModel.fromJson(authData);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Login failed');
    }
  }

  Future<AuthModel> register(
    String name,
    String email,
    String password, {
    String? role,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.registerEndpoint,
        data: {
          'username': name,
          'email': email,
          'password': password,
          if (role != null) 'role': role,
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      try {
        final responseData = apiResponse.data as Map<String, dynamic>;
        final authData = {
          'token': responseData['token'],
          'user': responseData['user'],
        };
        return AuthModel.fromJson(authData);
      } catch (e, t) {
        log(e.toString());
        log(t.toString());

        throw Exception(apiResponse.message);
      }
    } on DioException catch (e, t) {
      log(e.toString());
      log(t.toString());

      throw Exception(e.response?.data?['message'] ?? 'Registration failed');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.forgotPasswordEndpoint,
        data: {'email': email},
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Forgot password failed');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.resetPasswordEndpoint,
        data: {'token': token, 'newPassword': newPassword},
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Reset password failed');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final response = await _apiClient.dio.delete(
        AppConstants.deleteAccountEndpoint,
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Delete account failed');
    }
  }
}
