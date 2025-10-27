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

  // No add/edit/delete implementations here yet.
  // Placeholder methods for future implementation:
  //
  // Future<void> addTask(Task task) async { ... }
  // Future<void> updateTask(Task task) async { ... }
  // Future<void> deleteTask(String id) async { ... }
}
