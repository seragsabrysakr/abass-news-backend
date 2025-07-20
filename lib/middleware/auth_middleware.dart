import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/auth_service.dart';
import 'package:dart_frog/dart_frog.dart';

class AuthMiddleware {
  static Handler middleware(Handler handler) {
    return (context) async {
      final request = context.request;
      final authHeader = request.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(
          statusCode: 401,
          body: '{"error": "Authentication required"}',
          headers: {'content-type': 'application/json'},
        );
      }

      final token = authHeader.substring(7);
      final payload = AuthService.verifyToken(token);

      if (payload == null) {
        return Response(
          statusCode: 401,
          body: '{"error": "Invalid or expired token"}',
          headers: {'content-type': 'application/json'},
        );
      }

      final userId = payload['userId'] as int;
      final user = await AuthService.getUserById(userId);

      if (user == null) {
        return Response(
          statusCode: 401,
          body: '{"error": "User not found"}',
          headers: {'content-type': 'application/json'},
        );
      }

      // Add user to context
      final updatedContext = context.provide<User>(() => user);
      return handler(updatedContext);
    };
  }

  static Handler adminOnly(Handler handler) {
    return middleware((context) async {
      final user = context.read<User>();

      if (user.role != UserRole.admin) {
        return Response(
          statusCode: 403,
          body: '{"error": "Admin access required"}',
          headers: {'content-type': 'application/json'},
        );
      }

      return handler(context);
    });
  }
}
