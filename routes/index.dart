import 'package:abass_news/services/database_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    // Try to initialize database
    await DatabaseService.initialize();

    return Response.json(
      body: {
        'status': 'healthy',
        'message': 'Welcome to Abass News API',
        'version': '1.0.0',
        'database': 'connected',
        'endpoints': {
          'auth': {
            'POST /auth/register': 'Register a new user',
            'POST /auth/login': 'Login user',
          },
          'articles': {
            'GET /articles': 'Get all published articles',
            'GET /articles/{id}': 'Get article by ID',
            'POST /articles': 'Create new article (Admin only)',
            'PUT /articles/{id}': 'Update article (Admin only)',
            'DELETE /articles/{id}': 'Delete article (Admin only)',
          },
          'issues': {
            'GET /issues': 'Get all issues (Admin only)',
            'GET /issues/user': 'Get user issues (Authenticated)',
            'POST /issues': 'Create new issue (Authenticated)',
            'PUT /issues/{id}/status': 'Update issue status (Admin only)',
          },
        },
      },
    );
  } catch (e) {
    // Return a response even if database fails
    return Response.json(
      body: {
        'status': 'degraded',
        'message': 'Welcome to Abass News API',
        'version': '1.0.0',
        'database': 'disconnected',
        'error': e.toString(),
        'note': 'API is running but database connection failed',
      },
    );
  }
}
