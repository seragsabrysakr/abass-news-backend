import 'package:abass_news_app/features/issues/data/models/issue_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/issue_entity.dart';
import '../../domain/repositories/issue_repository.dart';
import '../datasources/issue_remote_datasource.dart';

@Injectable(as: IssueRepository)
class IssueRepositoryImpl implements IssueRepository {
  final IssueRemoteDataSource _remoteDataSource;

  IssueRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<IssueEntity>>> getAllIssues() async {
    try {
      final issues = await _remoteDataSource.getAllIssues();
      return Right(issues.map((issue) => issue.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IssueEntity>>> getUserIssues() async {
    try {
      final issues = await _remoteDataSource.getUserIssues();
      return Right(issues.map((issue) => issue.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IssueEntity>> createIssue({
    required String title,
    required String description,
    String? imageUrl,
    List<String>? attachments,
  }) async {
    try {
      final issue = await _remoteDataSource.createIssue(
        title: title,
        description: description,
        imageUrl: imageUrl,
        attachments: attachments,
      );
      return Right(issue.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IssueEntity>> updateIssueStatus({
    required int id,
    required IssueStatus status,
    String? adminNotes,
  }) async {
    try {
      final issue = await _remoteDataSource.updateIssueStatus(
        id: id,
        status: status,
        adminNotes: adminNotes,
      );
      return Right(issue.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
