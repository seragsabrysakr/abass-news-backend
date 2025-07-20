import 'environment_config.dart';

class AppConstants {
  // API Configuration
  static String get baseUrl => EnvironmentConfig.apiUrl;
  static const String apiVersion = '';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String deleteAccountEndpoint = '/auth/delete';

  static const String articlesEndpoint = '/articles';
  static const String issuesEndpoint = '/issues';
  static const String userIssuesEndpoint = '/issues/user';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // App Configuration
  static const String appName = 'Abass News';
  static const String appVersion = '1.0.0';

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
}
