import 'package:abass_news/services/auth_service.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return apiResponse(
        status: false, message: 'Method not allowed', statusCode: 405);
  }
  await DatabaseService.initialize();
  final body = await context.request.json() as Map<String, dynamic>;
  final token = body['token'] as String?;
  final newPassword = body['newPassword'] as String?;
  if (token == null || newPassword == null) {
    return apiResponse(
        status: false,
        message: 'Token and newPassword are required',
        statusCode: 400);
  }
  if (newPassword.length < 6) {
    return apiResponse(
        status: false,
        message: 'Password must be at least 6 characters long',
        statusCode: 400);
  }
  final ok =
      await AuthService.resetPassword(token: token, newPassword: newPassword);
  if (!ok) {
    return apiResponse(
        status: false, message: 'Invalid or expired token', statusCode: 400);
  }
  return apiResponse(status: true, message: 'Password reset successful');
}
