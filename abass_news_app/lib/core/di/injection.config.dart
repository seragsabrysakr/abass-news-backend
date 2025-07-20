// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:abass_news_app/core/network/api_client.dart' as _i929;
import 'package:abass_news_app/features/articles/data/datasources/article_remote_datasource.dart'
    as _i205;
import 'package:abass_news_app/features/articles/data/repositories/article_repository_impl.dart'
    as _i620;
import 'package:abass_news_app/features/articles/domain/repositories/article_repository.dart'
    as _i691;
import 'package:abass_news_app/features/articles/domain/usecases/create_article_usecase.dart'
    as _i375;
import 'package:abass_news_app/features/articles/domain/usecases/delete_article_usecase.dart'
    as _i228;
import 'package:abass_news_app/features/articles/domain/usecases/get_all_articles_usecase.dart'
    as _i691;
import 'package:abass_news_app/features/articles/domain/usecases/get_article_by_id_usecase.dart'
    as _i961;
import 'package:abass_news_app/features/articles/domain/usecases/update_article_usecase.dart'
    as _i895;
import 'package:abass_news_app/features/articles/presentation/bloc/article_bloc.dart'
    as _i219;
import 'package:abass_news_app/features/auth/data/datasources/auth_local_datasource.dart'
    as _i783;
import 'package:abass_news_app/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i96;
import 'package:abass_news_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i602;
import 'package:abass_news_app/features/auth/domain/repositories/auth_repository.dart'
    as _i706;
import 'package:abass_news_app/features/auth/domain/usecases/login_usecase.dart'
    as _i795;
import 'package:abass_news_app/features/auth/domain/usecases/register_usecase.dart'
    as _i743;
import 'package:abass_news_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i207;
import 'package:abass_news_app/features/issues/data/datasources/issue_remote_datasource.dart'
    as _i687;
import 'package:abass_news_app/features/issues/data/repositories/issue_repository_impl.dart'
    as _i969;
import 'package:abass_news_app/features/issues/domain/repositories/issue_repository.dart'
    as _i378;
import 'package:abass_news_app/features/issues/domain/usecases/create_issue_usecase.dart'
    as _i975;
import 'package:abass_news_app/features/issues/domain/usecases/get_all_issues_usecase.dart'
    as _i1022;
import 'package:abass_news_app/features/issues/domain/usecases/get_user_issues_usecase.dart'
    as _i246;
import 'package:abass_news_app/features/issues/domain/usecases/update_issue_status_usecase.dart'
    as _i1048;
import 'package:abass_news_app/features/issues/presentation/bloc/issue_bloc.dart'
    as _i378;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i929.ApiClient>(() => _i929.ApiClient());
    gh.factory<_i783.AuthLocalDataSource>(() => _i783.AuthLocalDataSource());
    gh.factory<_i96.AuthRemoteDataSource>(
        () => _i96.AuthRemoteDataSource(gh<_i929.ApiClient>()));
    gh.factory<_i205.ArticleRemoteDataSource>(
        () => _i205.ArticleRemoteDataSource(gh<_i929.ApiClient>()));
    gh.factory<_i687.IssueRemoteDataSource>(
        () => _i687.IssueRemoteDataSource(gh<_i929.ApiClient>()));
    gh.factory<_i691.ArticleRepository>(
        () => _i620.ArticleRepositoryImpl(gh<_i205.ArticleRemoteDataSource>()));
    gh.factory<_i706.AuthRepository>(() => _i602.AuthRepositoryImpl(
          gh<_i96.AuthRemoteDataSource>(),
          gh<_i783.AuthLocalDataSource>(),
          gh<_i929.ApiClient>(),
        ));
    gh.factory<_i691.GetAllArticlesUseCase>(
        () => _i691.GetAllArticlesUseCase(gh<_i691.ArticleRepository>()));
    gh.factory<_i375.CreateArticleUseCase>(
        () => _i375.CreateArticleUseCase(gh<_i691.ArticleRepository>()));
    gh.factory<_i895.UpdateArticleUseCase>(
        () => _i895.UpdateArticleUseCase(gh<_i691.ArticleRepository>()));
    gh.factory<_i228.DeleteArticleUseCase>(
        () => _i228.DeleteArticleUseCase(gh<_i691.ArticleRepository>()));
    gh.factory<_i961.GetArticleByIdUseCase>(
        () => _i961.GetArticleByIdUseCase(gh<_i691.ArticleRepository>()));
    gh.factory<_i743.RegisterUseCase>(
        () => _i743.RegisterUseCase(gh<_i706.AuthRepository>()));
    gh.factory<_i795.LoginUseCase>(
        () => _i795.LoginUseCase(gh<_i706.AuthRepository>()));
    gh.factory<_i378.IssueRepository>(
        () => _i969.IssueRepositoryImpl(gh<_i687.IssueRemoteDataSource>()));
    gh.factory<_i207.AuthBloc>(() => _i207.AuthBloc(
          gh<_i795.LoginUseCase>(),
          gh<_i743.RegisterUseCase>(),
          gh<_i706.AuthRepository>(),
        ));
    gh.factory<_i219.ArticleBloc>(() => _i219.ArticleBloc(
          gh<_i691.GetAllArticlesUseCase>(),
          gh<_i961.GetArticleByIdUseCase>(),
          gh<_i375.CreateArticleUseCase>(),
          gh<_i895.UpdateArticleUseCase>(),
          gh<_i228.DeleteArticleUseCase>(),
        ));
    gh.factory<_i246.GetUserIssuesUseCase>(
        () => _i246.GetUserIssuesUseCase(gh<_i378.IssueRepository>()));
    gh.factory<_i1022.GetAllIssuesUseCase>(
        () => _i1022.GetAllIssuesUseCase(gh<_i378.IssueRepository>()));
    gh.factory<_i1048.UpdateIssueStatusUseCase>(
        () => _i1048.UpdateIssueStatusUseCase(gh<_i378.IssueRepository>()));
    gh.factory<_i975.CreateIssueUseCase>(
        () => _i975.CreateIssueUseCase(gh<_i378.IssueRepository>()));
    gh.factory<_i378.IssueBloc>(() => _i378.IssueBloc(
          gh<_i1022.GetAllIssuesUseCase>(),
          gh<_i246.GetUserIssuesUseCase>(),
          gh<_i975.CreateIssueUseCase>(),
          gh<_i1048.UpdateIssueStatusUseCase>(),
        ));
    return this;
  }
}
