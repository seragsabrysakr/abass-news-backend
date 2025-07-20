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
  final email = body['email'] as String?;
  if (email == null) {
    return apiResponse(
        status: false, message: 'Email is required', statusCode: 400);
  }
  final token = await AuthService.createPasswordResetToken(email);
  if (token == null) {
    return apiResponse(
        status: false, message: 'User not found', statusCode: 404);
  }
  // In production, you would email the token to the user
  return apiResponse(
      status: true,
      data: {'resetToken': token},
      message: 'Password reset token generated');
}
