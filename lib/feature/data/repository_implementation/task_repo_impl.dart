import 'package:sqflite/sqflite.dart';

import '../../domain/entities/task.dart';
import '../../domain/repository/task_repository.dart';
import '../datasource/database_local_helper.dart';

/// Concrete implementation of TaskRepository using SQLite
class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  static const String tableName = 'tasks';

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(tableName, orderBy: 'createdAt DESC');
      return result.map((map) => Task.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  @override
  Future<Task?> getTaskById(int id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);

      if (result.isNotEmpty) {
        return Task.fromMap(result.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<int> createTask(Task task) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(tableName, task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<int> updateTask(Task task) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(tableName, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<int> deleteTask(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        tableName,
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'createdAt DESC',
      );
      return result.map((map) => Task.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }
}
