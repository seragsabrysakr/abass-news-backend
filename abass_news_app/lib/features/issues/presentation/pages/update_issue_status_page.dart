import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/issue_entity.dart';
import '../bloc/issue_bloc.dart';

class UpdateIssueStatusPage extends StatefulWidget {
  final int issueId;
  final IssueEntity issue;

  const UpdateIssueStatusPage({
    super.key,
    required this.issueId,
    required this.issue,
  });

  @override
  State<UpdateIssueStatusPage> createState() => _UpdateIssueStatusPageState();
}

class _UpdateIssueStatusPageState extends State<UpdateIssueStatusPage> {
  final _formKey = GlobalKey<FormState>();
  final _adminNotesController = TextEditingController();
  IssueStatus _selectedStatus = IssueStatus.pending;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.issue.status;
    _adminNotesController.text = widget.issue.adminNotes ?? '';
  }

  @override
  void dispose() {
    _adminNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Issue Status')),
      body: BlocListener<IssueBloc, IssueState>(
        listener: (context, state) {
          if (state is IssueError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is IssueStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Issue status updated successfully!'),
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Issue: ${widget.issue.title}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.issue.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text(
                              'Current Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            _buildStatusChip(widget.issue.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'New Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<IssueStatus>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items:
                      IssueStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(_getStatusText(status)),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _adminNotesController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Notes (optional)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                BlocBuilder<IssueBloc, IssueState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is IssueLoading ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          state is IssueLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                'Update Status',
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

  Widget _buildStatusChip(IssueStatus status) {
    Color color;
    String text;

    switch (status) {
      case IssueStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case IssueStatus.inProgress:
        color = Colors.blue;
        text = 'In Progress';
        break;
      case IssueStatus.resolved:
        color = Colors.green;
        text = 'Resolved';
        break;
      case IssueStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getStatusText(IssueStatus status) {
    switch (status) {
      case IssueStatus.pending:
        return 'Pending';
      case IssueStatus.inProgress:
        return 'In Progress';
      case IssueStatus.resolved:
        return 'Resolved';
      case IssueStatus.rejected:
        return 'Rejected';
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<IssueBloc>().add(
        UpdateIssueStatus(
          id: widget.issueId,
          status: _selectedStatus,
          adminNotes:
              _adminNotesController.text.trim().isEmpty
                  ? null
                  : _adminNotesController.text.trim(),
        ),
      );
    }
  }
}
