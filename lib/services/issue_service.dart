import 'package:abass_news/models/issue.dart';
import 'package:abass_news/services/database_service.dart';

class IssueService {
  static Future<List<Issue>> getAllIssues({IssueStatus? status}) async {
    final connection = DatabaseService.instance;

    var query = 'SELECT * FROM issues';
    if (status != null) {
      query += ' WHERE status = @status';
    }
    query += ' ORDER BY created_at DESC';

    final results = await connection.query(
      query,
      substitutionValues: status != null ? {'status': status.name} : {},
    );

    return results
        .map(
          (row) => Issue(
            id: row[0] as int,
            title: row[1] as String,
            description: row[2] as String,
            userId: row[3].toString(),
            imageUrl: row[4] as String?,
            attachments: (row[5] as List<dynamic>?)?.cast<String>(),
            status: IssueStatus.values.firstWhere((s) => s.name == row[6]),
            adminNotes: row[7] as String?,
            createdAt: row[8] as DateTime,
            updatedAt: row[9] as DateTime?,
            resolvedAt: row[10] as DateTime?,
          ),
        )
        .toList();
  }

  static Future<Issue?> getIssueById(int id) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'SELECT * FROM issues WHERE id = @id',
      substitutionValues: {'id': id},
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return Issue(
      id: row[0] as int,
      title: row[1] as String,
      description: row[2] as String,
      userId: row[3].toString(),
      imageUrl: row[4] as String?,
      attachments: (row[5] as List<dynamic>?)?.cast<String>(),
      status: IssueStatus.values.firstWhere((s) => s.name == row[6]),
      adminNotes: row[7] as String?,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime?,
      resolvedAt: row[10] as DateTime?,
    );
  }

  static Future<List<Issue>> getUserIssues(String userId) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'SELECT * FROM issues WHERE user_id = @user_id ORDER BY created_at DESC',
      substitutionValues: {'user_id': int.parse(userId)},
    );

    return results
        .map(
          (row) => Issue(
            id: row[0] as int,
            title: row[1] as String,
            description: row[2] as String,
            userId: row[3].toString(),
            imageUrl: row[4] as String?,
            attachments: (row[5] as List<dynamic>?)?.cast<String>(),
            status: IssueStatus.values.firstWhere((s) => s.name == row[6]),
            adminNotes: row[7] as String?,
            createdAt: row[8] as DateTime,
            updatedAt: row[9] as DateTime?,
            resolvedAt: row[10] as DateTime?,
          ),
        )
        .toList();
  }

  static Future<Issue> createIssue({
    required String title,
    required String description,
    required String userId,
    String? imageUrl,
    List<String>? attachments,
  }) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      '''
      INSERT INTO issues (title, description, user_id, image_url, attachments, status, created_at)
      VALUES (@title, @description, @user_id, @image_url, @attachments, @status, @created_at)
      RETURNING *
      ''',
      substitutionValues: {
        'title': title,
        'description': description,
        'user_id': int.parse(userId),
        'image_url': imageUrl,
        'attachments': attachments,
        'status': IssueStatus.pending.name,
        'created_at': DateTime.now(),
      },
    );

    final row = results.first;
    return Issue(
      id: row[0] as int,
      title: row[1] as String,
      description: row[2] as String,
      userId: row[3].toString(),
      imageUrl: row[4] as String?,
      attachments: (row[5] as List<dynamic>?)?.cast<String>(),
      status: IssueStatus.values.firstWhere((s) => s.name == row[6]),
      adminNotes: row[7] as String?,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime?,
      resolvedAt: row[10] as DateTime?,
    );
  }

  static Future<Issue?> updateIssueStatus({
    required int id,
    required IssueStatus status,
    String? adminNotes,
  }) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      '''
      UPDATE issues 
      SET status = @status, admin_notes = @admin_notes, updated_at = @updated_at, resolved_at = @resolved_at
      WHERE id = @id
      RETURNING *
      ''',
      substitutionValues: {
        'id': id,
        'status': status.name,
        'admin_notes': adminNotes,
        'updated_at': DateTime.now(),
        'resolved_at': status != IssueStatus.pending ? DateTime.now() : null,
      },
    );

    if (results.isEmpty) return null;

    final row = results.first;
    return Issue(
      id: row[0] as int,
      title: row[1] as String,
      description: row[2] as String,
      userId: row[3].toString(),
      imageUrl: row[4] as String?,
      attachments: (row[5] as List<dynamic>?)?.cast<String>(),
      status: IssueStatus.values.firstWhere((s) => s.name == row[6]),
      adminNotes: row[7] as String?,
      createdAt: row[8] as DateTime,
      updatedAt: row[9] as DateTime?,
      resolvedAt: row[10] as DateTime?,
    );
  }

  static Future<bool> deleteIssue(int id) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      'DELETE FROM issues WHERE id = @id RETURNING id',
      substitutionValues: {'id': id},
    );

    return results.isNotEmpty;
  }

  static Future<List<Issue>> searchIssues(String query) async {
    final connection = DatabaseService.instance;

    final results = await connection.query(
      '''
      SELECT * FROM issues 
      WHERE (title ILIKE @query OR description ILIKE @query)
      ORDER BY created_at DESC
      ''',
      substitutionValues: {'query': '%$query%'},
    );

    return results
        .map(
          (row) => Issue(
            id: row[0] as int,
            title: row[1] as String,
            description: row[2] as String,
            userId: row[3].toString(),
            imageUrl: row[4] as String?,
            attachments: (row[5] as List<dynamic>?)?.cast<String>(),
            status: IssueStatus.values.firstWhere((s) => s.name == row[6]),
            adminNotes: row[7] as String?,
            createdAt: row[8] as DateTime,
            updatedAt: row[9] as DateTime?,
            resolvedAt: row[10] as DateTime?,
          ),
        )
        .toList();
  }
}
