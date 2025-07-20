import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/issue_entity.dart';
import '../repositories/issue_repository.dart';

@injectable
class CreateIssueUseCase {
  final IssueRepository repository;

  CreateIssueUseCase(this.repository);

  Future<Either<Failure, IssueEntity>> call({
    required String title,
    required String description,
    String? imageUrl,
    List<String>? attachments,
  }) {
    return repository.createIssue(
      title: title,
      description: description,
      imageUrl: imageUrl,
      attachments: attachments,
    );
  }
}
