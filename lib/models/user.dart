import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole { user, admin }

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String email,
    required String username,
    required String passwordHash,
    required UserRole role,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
