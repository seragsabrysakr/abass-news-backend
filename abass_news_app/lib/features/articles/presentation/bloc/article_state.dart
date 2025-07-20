part of 'article_bloc.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticlesLoaded extends ArticleState {
  final List<ArticleEntity> articles;

  const ArticlesLoaded(this.articles);

  @override
  List<Object> get props => [articles];
}

class ArticleLoaded extends ArticleState {
  final ArticleEntity article;

  const ArticleLoaded(this.article);

  @override
  List<Object> get props => [article];
}

class ArticleCreated extends ArticleState {
  final ArticleEntity article;

  const ArticleCreated(this.article);

  @override
  List<Object> get props => [article];
}

class ArticleUpdated extends ArticleState {
  final ArticleEntity article;

  const ArticleUpdated(this.article);

  @override
  List<Object> get props => [article];
}

class ArticleDeleted extends ArticleState {}

class ArticleError extends ArticleState {
  final String message;

  const ArticleError(this.message);

  @override
  List<Object> get props => [message];
}
