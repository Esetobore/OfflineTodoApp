import '../entities/task.dart';

/// Repository interface - defines contract for task operations
/// This abstraction allows us to swap implementations without changing business logic
abstract class TaskRepository {
  /// Retrieve all tasks
  Future<List<Task>> getAllTasks();

  /// Get a specific task by ID
  Future<Task?> getTaskById(int id);

  /// Create a new task
  Future<int> createTask(Task task);

  /// Update an existing task
  Future<int> updateTask(Task task);

  /// Delete a task by ID
  Future<int> deleteTask(int id);

  /// Search tasks by title or description
  Future<List<Task>> searchTasks(String query);
}
