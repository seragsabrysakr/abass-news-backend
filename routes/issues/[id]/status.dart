import 'package:abass_news/middleware/auth_middleware.dart';
import 'package:abass_news/models/issue.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/services/issue_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.put) {
    return apiResponse(
      status: false,
      message: 'Method not allowed',
      statusCode: 405,
    );
  }

  await DatabaseService.initialize();

  final issueId = int.tryParse(id);
  if (issueId == null) {
    return apiResponse(
      status: false,
      message: 'Invalid issue ID',
      statusCode: 400,
    );
  }

  return AuthMiddleware.adminOnly(
    (RequestContext context) => _updateIssueStatus(context, issueId),
  )(context);
}

Future<Response> _updateIssueStatus(RequestContext context, int id) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final statusParam = body['status'] as String?;
    final adminNotes = body['adminNotes'] as String?;

    if (statusParam == null) {
      return apiResponse(
        status: false,
        message: 'Status is required',
        statusCode: 400,
      );
    }

    IssueStatus status;
    try {
      status = IssueStatus.values
          .firstWhere((IssueStatus s) => s.name == statusParam);
    } catch (e) {
      return apiResponse(
        status: false,
        message: 'Invalid status value',
        statusCode: 400,
      );
    }

    final issue = await IssueService.updateIssueStatus(
      id: id,
      status: status,
      adminNotes: adminNotes,
    );

    if (issue == null) {
      return apiResponse(
        status: false,
        message: 'Issue not found',
        statusCode: 404,
      );
    }

    return apiResponse(
      status: true,
      message: 'Issue status updated successfully',
      data: {
        'issue': {
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
