import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/issue_entity.dart';

part 'issue_model.freezed.dart';
part 'issue_model.g.dart';

@freezed
class IssueModel with _$IssueModel {
  const factory IssueModel({
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
  }) = _IssueModel;

  factory IssueModel.fromJson(Map<String, dynamic> json) =>
      _$IssueModelFromJson(json);
}

// Extension to add toEntity method to generated class
extension IssueModelExtension on IssueModel {
  IssueEntity toEntity() {
    return IssueEntity(
      id: id,
      title: title,
      description: description,
      userId: userId,
      imageUrl: imageUrl,
      attachments: attachments,
      status: status,
      adminNotes: adminNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      resolvedAt: resolvedAt,
    );
  }
}
