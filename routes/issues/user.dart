import 'package:abass_news/middleware/auth_middleware.dart';
import 'package:abass_news/models/issue.dart';
import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/services/issue_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return apiResponse(
      status: false,
      message: 'Method not allowed',
      statusCode: 405,
    );
  }

  return AuthMiddleware.middleware(_getUserIssues)(context);
}

Future<Response> _getUserIssues(RequestContext context) async {
  try {
    await DatabaseService.initialize();
    final user = context.read<User>();

    final issues = await IssueService.getUserIssues(user.id.toString());

    return apiResponse(
      status: true,
      message: 'User issues retrieved successfully',
      data: {
        'issues': issues
            .map(
              (Issue issue) => {
                'id': issue.id,
                'title': issue.title,
                'description': issue.description,
                'userId': issue.userId,
                'imageUrl': issue.imageUrl,
                'attachments': issue.attachments,
                'status': issue.status.name,
                'adminNotes': issue.adminNotes,
                'createdAt': issue.createdAt.toIso8601String(),
                'updatedAt': issue.updatedAt?.toIso8601String(),
                'resolvedAt': issue.resolvedAt?.toIso8601String(),
              },
            )
            .toList(),
      },
    );
  } catch (e) {
    return apiResponse(
      status: false,
      message: 'Internal server error: $e',
      statusCode: 500,
    );
  }
}
