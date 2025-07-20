import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required int id,
    required String title,
    required String content,
    required String author,
    String? imageUrl,
    List<String>? tags,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
