// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IssueModelImpl _$$IssueModelImplFromJson(Map<String, dynamic> json) =>
    _$IssueModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      imageUrl: json['imageUrl'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecode(_$IssueStatusEnumMap, json['status']),
      adminNotes: json['adminNotes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$IssueModelImplToJson(_$IssueModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
      'attachments': instance.attachments,
      'status': _$IssueStatusEnumMap[instance.status]!,
      'adminNotes': instance.adminNotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$IssueStatusEnumMap = {
  IssueStatus.pending: 'pending',
  IssueStatus.inProgress: 'inProgress',
  IssueStatus.resolved: 'resolved',
  IssueStatus.rejected: 'rejected',
};
