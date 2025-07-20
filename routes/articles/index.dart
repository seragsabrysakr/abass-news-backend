import 'package:abass_news/middleware/auth_middleware.dart';
import 'package:abass_news/models/article.dart';
import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/article_service.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  await DatabaseService.initialize();

  switch (context.request.method) {
    case HttpMethod.get:
      return _getArticles(context);
    case HttpMethod.post:
      return AuthMiddleware.adminOnly(_createArticle)(context);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return apiResponse(
          status: false, message: 'Method not allowed', statusCode: 405);
  }
}

Future<Response> _getArticles(RequestContext context) async {
  try {
    final articles = await ArticleService.getAllArticles();
    return apiResponse(
      status: true,
      data: {
        'articles': articles
            .map(
              (Article article) => {
                'id': article.id,
                'title': article.title,
                'content': article.content,
                'summary': article.summary,
                'imageUrl': article.imageUrl,
                'tags': article.tags,
                'authorId': article.authorId,
                'createdAt': article.createdAt.toIso8601String(),
                'publishedAt': article.publishedAt?.toIso8601String(),
              },
            )
            .toList(),
      },
      message: 'Articles fetched successfully',
    );
  } catch (e) {
    return apiResponse(
        status: false, message: 'Internal server error: $e', statusCode: 500);
  }
}

Future<Response> _createArticle(RequestContext context) async {
  try {
    final user = context.read<User>();
    final body = await context.request.json() as Map<String, dynamic>;
    final title = body['title'] as String?;
    final content = body['content'] as String?;
    final summary = body['summary'] as String?;
    final imageUrl = body['imageUrl'] as String?;
    final tags = (body['tags'] as List<dynamic>?)?.cast<String>();
    final isPublished = body['isPublished'] as bool? ?? false;
    if (title == null || content == null) {
      return apiResponse(
          status: false,
          message: 'Title and content are required',
          statusCode: 400);
    }
    final article = await ArticleService.createArticle(
      title: title,
      content: content,
      authorId: user.id.toString(),
      summary: summary,
      imageUrl: imageUrl,
      tags: tags,
      isPublished: isPublished,
    );
    return apiResponse(
      status: true,
      data: {
        'article': {
          'id': article.id,
          'title': article.title,
          'content': article.content,
          'summary': article.summary,
          'imageUrl': article.imageUrl,
          'tags': article.tags,
          'authorId': article.authorId,
          'isPublished': article.isPublished,
          'createdAt': article.createdAt.toIso8601String(),
        },
      },
      message: 'Article created successfully',
      statusCode: 201,
    );
  } catch (e) {
    return apiResponse(
        status: false, message: 'Internal server error: $e', statusCode: 500);
  }
}
