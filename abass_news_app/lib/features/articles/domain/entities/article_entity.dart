import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String author;
  final String? imageUrl;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ArticleEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.imageUrl,
    this.tags,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    author,
    imageUrl,
    tags,
    createdAt,
    updatedAt,
  ];
}
