// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IssueModel _$IssueModelFromJson(Map<String, dynamic> json) {
  return _IssueModel.fromJson(json);
}

/// @nodoc
mixin _$IssueModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  IssueStatus get status => throw _privateConstructorUsedError;
  String? get adminNotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this IssueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IssueModelCopyWith<IssueModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IssueModelCopyWith<$Res> {
  factory $IssueModelCopyWith(
          IssueModel value, $Res Function(IssueModel) then) =
      _$IssueModelCopyWithImpl<$Res, IssueModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String userId,
      String? imageUrl,
      List<String>? attachments,
      IssueStatus status,
      String? adminNotes,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? resolvedAt});
}

/// @nodoc
class _$IssueModelCopyWithImpl<$Res, $Val extends IssueModel>
    implements $IssueModelCopyWith<$Res> {
  _$IssueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? userId = null,
    Object? imageUrl = freezed,
    Object? attachments = freezed,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as IssueStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IssueModelImplCopyWith<$Res>
    implements $IssueModelCopyWith<$Res> {
  factory _$$IssueModelImplCopyWith(
          _$IssueModelImpl value, $Res Function(_$IssueModelImpl) then) =
      __$$IssueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      String userId,
      String? imageUrl,
      List<String>? attachments,
      IssueStatus status,
      String? adminNotes,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? resolvedAt});
}

/// @nodoc
class __$$IssueModelImplCopyWithImpl<$Res>
    extends _$IssueModelCopyWithImpl<$Res, _$IssueModelImpl>
    implements _$$IssueModelImplCopyWith<$Res> {
  __$$IssueModelImplCopyWithImpl(
      _$IssueModelImpl _value, $Res Function(_$IssueModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? userId = null,
    Object? imageUrl = freezed,
    Object? attachments = freezed,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_$IssueModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as IssueStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IssueModelImpl implements _IssueModel {
  const _$IssueModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.userId,
      this.imageUrl,
      final List<String>? attachments,
      required this.status,
      this.adminNotes,
      required this.createdAt,
      this.updatedAt,
      this.resolvedAt})
      : _attachments = attachments;

  factory _$IssueModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IssueModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String userId;
  @override
  final String? imageUrl;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final IssueStatus status;
  @override
  final String? adminNotes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'IssueModel(id: $id, title: $title, description: $description, userId: $userId, imageUrl: $imageUrl, attachments: $attachments, status: $status, adminNotes: $adminNotes, createdAt: $createdAt, updatedAt: $updatedAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IssueModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      userId,
      imageUrl,
      const DeepCollectionEquality().hash(_attachments),
      status,
      adminNotes,
      createdAt,
      updatedAt,
      resolvedAt);

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IssueModelImplCopyWith<_$IssueModelImpl> get copyWith =>
      __$$IssueModelImplCopyWithImpl<_$IssueModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IssueModelImplToJson(
      this,
    );
  }
}

abstract class _IssueModel implements IssueModel {
  const factory _IssueModel(
      {required final int id,
      required final String title,
      required final String description,
      required final String userId,
      final String? imageUrl,
      final List<String>? attachments,
      required final IssueStatus status,
      final String? adminNotes,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? resolvedAt}) = _$IssueModelImpl;

  factory _IssueModel.fromJson(Map<String, dynamic> json) =
      _$IssueModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get userId;
  @override
  String? get imageUrl;
  @override
  List<String>? get attachments;
  @override
  IssueStatus get status;
  @override
  String? get adminNotes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get resolvedAt;

  /// Create a copy of IssueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IssueModelImplCopyWith<_$IssueModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
