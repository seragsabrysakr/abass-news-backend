import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/issue_entity.dart';

abstract class IssueRepository {
  Future<Either<Failure, List<IssueEntity>>> getAllIssues();
  Future<Either<Failure, List<IssueEntity>>> getUserIssues();
  Future<Either<Failure, IssueEntity>> createIssue({
    required String title,
    required String description,
    String? imageUrl,
    List<String>? attachments,
  });
  Future<Either<Failure, IssueEntity>> updateIssueStatus({
    required int id,
    required IssueStatus status,
    String? adminNotes,
  });
}
