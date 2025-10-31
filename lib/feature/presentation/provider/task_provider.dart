import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository_implementation/task_repo_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repository/task_repository.dart';

/// Provider for repository instance
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

/// Search query state provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Task list notifier - manages task state
class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;

  TaskListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  /// Load all tasks
  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _repository.getAllTasks();
      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Create a new task
  Future<void> createTask(Task task) async {
    try {
      await _repository.createTask(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update existing task
  Future<void> updateTask(Task task) async {
    try {
      await _repository.updateTask(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _repository.updateTask(updatedTask);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await _repository.deleteTask(id);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Search tasks
  Future<void> searchTasks(String query) async {
    if (query.isEmpty) {
      await loadTasks();
      return;
    }

    state = const AsyncValue.loading();
    try {
      final tasks = await _repository.searchTasks(query);
      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Task list provider
final taskListProvider = StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskListNotifier(repository);
});

/// Filtered task list based on search query
final filteredTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final taskList = ref.watch(taskListProvider);

  if (searchQuery.isEmpty) {
    return taskList;
  }

  return taskList.whenData((tasks) {
    return tasks.where((task) {
      final lowerQuery = searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(lowerQuery) || task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  });
});
