import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/issue_bloc.dart';
import '../widgets/issue_card.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  @override
  void initState() {
    super.initState();
    context.read<IssueBloc>().add(LoadAllIssues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Issues'),
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
          } else if (state is IssueStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Issue status updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<IssueBloc>().add(LoadAllIssues());
          }
        },
        builder: (context, state) {
          if (state is IssueLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is IssuesLoaded) {
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
                      'All issues will appear here',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<IssueBloc>().add(LoadAllIssues());
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
                      onUpdateStatus:
                          () => context.push('/issues/${issue.id}/status'),
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
                      context.read<IssueBloc>().add(LoadAllIssues());
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
