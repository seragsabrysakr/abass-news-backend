import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return (context) async {
    // Handle preflight OPTIONS requests
    if (context.request.method == HttpMethod.options) {
      return Response(
        headers: _corsHeaders,
      );
    }

    // Process the request
    final response = await handler(context);

    // Add CORS headers to all responses
    return response.copyWith(
      headers: {
        ...response.headers,
        ..._corsHeaders,
      },
    );
  };
}

// CORS headers to allow Flutter web app to connect
final Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'Origin, Content-Type, Accept, Authorization, X-Requested-With',
  'Access-Control-Allow-Credentials': 'true',
  'Access-Control-Max-Age': '86400',
};
