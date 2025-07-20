part of 'article_bloc.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class LoadArticles extends ArticleEvent {}

class LoadArticleById extends ArticleEvent {
  final int id;

  const LoadArticleById(this.id);

  @override
  List<Object> get props => [id];
}

class CreateArticle extends ArticleEvent {
  final String title;
  final String content;
  final String? imageUrl;
  final List<String>? tags;

  const CreateArticle({
    required this.title,
    required this.content,
    this.imageUrl,
    this.tags,
  });

  @override
  List<Object> get props => [title, content, imageUrl ?? '', tags ?? []];
}

class UpdateArticle extends ArticleEvent {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final List<String>? tags;

  const UpdateArticle({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.tags,
  });

  @override
  List<Object> get props => [id, title, content, imageUrl ?? '', tags ?? []];
}

class DeleteArticle extends ArticleEvent {
  final int id;

  const DeleteArticle(this.id);

  @override
  List<Object> get props => [id];
}
