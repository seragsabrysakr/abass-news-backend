import 'package:equatable/equatable.dart';

enum IssueStatus { pending, inProgress, resolved, rejected }

class IssueEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String userId;
  final String? imageUrl;
  final List<String>? attachments;
  final IssueStatus status;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;

  const IssueEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    this.imageUrl,
    this.attachments,
    required this.status,
    this.adminNotes,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    userId,
    imageUrl,
    attachments,
    status,
    adminNotes,
    createdAt,
    updatedAt,
    resolvedAt,
  ];
}
