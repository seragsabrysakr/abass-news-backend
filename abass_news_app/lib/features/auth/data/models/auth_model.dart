import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_entity.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({required String token, required UserModel user}) =
      _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String email,
    required String username,
    required String role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// Extension to add toEntity methods to generated classes
extension AuthModelExtension on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(token: token, user: user.toEntity());
  }
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
