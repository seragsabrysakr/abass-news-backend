// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/issues/user.dart' as issues_user;
import '../routes/issues/index.dart' as issues_index;
import '../routes/issues/[id]/status.dart' as issues_$id_status;
import '../routes/auth/reset_password.dart' as auth_reset_password;
import '../routes/auth/register.dart' as auth_register;
import '../routes/auth/login.dart' as auth_login;
import '../routes/auth/forgot_password.dart' as auth_forgot_password;
import '../routes/auth/delete.dart' as auth_delete;
import '../routes/articles/index.dart' as articles_index;
import '../routes/articles/[id].dart' as articles_$id;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/articles', (context) => buildArticlesHandler()(context))
    ..mount('/auth', (context) => buildAuthHandler()(context))
    ..mount('/issues/<id>', (context,id,) => buildIssues$idHandler(id,)(context))
    ..mount('/issues', (context) => buildIssuesHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildArticlesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => articles_index.onRequest(context,))..all('/<id>', (context,id,) => articles_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/reset_password', (context) => auth_reset_password.onRequest(context,))..all('/register', (context) => auth_register.onRequest(context,))..all('/login', (context) => auth_login.onRequest(context,))..all('/forgot_password', (context) => auth_forgot_password.onRequest(context,))..all('/delete', (context) => auth_delete.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildIssues$idHandler(String id,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/status', (context) => issues_$id_status.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildIssuesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/user', (context) => issues_user.onRequest(context,))..all('/', (context) => issues_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

