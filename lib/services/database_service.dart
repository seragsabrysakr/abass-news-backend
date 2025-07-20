import 'dart:io';

import 'package:postgres/postgres.dart';

class DatabaseService {
  static PostgreSQLConnection? _connection;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Get database connection details from environment variables
    final host = Platform.environment['DB_HOST'] ?? 'localhost';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final database = Platform.environment['DB_NAME'] ?? 'abass_news';
    final username = Platform.environment['DB_USER'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? 'password';

    _connection = PostgreSQLConnection(
      host,
      port,
      database,
      username: username,
      password: password,
    );

    await _connection!.open();
    await _createTables();
    _initialized = true;
  }

  static PostgreSQLConnection get instance {
    if (!_initialized || _connection == null) {
      throw StateError(
        'Database not initialized. Call DatabaseService.initialize() first.',
      );
    }
    return _connection!;
  }

  static Future<void> close() async {
    if (_initialized && _connection != null) {
      await _connection!.close();
      _initialized = false;
    }
  }

  static Future<void> _createTables() async {
    final connection = _connection!;

    // Create users table
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        username VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role VARCHAR(50) NOT NULL DEFAULT 'user',
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP
      )
    ''');

    // Create articles table
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS articles (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        author_id INTEGER NOT NULL REFERENCES users(id),
        summary TEXT,
        image_url VARCHAR(500),
        tags TEXT[],
        is_published BOOLEAN NOT NULL DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP,
        published_at TIMESTAMP
      )
    ''');

    // Create issues table
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS issues (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        user_id INTEGER NOT NULL REFERENCES users(id),
        image_url VARCHAR(500),
        attachments TEXT[],
        status VARCHAR(50) NOT NULL DEFAULT 'pending',
        admin_notes TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP,
        resolved_at TIMESTAMP
      )
    ''');

    // Create password_resets table
    await connection.execute('''
      CREATE TABLE IF NOT EXISTS password_resets (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id),
        token VARCHAR(255) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        used BOOLEAN NOT NULL DEFAULT FALSE
      )
    ''');

    // Create indexes for better performance
    await connection.execute(
      'CREATE INDEX IF NOT EXISTS idx_articles_author_id ON articles(author_id)',
    );
    await connection.execute(
      'CREATE INDEX IF NOT EXISTS idx_articles_is_published ON articles(is_published)',
    );
    await connection.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_user_id ON issues(user_id)',
    );
    await connection.execute(
      'CREATE INDEX IF NOT EXISTS idx_issues_status ON issues(status)',
    );
  }
}
