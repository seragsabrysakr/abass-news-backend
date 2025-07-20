import 'dart:io';

import 'package:abass_news/services/database_service.dart';
import 'package:dart_frog/dart_frog.dart';

import '../routes/index.dart' as routes;

void main(List<String> args) async {
  // Get port from environment or default to 8080
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  print('🚀 Starting server on port $port...');

  // Start the server first
  final server = await serve(
    routes.onRequest,
    InternetAddress.anyIPv4,
    port,
  );
  print('✅ Server running on port ${server.port}');

  // Initialize database in background (non-blocking)
  try {
    print('🔌 Initializing database connection...');
    await DatabaseService.initialize();
    print('✅ Database initialized successfully');
  } catch (e) {
    print('⚠️  Database initialization failed: $e');
    print('📝 Server is running but database is not available');
  }
}
