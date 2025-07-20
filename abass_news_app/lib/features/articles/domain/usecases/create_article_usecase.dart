import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

@injectable
class CreateArticleUseCase {
  final ArticleRepository repository;

  CreateArticleUseCase(this.repository);

  Future<Either<Failure, ArticleEntity>> call({
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  }) {
    return repository.createArticle(
      title: title,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
    );
  }
}
