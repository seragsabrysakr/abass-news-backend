import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

@injectable
class GetAllArticlesUseCase {
  final ArticleRepository repository;

  GetAllArticlesUseCase(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> call() {
    return repository.getAllArticles();
  }
}
