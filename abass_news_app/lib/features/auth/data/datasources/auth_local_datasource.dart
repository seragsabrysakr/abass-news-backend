import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

@injectable
class AuthLocalDataSource {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    // Store individual user fields
    await prefs.setInt('user_id', userData['id'] as int);
    await prefs.setString('user_email', userData['email'] as String);
    await prefs.setString('user_username', userData['username'] as String);
    await prefs.setString('user_role', userData['role'] as String);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    final email = prefs.getString('user_email');
    final username = prefs.getString('user_username');
    final role = prefs.getString('user_role');

    if (id != null && email != null && username != null && role != null) {
      return {'id': id, 'email': email, 'username': username, 'role': role};
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_username');
    await prefs.remove('user_role');
  }
}
