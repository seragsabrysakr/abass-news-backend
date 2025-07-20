import 'package:abass_news_app/features/articles/data/models/article_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_remote_datasource.dart';

@Injectable(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource _remoteDataSource;

  ArticleRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ArticleEntity>>> getAllArticles() async {
    try {
      final articles = await _remoteDataSource.getAllArticles();
      return Right(articles.map((article) => article.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> getArticleById(int id) async {
    try {
      final article = await _remoteDataSource.getArticleById(id);
      return Right(article.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> createArticle({
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  }) async {
    try {
      final article = await _remoteDataSource.createArticle(
        title: title,
        content: content,
        imageUrl: imageUrl,
        tags: tags,
      );
      return Right(article.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> updateArticle({
    required int id,
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  }) async {
    try {
      final article = await _remoteDataSource.updateArticle(
        id: id,
        title: title,
        content: content,
        imageUrl: imageUrl,
        tags: tags,
      );
      return Right(article.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteArticle(int id) async {
    try {
      await _remoteDataSource.deleteArticle(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
