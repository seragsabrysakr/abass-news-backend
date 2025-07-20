import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/article_entity.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<ArticleEntity>>> getAllArticles();
  Future<Either<Failure, ArticleEntity>> getArticleById(int id);
  Future<Either<Failure, ArticleEntity>> createArticle({
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  });
  Future<Either<Failure, ArticleEntity>> updateArticle({
    required int id,
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  });
  Future<Either<Failure, void>> deleteArticle(int id);
}
