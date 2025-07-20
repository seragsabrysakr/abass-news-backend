// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IssueImpl _$$IssueImplFromJson(Map<String, dynamic> json) => _$IssueImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      status: $enumDecode(_$IssueStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      adminNotes: json['adminNotes'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$IssueImplToJson(_$IssueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'status': _$IssueStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'attachments': instance.attachments,
      'adminNotes': instance.adminNotes,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$IssueStatusEnumMap = {
  IssueStatus.pending: 'pending',
  IssueStatus.approved: 'approved',
  IssueStatus.rejected: 'rejected',
};
