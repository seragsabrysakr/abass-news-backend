class EnvironmentConfig {
  // Environment types
  static const String development = 'development';
  static const String production = 'production';

  // Current environment (change this to switch environments)
  static const String currentEnvironment = development;

  // API URLs for different environments
  static const Map<String, String> apiUrls = {
    development: 'http://localhost:8080',
    production:
        'https://abass-news-backend-production.up.railway.app', // Replace with your actual Railway URL
  };

  // Get the current API URL
  static String get apiUrl {
    // return apiUrls[currentEnvironment] ?? apiUrls[development]!;
    return 'https://abass-news-backend-production.up.railway.app';
  }

  // Check if we're in production
  static bool get isProduction => currentEnvironment == production;

  // Check if we're in development
  static bool get isDevelopment => currentEnvironment == development;

  // Get environment name
  static String get environmentName => currentEnvironment;
}
