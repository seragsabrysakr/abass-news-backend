import 'dart:convert';

import 'package:abass_news/models/user.dart';
import 'package:abass_news/services/database_service.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  static const String _secretKey = 'your-secret-key-change-in-production';
  static const int _tokenExpiryHours = 24;

  // Hash password using SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate JWT token
  static String generateToken(User user) {
    final payload = {
      'userId': user.id,
      'email': user.email,
      'role': user.role.name,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': (DateTime.now()
              .add(const Duration(hours: _tokenExpiryHours))
              .millisecondsSinceEpoch ~/
          1000),
    };

    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };

    final encodedHeader = base64Url.encode(utf8.encode(json.encode(header)));
    final encodedPayload = base64Url.encode(utf8.encode(json.encode(payload)));

    final signature = _generateSignature('$encodedHeader.$encodedPayload');
    final encodedSignature = base64Url.encode(signature);

    return '$encodedHeader.$encodedPayload.$encodedSignature';
  }

  static List<int> _generateSignature(String data) {
    final hmac = Hmac(sha256, utf8.encode(_secretKey));
    return hmac.convert(utf8.encode(data)).bytes;
  }

  // Verify JWT token
  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final header = parts[0];
      final payload = parts[1];
      final signature = parts[2];

      final expectedSignature =
          base64Url.encode(_generateSignature('$header.$payload'));
      if (signature != expectedSignature) return null;

      final decodedPayload = json.decode(utf8.decode(base64Url.decode(payload)))
          as Map<String, dynamic>;
      final expiry = decodedPayload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (now > expiry) return null;

      return decodedPayload;
    } catch (e) {
      return null;
    }
  }

  // Authenticate user
  static Future<User?> authenticateUser(String email, String password) async {
    final connection = DatabaseService.instance;
    final hashedPassword = hashPassword(password);

    final results = await connection.query(
      'SELECT * FROM users WHERE email = @email AND password_hash = @password',
      substitutionValues: {
        'email': email,
        'password': hashedPassword,
      },
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return User(
      id: row[0] as int,
      email: row[1] as String,
      username: row[2] as String,
      passwordHash: row[3] as String,
      role: UserRole.values.firstWhere((r) => r.name == row[4]),
      createdAt: row[5] as DateTime,
      updatedAt: row[6] as DateTime?,
    );
  }

  // Get user by ID
  static Future<User?> getUserById(int id) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'SELECT * FROM users WHERE id = @id',
      substitutionValues: {'id': id},
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return User(
      id: row[0] as int,
      email: row[1] as String,
      username: row[2] as String,
      passwordHash: row[3] as String,
      role: UserRole.values.firstWhere((r) => r.name == row[4]),
      createdAt: row[5] as DateTime,
      updatedAt: row[6] as DateTime?,
    );
  }

  // Create new user
  static Future<User> createUser({
    required String email,
    required String username,
    required String password,
    UserRole role = UserRole.user,
  }) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      '''
      INSERT INTO users (email, username, password_hash, role, created_at)
      VALUES (@email, @username, @password, @role, @created_at)
      RETURNING *
      ''',
      substitutionValues: {
        'email': email,
        'username': username,
        'password': hashPassword(password),
        'role': role.name,
        'created_at': DateTime.now(),
      },
    );

    final row = results.first;
    return User(
      id: row[0] as int,
      email: row[1] as String,
      username: row[2] as String,
      passwordHash: row[3] as String,
      role: UserRole.values.firstWhere((r) => r.name == row[4]),
      createdAt: row[5] as DateTime,
      updatedAt: row[6] as DateTime?,
    );
  }

  // Forgot password: create reset token
  static Future<String?> createPasswordResetToken(String email) async {
    final connection = DatabaseService.instance;
    final results = await connection.query(
      'SELECT id FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );
    if (results.isEmpty) return null;
    final userId = results.first[0] as int;
    final token = base64Url.encode(List<int>.generate(
        32, (_) => (DateTime.now().millisecondsSinceEpoch + _ + userId) % 256));
    await connection.query(
      '''INSERT INTO password_resets (user_id, token, created_at, used) VALUES (@user_id, @token, NOW(), FALSE)''',
      substitutionValues: {'user_id': userId, 'token': token},
    );
    return token;
  }

  // Reset password using token
  static Future<bool> resetPassword(
      {required String token, required String newPassword}) async {
    final connection = DatabaseService.instance;
    final results = await connection.query(
      'SELECT user_id, used FROM password_resets WHERE token = @token',
      substitutionValues: {'token': token},
    );
    if (results.isEmpty) return false;
    final row = results.first;
    if (row[1] == true) return false; // already used
    final userId = row[0] as int;
    await connection.query(
      'UPDATE users SET password_hash = @password WHERE id = @id',
      substitutionValues: {'password': hashPassword(newPassword), 'id': userId},
    );
    await connection.query(
      'UPDATE password_resets SET used = TRUE WHERE token = @token',
      substitutionValues: {'token': token},
    );
    return true;
  }

  // Delete user by ID
  static Future<bool> deleteUser(int id) async {
    final connection = DatabaseService.instance;
    final result = await connection.query('DELETE FROM users WHERE id = @id',
        substitutionValues: {'id': id});
    return result.affectedRowCount > 0;
  }
}
