import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/issue_bloc.dart';

class CreateIssuePage extends StatefulWidget {
  const CreateIssuePage({super.key});

  @override
  State<CreateIssuePage> createState() => _CreateIssuePageState();
}

class _CreateIssuePageState extends State<CreateIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _attachmentsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _attachmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Issue')),
      body: BlocListener<IssueBloc, IssueState>(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _attachmentsController,
                  decoration: const InputDecoration(
                    labelText: 'Attachments (comma separated URLs)',
                    border: OutlineInputBorder(),
                    hintText:
                        'e.g., https://example.com/file1.pdf, https://example.com/file2.jpg',
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<IssueBloc, IssueState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is IssueLoading ? null : _handleCreate,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          state is IssueLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                'Create Issue',
                                style: TextStyle(fontSize: 16),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      final attachments =
          _attachmentsController.text
              .split(',')
              .map((url) => url.trim())
              .where((url) => url.isNotEmpty)
              .toList();

      context.read<IssueBloc>().add(
        CreateIssue(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrl:
              _imageUrlController.text.trim().isEmpty
                  ? null
                  : _imageUrlController.text.trim(),
          attachments: attachments.isEmpty ? null : attachments,
        ),
      );
    }
  }
}
