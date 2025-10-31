import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/task_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/task_item_widget.dart';
import 'task_form_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(filteredTaskListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks'), elevation: 2, backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: taskList.when(
              data: (tasks) => tasks.isEmpty ? const EmptyState() : _buildTaskList(tasks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading tasks', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(error.toString(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(taskListProvider.notifier).loadTasks();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToTaskForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildTaskList(tasks) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(taskListProvider.notifier).loadTasks();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskItem(
            task: task,
            onTap: () => _navigateToTaskForm(context, task: task),
          );
        },
      ),
    );
  }

  Future<void> _navigateToTaskForm(BuildContext context, {task}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)));
  }
}
