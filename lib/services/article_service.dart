import 'package:abass_news/models/article.dart';
import 'package:abass_news/services/database_service.dart';

class ArticleService {
  static Future<List<Article>> getAllArticles(
      {bool publishedOnly = true}) async {
    final connection = DatabaseService.instance;

    var query = 'SELECT * FROM articles';
    if (publishedOnly) {
      query += ' WHERE is_published = true';
    }
    query += ' ORDER BY created_at DESC';

    final results = await connection.query(query);

    return results
        .map(
          (row) => Article(
            id: row[0] as int,
            title: row[1] as String,
            content: row[2] as String,
            authorId: row[3].toString(),
            summary: row[4] as String?,
            imageUrl: row[5] as String?,
            tags: (row[6] as List<dynamic>?)?.cast<String>(),
            isPublished: row[7] as bool,
            createdAt: row[8] as DateTime,
            updatedAt: row[9] as DateTime?,
            publishedAt: row[10] as DateTime?,
          ),
        )
        .toList();
  }

  static Future<Article?> getArticleById(int id) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'SELECT * FROM articles WHERE id = @id',
      substitutionValues: {'id': id},
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return Article(
      id: row[0] as int,
      title: row[1] as String,
      content: row[2] as String,
      authorId: row[3].toString(),
      summary: row[4] as String?,
      imageUrl: row[5] as String?,
      tags: (row[6] as List<dynamic>?)?.cast<String>(),
      isPublished: row[7] as bool,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime?,
      publishedAt: row[10] as DateTime?,
    );
  }

  static Future<Article> createArticle({
    required String title,
    required String content,
    required String authorId,
    String? summary,
    String? imageUrl,
    List<String>? tags,
    bool isPublished = false,
  }) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      '''
      INSERT INTO articles (title, content, author_id, summary, image_url, tags, is_published, created_at, published_at)
      VALUES (@title, @content, @author_id, @summary, @image_url, @tags, @is_published, @created_at, @published_at)
      RETURNING *
      ''',
      substitutionValues: {
        'title': title,
        'content': content,
        'author_id': int.parse(authorId),
        'summary': summary,
        'image_url': imageUrl,
        'tags': tags,
        'is_published': isPublished,
        'created_at': DateTime.now(),
        'published_at': isPublished ? DateTime.now() : null,
      },
    );

    final row = results.first;
    return Article(
      id: row[0] as int,
      title: row[1] as String,
      content: row[2] as String,
      authorId: row[3].toString(),
      summary: row[4] as String?,
      imageUrl: row[5] as String?,
      tags: (row[6] as List<dynamic>?)?.cast<String>(),
      isPublished: row[7] as bool,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime?,
      publishedAt: row[10] as DateTime?,
    );
  }

  static Future<Article?> updateArticle({
    required int id,
    String? title,
    String? content,
    String? summary,
    String? imageUrl,
    List<String>? tags,
    bool? isPublished,
  }) async {
    final connection = DatabaseService.instance;

    // Build dynamic update query
    final updates = <String>[];
    final values = <String, dynamic>{'id': id};

    if (title != null) {
      updates.add('title = @title');
      values['title'] = title;
    }
    if (content != null) {
      updates.add('content = @content');
      values['content'] = content;
    }
    if (summary != null) {
      updates.add('summary = @summary');
      values['summary'] = summary;
    }
    if (imageUrl != null) {
      updates.add('image_url = @image_url');
      values['image_url'] = imageUrl;
    }
    if (tags != null) {
      updates.add('tags = @tags');
      values['tags'] = tags;
    }
    if (isPublished != null) {
      updates.add('is_published = @is_published');
      values['is_published'] = isPublished;
    }

    updates.add('updated_at = @updated_at');
    values['updated_at'] = DateTime.now();

    if (isPublished == true) {
      updates.add('published_at = @published_at');
      values['published_at'] = DateTime.now();
    }

    if (updates.isEmpty) return null;

    final query = '''
      UPDATE articles 
      SET ${updates.join(', ')}
      WHERE id = @id
      RETURNING *
    ''';

    final results = await connection.query(query, substitutionValues: values);

    if (results.isEmpty) return null;

    final row = results.first;
    return Article(
      id: row[0] as int,
      title: row[1] as String,
      content: row[2] as String,
      authorId: row[3].toString(),
      summary: row[4] as String?,
      imageUrl: row[5] as String?,
      tags: (row[6] as List<dynamic>?)?.cast<String>(),
      isPublished: row[7] as bool,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime?,
      publishedAt: row[10] as DateTime?,
    );
  }

  static Future<bool> deleteArticle(int id) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'DELETE FROM articles WHERE id = @id RETURNING id',
      substitutionValues: {'id': id},
    );

    return results.isNotEmpty;
  }

  static Future<List<Article>> searchArticles(String query) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      '''
      SELECT * FROM articles 
      WHERE is_published = true 
      AND (title ILIKE @query OR content ILIKE @query)
      ORDER BY created_at DESC
      ''',
      substitutionValues: {'query': '%$query%'},
    );

    return results
        .map(
          (row) => Article(
            id: row[0] as int,
            title: row[1] as String,
            content: row[2] as String,
            authorId: row[3].toString(),
            summary: row[4] as String?,
            imageUrl: row[5] as String?,
            tags: (row[6] as List<dynamic>?)?.cast<String>(),
            isPublished: row[7] as bool,
            createdAt: row[8] as DateTime,
            updatedAt: row[9] as DateTime?,
            publishedAt: row[10] as DateTime?,
          ),
        )
        .toList();
  }

  static Future<List<Article>> getArticlesByAuthor(String authorId) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'SELECT * FROM articles WHERE author_id = @author_id ORDER BY created_at DESC',
      substitutionValues: {'author_id': int.parse(authorId)},
    );

    return results
        .map(
          (row) => Article(
            id: row[0] as int,
            title: row[1] as String,
            content: row[2] as String,
            authorId: row[3].toString(),
            summary: row[4] as String?,
            imageUrl: row[5] as String?,
            tags: (row[6] as List<dynamic>?)?.cast<String>(),
            isPublished: row[7] as bool,
            createdAt: row[8] as DateTime,
            updatedAt: row[9] as DateTime?,
            publishedAt: row[10] as DateTime?,
          ),
        )
        .toList();
  }
}
