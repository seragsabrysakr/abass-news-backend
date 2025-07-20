import 'package:abass_news/middleware/auth_middleware.dart';
import 'package:abass_news/services/article_service.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:abass_news/utils/response.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  await DatabaseService.initialize();
  final articleId = int.tryParse(id);
  if (articleId == null) {
    return apiResponse(
        status: false, message: 'Invalid article ID', statusCode: 400);
  }
  switch (context.request.method) {
    case HttpMethod.get:
      return _getArticle(context, articleId);
    case HttpMethod.put:
      return AuthMiddleware.adminOnly((RequestContext context) =>
          _updateArticle(context, articleId))(context);
    case HttpMethod.delete:
      return AuthMiddleware.adminOnly((RequestContext context) =>
          _deleteArticle(context, articleId))(context);
    case HttpMethod.post:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return apiResponse(
          status: false, message: 'Method not allowed', statusCode: 405);
  }
}

Future<Response> _getArticle(RequestContext context, int id) async {
  try {
    final article = await ArticleService.getArticleById(id);
    if (article == null) {
      return apiResponse(
          status: false, message: 'Article not found', statusCode: 404);
    }
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
          'updatedAt': article.updatedAt?.toIso8601String(),
          'publishedAt': article.publishedAt?.toIso8601String(),
        },
      },
      message: 'Article fetched successfully',
    );
  } catch (e) {
    return apiResponse(
        status: false, message: 'Internal server error: $e', statusCode: 500);
  }
}

Future<Response> _updateArticle(RequestContext context, int id) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final title = body['title'] as String?;
    final content = body['content'] as String?;
    final summary = body['summary'] as String?;
    final imageUrl = body['imageUrl'] as String?;
    final tags = (body['tags'] as List<dynamic>?)?.cast<String>();
    final isPublished = body['isPublished'] as bool?;
    final article = await ArticleService.updateArticle(
      id: id,
      title: title,
      content: content,
      summary: summary,
      imageUrl: imageUrl,
      tags: tags,
      isPublished: isPublished,
    );
    if (article == null) {
      return apiResponse(
          status: false, message: 'Article not found', statusCode: 404);
    }
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
          'updatedAt': article.updatedAt?.toIso8601String(),
          'publishedAt': article.publishedAt?.toIso8601String(),
        },
      },
      message: 'Article updated successfully',
    );
  } catch (e) {
    return apiResponse(
        status: false, message: 'Internal server error: $e', statusCode: 500);
  }
}

Future<Response> _deleteArticle(RequestContext context, int id) async {
  try {
    final deleted = await ArticleService.deleteArticle(id);
    if (!deleted) {
      return apiResponse(
          status: false, message: 'Article not found', statusCode: 404);
    }
    return apiResponse(status: true, message: 'Article deleted successfully');
  } catch (e) {
    return apiResponse(
        status: false, message: 'Internal server error: $e', statusCode: 500);
  }
}
