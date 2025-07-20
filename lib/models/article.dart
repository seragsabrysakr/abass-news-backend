import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required int id,
    required String title,
    required String content,
    required String authorId,
    required bool isPublished,
    required DateTime createdAt,
    String? summary,
    String? imageUrl,
    List<String>? tags,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
