import 'dart:io';

void main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  print('🚀 Starting minimal test server on port $port...');

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('✅ Test server running on port ${server.port}');

  server.listen((HttpRequest request) {
    print('📨 Received request: ${request.method} ${request.uri}');

    request.response
      ..headers.contentType = ContentType.json
      ..write('{"status": "ok", "message": "Test server working"}')
      ..close();
  });

  print('🔄 Server listening for requests...');
}
