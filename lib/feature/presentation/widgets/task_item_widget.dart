import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../provider/task_provider.dart';
import 'delete_confirmation_dialog_widget.dart';

class TaskItem extends ConsumerWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      ref.read(taskListProvider.notifier).toggleTaskCompletion(task);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: task.isCompleted ? Colors.grey : Colors.black54,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(context, ref),
                    tooltip: 'Delete task',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(_formatDate(task.createdAt), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.isCompleted ? 'Completed' : 'Pending',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: task.isCompleted ? Colors.green[800] : Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(taskTitle: task.title),
    );

    if (confirmed == true) {
      await ref.read(taskListProvider.notifier).deleteTask(task.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted successfully'), backgroundColor: Colors.red));
      }
    }
  }
}
