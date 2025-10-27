import 'package:flutter/foundation.dart';
import 'package:my_tasks/models/task.dart';

class TaskProvider extends ChangeNotifier {
  // Initial sample tasks.
  final List<Task> _tasks = [
    Task(
      id: 't1',
      title: 'Buy groceries',
      description: 'Milk, eggs, bread, apples.',
      status: TaskStatus.pending,
    ),
    Task(
      id: 't2',
      title: 'Morning run',
      description: '5 km run around the park.',
      status: TaskStatus.inProgress,
    ),
    Task(
      id: 't3',
      title: 'Prepare presentation',
      description: 'Slides for Monday team meeting.',
      status: TaskStatus.done,
    ),
    Task(
      id: 't4',
      title: 'Call plumber',
      description: 'Fix the kitchen sink leak.',
      status: TaskStatus.pending,
    ),
  ];

  // Expose tasks as an unmodifiable list so UI can listen to provider.
  List<Task> get tasks => List.unmodifiable(_tasks);

  Task? findById(String id) {
  try {
    return _tasks.firstWhere((t) => t.id == id);
  } catch (e) {
    return null;
  }
}

  /// Add a new task. Generates a simple id based on timestamp.
  Future<void> addTask({required String title, String description = '', TaskStatus status = TaskStatus.pending}) async {
    final newTask = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      status: status,
    );
    _tasks.insert(0, newTask);
    notifyListeners();
  }

  /// Update existing task by id.
  Future<void> updateTask(String id, {String? title, String? description, TaskStatus? status}) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final current = _tasks[idx];
    _tasks[idx] = current.copyWith(
      title: title,
      description: description,
      status: status,
    );
    notifyListeners();
  }

  /// Delete a task by id.
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
