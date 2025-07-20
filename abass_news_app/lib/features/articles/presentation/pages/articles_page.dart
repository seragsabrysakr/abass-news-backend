import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/article_bloc.dart';
import '../widgets/article_card.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ArticleBloc>().add(LoadArticles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/articles/create'),
          ),
        ],
      ),
      body: BlocConsumer<ArticleBloc, ArticleState>(
        listener: (context, state) {
          if (state is ArticleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ArticleCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Article created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is ArticleUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Article updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is ArticleDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Article deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ArticleBloc>().add(LoadArticles());
          }
        },
        builder: (context, state) {
          if (state is ArticleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ArticlesLoaded) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No articles yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create your first article!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ArticleBloc>().add(LoadArticles());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ArticleCard(
                      article: article,
                      onTap: () => context.push('/articles/${article.id}'),
                      onEdit:
                          () => context.push('/articles/${article.id}/edit'),
                      onDelete: () => _showDeleteDialog(context, article.id),
                    ),
                  );
                },
              ),
            );
          }

          if (state is ArticleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ArticleBloc>().add(LoadArticles());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int articleId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Article'),
            content: const Text(
              'Are you sure you want to delete this article?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<ArticleBloc>().add(DeleteArticle(articleId));
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
