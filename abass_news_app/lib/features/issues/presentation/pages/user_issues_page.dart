import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/issue_bloc.dart';
import '../widgets/issue_card.dart';

class UserIssuesPage extends StatefulWidget {
  const UserIssuesPage({super.key});

  @override
  State<UserIssuesPage> createState() => _UserIssuesPageState();
}

class _UserIssuesPageState extends State<UserIssuesPage> {
  @override
  void initState() {
    super.initState();
    context.read<IssueBloc>().add(LoadUserIssues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Issues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/issues/create'),
          ),
        ],
      ),
      body: BlocConsumer<IssueBloc, IssueState>(
        listener: (context, state) {
          if (state is IssueError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is IssueCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Issue created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is IssueLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserIssuesLoaded) {
            if (state.issues.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bug_report, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No issues yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create your first issue!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<IssueBloc>().add(LoadUserIssues());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.issues.length,
                itemBuilder: (context, index) {
                  final issue = state.issues[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IssueCard(
                      issue: issue,
                      onTap: () => context.push('/issues/${issue.id}'),
                    ),
                  );
                },
              ),
            );
          }

          if (state is IssueError) {
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
                      context.read<IssueBloc>().add(LoadUserIssues());
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
}
