import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/role_utils.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthUnauthenticated) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.newspaper, size: 100, color: Colors.blue),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to Abass News',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your trusted source for the latest news',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => context.go('/register'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          final user = state.authEntity.user;
          final isAdmin = RoleUtils.isAdmin(user.role);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Abass News'),
              actions: [
                // Show role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: isAdmin ? Colors.orange : Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    user.role.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${isAdmin ? 'Admin' : 'User'}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hello, ${user.username}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildFeatureCard(
                          context,
                          'Articles',
                          Icons.article,
                          Colors.blue,
                          () => context.go('/articles'),
                        ),
                        if (RoleUtils.canCreateArticles(user.role))
                          _buildFeatureCard(
                            context,
                            'Create Article',
                            Icons.add_circle,
                            Colors.indigo,
                            () => context.go('/articles/create'),
                          ),
                        if (RoleUtils.canViewAllIssues(user.role))
                          _buildFeatureCard(
                            context,
                            'All Issues',
                            Icons.bug_report,
                            Colors.orange,
                            () => context.go('/issues'),
                          ),
                        if (RoleUtils.canViewUserIssues(user.role))
                          _buildFeatureCard(
                            context,
                            'My Issues',
                            Icons.person,
                            Colors.green,
                            () => context.go('/issues/user'),
                          ),
                        if (RoleUtils.canCreateIssues(user.role))
                          _buildFeatureCard(
                            context,
                            'Create Issue',
                            Icons.add_circle,
                            Colors.purple,
                            () => context.go('/issues/create'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Something went wrong')),
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
