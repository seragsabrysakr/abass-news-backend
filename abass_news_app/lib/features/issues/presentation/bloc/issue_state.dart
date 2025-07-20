part of 'issue_bloc.dart';

abstract class IssueState extends Equatable {
  const IssueState();

  @override
  List<Object> get props => [];
}

class IssueInitial extends IssueState {}

class IssueLoading extends IssueState {}

class IssuesLoaded extends IssueState {
  final List<IssueEntity> issues;

  const IssuesLoaded(this.issues);

  @override
  List<Object> get props => [issues];
}

class UserIssuesLoaded extends IssueState {
  final List<IssueEntity> issues;

  const UserIssuesLoaded(this.issues);

  @override
  List<Object> get props => [issues];
}

class IssueCreated extends IssueState {
  final IssueEntity issue;

  const IssueCreated(this.issue);

  @override
  List<Object> get props => [issue];
}

class IssueStatusUpdated extends IssueState {
  final IssueEntity issue;

  const IssueStatusUpdated(this.issue);

  @override
  List<Object> get props => [issue];
}

class IssueError extends IssueState {
  final String message;

  const IssueError(this.message);

  @override
  List<Object> get props => [message];
}
