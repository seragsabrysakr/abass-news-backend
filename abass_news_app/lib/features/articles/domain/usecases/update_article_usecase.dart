import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

@injectable
class UpdateArticleUseCase {
  final ArticleRepository repository;

  UpdateArticleUseCase(this.repository);

  Future<Either<Failure, ArticleEntity>> call({
    required int id,
    required String title,
    required String content,
    String? imageUrl,
    List<String>? tags,
  }) {
    return repository.updateArticle(
      id: id,
      title: title,
      content: content,
      imageUrl: imageUrl,
      tags: tags,
    );
  }
}
