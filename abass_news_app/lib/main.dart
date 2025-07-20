import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection.dart';
import 'core/widgets/splash_screen.dart';
import 'features/articles/presentation/bloc/article_bloc.dart';
import 'features/articles/presentation/pages/articles_page.dart';
import 'features/articles/presentation/pages/create_article_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/issues/presentation/bloc/issue_bloc.dart';
import 'features/issues/presentation/pages/create_issue_page.dart';
import 'features/issues/presentation/pages/issues_page.dart';
import 'features/issues/presentation/pages/user_issues_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Configure dependencies
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<ArticleBloc>(create: (context) => getIt<ArticleBloc>()),
        BlocProvider<IssueBloc>(create: (context) => getIt<IssueBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Abass News',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2563EB),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/articles',
      builder: (context, state) => const ArticlesPage(),
    ),
    GoRoute(
      path: '/articles/create',
      builder: (context, state) => const CreateArticlePage(),
    ),
    GoRoute(path: '/issues', builder: (context, state) => const IssuesPage()),
    GoRoute(
      path: '/issues/user',
      builder: (context, state) => const UserIssuesPage(),
    ),
    GoRoute(
      path: '/issues/create',
      builder: (context, state) => const CreateIssuePage(),
    ),
  ],
);
