import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response.json(
    body: {
      'status': 'ok',
      'message': 'Test endpoint working',
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}
