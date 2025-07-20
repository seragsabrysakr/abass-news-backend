import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/issue_entity.dart';
import '../repositories/issue_repository.dart';

@injectable
class UpdateIssueStatusUseCase {
  final IssueRepository repository;

  UpdateIssueStatusUseCase(this.repository);

  Future<Either<Failure, IssueEntity>> call({
    required int id,
    required IssueStatus status,
    String? adminNotes,
  }) {
    return repository.updateIssueStatus(
      id: id,
      status: status,
      adminNotes: adminNotes,
    );
  }
}
