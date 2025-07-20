part of 'issue_bloc.dart';

abstract class IssueEvent extends Equatable {
  const IssueEvent();

  @override
  List<Object> get props => [];
}

class LoadAllIssues extends IssueEvent {}

class LoadUserIssues extends IssueEvent {}

class CreateIssue extends IssueEvent {
  final String title;
  final String description;
  final String? imageUrl;
  final List<String>? attachments;

  const CreateIssue({
    required this.title,
    required this.description,
    this.imageUrl,
    this.attachments,
  });

  @override
  List<Object> get props => [
    title,
    description,
    imageUrl ?? '',
    attachments ?? [],
  ];
}

class UpdateIssueStatus extends IssueEvent {
  final int id;
  final IssueStatus status;
  final String? adminNotes;

  const UpdateIssueStatus({
    required this.id,
    required this.status,
    this.adminNotes,
  });

  @override
  List<Object> get props => [id, status, adminNotes ?? ''];
}
