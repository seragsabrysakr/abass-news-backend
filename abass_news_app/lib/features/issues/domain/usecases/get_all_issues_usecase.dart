import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/issue_entity.dart';
import '../repositories/issue_repository.dart';

@injectable
class GetAllIssuesUseCase {
  final IssueRepository repository;

  GetAllIssuesUseCase(this.repository);

  Future<Either<Failure, List<IssueEntity>>> call() {
    return repository.getAllIssues();
  }
}
