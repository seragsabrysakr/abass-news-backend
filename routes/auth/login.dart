import 'package:abass_news/services/auth_service.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return apiResponse(
        status: false, message: 'Method not allowed', statusCode: 405);
  }

  try {
    await DatabaseService.initialize();
    final body = await context.request.json() as Map<String, dynamic>;
    final email = body['email'] as String?;
    final password = body['password'] as String?;
    if (email == null || password == null) {
      return apiResponse(
          status: false,
          message: 'Email and password are required',
          statusCode: 400);
    }
    final user = await AuthService.authenticateUser(email, password);
    if (user == null) {
      return apiResponse(
          status: false, message: 'Invalid email or password', statusCode: 401);
    }
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
      message: 'Login successful',
    );
  } catch (e) {
    return apiResponse(
        status: false, message: 'Internal server error: $e', statusCode: 500);
  }
}
