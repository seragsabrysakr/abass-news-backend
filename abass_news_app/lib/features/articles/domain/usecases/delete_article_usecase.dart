import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/article_repository.dart';

@injectable
class DeleteArticleUseCase {
  final ArticleRepository repository;

  DeleteArticleUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteArticle(id);
  }
}
