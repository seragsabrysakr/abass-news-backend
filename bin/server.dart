import 'dart:io';

import 'package:abass_news/services/database_service.dart';
import 'package:dart_frog/dart_frog.dart';

import '../routes/index.dart' as routes;

void main(List<String> args) async {
  // Initialize database
  await DatabaseService.initialize();

  // Get port from environment or default to 8080
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Start the server
  final server = await serve(
    routes.onRequest,
    InternetAddress.anyIPv4,
    port,
  );
  print('Server running on port ${server.port}');
}
