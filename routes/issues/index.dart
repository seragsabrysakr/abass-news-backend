import 'package:abass_news/middleware/auth_middleware.dart';
import 'package:abass_news/models/issue.dart';
import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/services/issue_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  await DatabaseService.initialize();

  switch (context.request.method) {
    case HttpMethod.get:
      return AuthMiddleware.adminOnly(_getAllIssues)(context);
    case HttpMethod.post:
      return AuthMiddleware.middleware(_createIssue)(context);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return apiResponse(
        status: false,
        message: 'Method not allowed',
        statusCode: 405,
      );
  }
}

Future<Response> _getAllIssues(RequestContext context) async {
  try {
    final queryParams = context.request.uri.queryParameters;
    final statusParam = queryParams['status'];

    IssueStatus? status;
    if (statusParam != null) {
      status = IssueStatus.values.firstWhere(
        (IssueStatus s) => s.name == statusParam,
        orElse: () => IssueStatus.pending,
      );
    }

    final issues = await IssueService.getAllIssues(status: status);

    return apiResponse(
      status: true,
      message: 'Issues retrieved successfully',
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

Future<Response> _createIssue(RequestContext context) async {
  try {
    final user = context.read<User>();
    final body = await context.request.json() as Map<String, dynamic>;

    final title = body['title'] as String?;
    final description = body['description'] as String?;
    final imageUrl = body['imageUrl'] as String?;
    final attachments = (body['attachments'] as List<dynamic>?)?.cast<String>();

    if (title == null || description == null) {
      return apiResponse(
        status: false,
        message: 'Title and description are required',
        statusCode: 400,
      );
    }

    final issue = await IssueService.createIssue(
      title: title,
      description: description,
      userId: user.id.toString(),
      imageUrl: imageUrl,
      attachments: attachments,
    );

    return apiResponse(
      status: true,
      message: 'Issue created successfully',
      statusCode: 201,
      data: {
        'issue': {
          'id': issue.id,
          'title': issue.title,
          'description': issue.description,
          'userId': issue.userId,
          'imageUrl': issue.imageUrl,
          'attachments': issue.attachments,
          'status': issue.status.name,
          'createdAt': issue.createdAt.toIso8601String(),
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
