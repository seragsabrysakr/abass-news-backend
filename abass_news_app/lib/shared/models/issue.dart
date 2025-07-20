import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue.freezed.dart';
part 'issue.g.dart';

enum IssueStatus { pending, inProgress, resolved, rejected }

@freezed
class Issue with _$Issue {
  const factory Issue({
    required int id,
    required String title,
    required String description,
    required String userId,
    String? imageUrl,
    List<String>? attachments,
    required IssueStatus status,
    String? adminNotes,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
  }) = _Issue;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
