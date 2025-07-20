import 'package:abass_news/middleware/auth_middleware.dart';
import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/auth_service.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.delete) {
    return apiResponse(
        status: false, message: 'Method not allowed', statusCode: 405);
  }
  return AuthMiddleware.middleware(_deleteAccount)(context);
}

Future<Response> _deleteAccount(RequestContext context) async {
  await DatabaseService.initialize();
  final user = context.read<User>();
  final ok = await AuthService.deleteUser(user.id);
  if (!ok) {
    return apiResponse(
        status: false, message: 'Failed to delete account', statusCode: 500);
  }
  return apiResponse(status: true, message: 'Account deleted successfully');
}
