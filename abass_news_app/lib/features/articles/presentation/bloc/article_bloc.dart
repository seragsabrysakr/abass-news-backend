import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/article_entity.dart';
import '../../domain/usecases/create_article_usecase.dart';
import '../../domain/usecases/delete_article_usecase.dart';
import '../../domain/usecases/get_all_articles_usecase.dart';
import '../../domain/usecases/get_article_by_id_usecase.dart';
import '../../domain/usecases/update_article_usecase.dart';

part 'article_event.dart';
part 'article_state.dart';

@injectable
class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final GetAllArticlesUseCase _getAllArticlesUseCase;
  final GetArticleByIdUseCase _getArticleByIdUseCase;
  final CreateArticleUseCase _createArticleUseCase;
  final UpdateArticleUseCase _updateArticleUseCase;
  final DeleteArticleUseCase _deleteArticleUseCase;

  ArticleBloc(
    this._getAllArticlesUseCase,
    this._getArticleByIdUseCase,
    this._createArticleUseCase,
    this._updateArticleUseCase,
    this._deleteArticleUseCase,
  ) : super(ArticleInitial()) {
    on<LoadArticles>(_onLoadArticles);
    on<LoadArticleById>(_onLoadArticleById);
    on<CreateArticle>(_onCreateArticle);
    on<UpdateArticle>(_onUpdateArticle);
    on<DeleteArticle>(_onDeleteArticle);
  }

  Future<void> _onLoadArticles(
    LoadArticles event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticleLoading());

    final result = await _getAllArticlesUseCase();

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (articles) => emit(ArticlesLoaded(articles)),
    );
  }

  Future<void> _onLoadArticleById(
    LoadArticleById event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticleLoading());

    final result = await _getArticleByIdUseCase(event.id);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (article) => emit(ArticleLoaded(article)),
    );
  }

  Future<void> _onCreateArticle(
    CreateArticle event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticleLoading());

    final result = await _createArticleUseCase(
      title: event.title,
      content: event.content,
      imageUrl: event.imageUrl,
      tags: event.tags,
    );

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (article) => emit(ArticleCreated(article)),
    );
  }

  Future<void> _onUpdateArticle(
    UpdateArticle event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticleLoading());

    final result = await _updateArticleUseCase(
      id: event.id,
      title: event.title,
      content: event.content,
      imageUrl: event.imageUrl,
      tags: event.tags,
    );

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (article) => emit(ArticleUpdated(article)),
    );
  }

  Future<void> _onDeleteArticle(
    DeleteArticle event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticleLoading());

    final result = await _deleteArticleUseCase(event.id);

    result.fold(
      (failure) => emit(ArticleError(failure.message)),
      (_) => emit(ArticleDeleted()),
    );
  }
}
