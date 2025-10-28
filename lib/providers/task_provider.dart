import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_tasks/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Task> _tasks = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  String? _userId;
  bool _loading = true;

  // Expose tasks as an unmodifiable list so UI can listen to provider.
  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _loading;

  void bindToUser(String? userId) {
    // Unsubscribe previous
    _sub?.cancel();
    _userId = userId;

    if (_userId == null) {
      _tasks = [];
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    final col = _firestore.collection('users').doc(_userId).collection('tasks');

    // Listen to realtime updates
    _sub = col.orderBy('createdAt', descending: true).snapshots().listen((snap) {
      _tasks = snap.docs.map((d) {
        final data = d.data();
        return Task(
          id: d.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          status: _statusFromString(data['status'] as String?),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
      _loading = false;
      notifyListeners();
    }, onError: (err) {
      _loading = false;
      notifyListeners();
    });
  }

  // Convert stored string to TaskStatus
  TaskStatus _statusFromString(String? s) {
    switch (s) {
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      case 'pending':
      default:
        return TaskStatus.pending;
    }
  }

  String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'inProgress';
      case TaskStatus.done:
        return 'done';
      case TaskStatus.pending:
      default:
        return 'pending';
    }
  }

  /// Add: optimistic insert to local list, then write to Firestore.
  Future<void> addTask({
    required String title,
    String description = '',
    TaskStatus status = TaskStatus.pending,
  }) async {
    if (_userId == null) throw Exception('No user bound');
    final col = _firestore.collection('users').doc(_userId).collection('tasks');

    // Generate an id client-side so we can show the task immediately.
    final newDocRef = col.doc(); // generates id but doesn't write yet
    final newId = newDocRef.id;

    // Create local optimistic task (createdAt = now)
    final optimistic = Task(
      id: newId,
      title: title,
      description: description,
      status: status,
      createdAt: DateTime.now(),
    );

    // Insert locally at top and notify so UI updates immediately
    _tasks = [optimistic, ..._tasks];
    notifyListeners();

    try {
      // Write to Firestore using server timestamp for createdAt.
      await newDocRef.set({
        'title': title,
        'description': description,
        'status': _statusToString(status),
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Firestore snapshot listener will reconcile and update the list with server data.
    } catch (e) {
      // Rollback optimistic insert on error
      _tasks.removeWhere((t) => t.id == newId);
      notifyListeners();
      rethrow;
    }
  }

  /// Update: optimistic local update, then persist; rollback on error.
  Future<void> updateTask(
    String id, {
    String? title,
    String? description,
    TaskStatus? status,
  }) async {
    if (_userId == null) throw Exception('No user bound');
    final docRef = _firestore.collection('users').doc(_userId).collection('tasks').doc(id);

    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) {
      // If not found locally, still attempt server update.
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (status != null) updateData['status'] = _statusToString(status);
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.update(updateData);
      return;
    }

    // Keep a copy for rollback
    final old = _tasks[idx];

    // Apply optimistic change locally
    _tasks[idx] = old.copyWith(
      title: title ?? old.title,
      description: description ?? old.description,
      status: status ?? old.status,
    );
    notifyListeners();

    try {
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (status != null) updateData['status'] = _statusToString(status);
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.update(updateData);
      // snapshot will eventually reconcile any server-side fields
    } catch (e) {
      // rollback
      _tasks[idx] = old;
      notifyListeners();
      rethrow;
    }
  }

  /// Delete: optimistic remove, then try server delete; rollback on failure.
  Future<void> deleteTask(String id) async {
    if (_userId == null) throw Exception('No user bound');
    final docRef = _firestore.collection('users').doc(_userId).collection('tasks').doc(id);

    // Keep removed list entry for rollback
    final idx = _tasks.indexWhere((t) => t.id == id);
    Task? removed;
    if (idx != -1) {
      removed = _tasks.removeAt(idx);
      notifyListeners();
    }

    try {
      await docRef.delete();
    } catch (e) {
      // rollback if we removed locally
      if (removed != null) {
        _tasks.insert(idx, removed);
        notifyListeners();
      }
      rethrow;
    }
  }

  // Cancel subscription on dispose
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
