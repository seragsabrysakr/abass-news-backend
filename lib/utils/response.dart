import 'package:dart_frog/dart_frog.dart';

Response apiResponse({
  required bool status,
  dynamic data,
  String message = '',
  int statusCode = 200,
}) {
  return Response.json(
    statusCode: statusCode,
    body: {
      'status': status,
      'data': data,
      'message': message,
    },
  );
}
