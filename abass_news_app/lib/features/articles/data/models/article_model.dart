import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/article_entity.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    required int id,
    required String title,
    required String content,
    required String author,
    String? imageUrl,
    List<String>? tags,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}

// Extension to add toEntity method to generated class
extension ArticleModelExtension on ArticleModel {
  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      title: title,
      content: content,
      author: author,
      imageUrl: imageUrl,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
