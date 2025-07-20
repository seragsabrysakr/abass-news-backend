import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../models/article_model.dart';

@injectable
class ArticleRemoteDataSource {
  final ApiClient _apiClient;

  ArticleRemoteDataSource(this._apiClient);

  Future<List<ArticleModel>> getAllArticles() async {
    try {
      final response = await _apiClient.dio.get(AppConstants.articlesEndpoint);

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final articlesData = apiResponse.data['articles'] as List;
      return articlesData
          .map(
            (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch articles',
      );
    }
  }

  Future<ArticleModel> getArticleById(int id) async {
    try {
      final response = await _apiClient.dio.get(
        '${AppConstants.articlesEndpoint}/$id',
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final articleData = apiResponse.data['article'] as Map<String, dynamic>;
      return ArticleModel.fromJson(articleData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch article',
      );
    }
  }

  Future<ArticleModel> createArticle({
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.articlesEndpoint,
        data: {
          'title': title,
          'content': content,
          if (imageUrl != null) 'imageUrl': imageUrl,
          if (tags != null) 'tags': tags,
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final articleData = apiResponse.data['article'] as Map<String, dynamic>;
      return ArticleModel.fromJson(articleData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to create article',
      );
    }
  }

  Future<ArticleModel> updateArticle({
    required int id,
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '${AppConstants.articlesEndpoint}/$id',
        data: {
          'title': title,
          'content': content,
          if (imageUrl != null) 'imageUrl': imageUrl,
          if (tags != null) 'tags': tags,
        },
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }

      final articleData = apiResponse.data['article'] as Map<String, dynamic>;
      return ArticleModel.fromJson(articleData);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to update article',
      );
    }
  }

  Future<void> deleteArticle(int id) async {
    try {
      final response = await _apiClient.dio.delete(
        '${AppConstants.articlesEndpoint}/$id',
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.status) {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to delete article',
      );
    }
  }
}
