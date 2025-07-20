import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

@injectable
class GetArticleByIdUseCase {
  final ArticleRepository repository;

  GetArticleByIdUseCase(this.repository);

  Future<Either<Failure, ArticleEntity>> call(int id) {
    return repository.getArticleById(id);
  }
}
