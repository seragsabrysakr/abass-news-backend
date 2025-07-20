import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/auth_service.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return apiResponse(
      status: false,
      message: 'Method not allowed',
      statusCode: 405,
    );
  }

  try {
    await DatabaseService.initialize();
    final body = await context.request.json() as Map<String, dynamic>;
    final email = body['email'] as String?;
    final username = body['username'] as String?;
    final password = body['password'] as String?;
    final role = body['role'] as String?; // Optional role parameter

    if (email == null || username == null || password == null) {
      return apiResponse(
        status: false,
        message: 'Email, username, and password are required',
        statusCode: 400,
      );
    }
    if (password.length < 6) {
      return apiResponse(
        status: false,
        message: 'Password must be at least 6 characters long',
        statusCode: 400,
      );
    }
    // Check if user already exists
    final existingUser = await AuthService.authenticateUser(email, password);
    if (existingUser != null) {
      return apiResponse(
        status: false,
        message: 'User already exists',
        statusCode: 409,
      );
    }
    // Parse role from string to UserRole enum
    var userRole = UserRole.user; // Default to user
    if (role != null) {
      try {
        userRole =
            UserRole.values.firstWhere((r) => r.name == role.toLowerCase());
      } catch (e) {
        // If invalid role provided, default to user
        userRole = UserRole.user;
      }
    }

    final user = await AuthService.createUser(
      email: email,
      username: username,
      password: password,
      role: userRole,
    );
    final token = AuthService.generateToken(user);
    return apiResponse(
      status: true,
      data: {
        'user': {
          'id': user.id,
          'email': user.email,
          'username': user.username,
          'role': user.role.name,
        },
        'token': token,
      },
      message: 'User registered successfully',
      statusCode: 201,
    );
  } catch (e) {
    return apiResponse(
      status: false,
      message: 'Internal server error: $e',
      statusCode: 500,
    );
  }
}
