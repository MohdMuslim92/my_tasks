import 'package:flutter/material.dart';
import 'package:my_tasks/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:my_tasks/models/task.dart';
import 'package:my_tasks/providers/task_provider.dart';
import 'package:my_tasks/widgets/task_form.dart';

class AddEditTaskScreen extends StatefulWidget {
  // If `taskId` is provided, this is Edit mode.
  static const routeName = '/task-form';
  final String? taskId;

  const AddEditTaskScreen({super.key, this.taskId});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  bool _saving = false;
  String? _taskId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If taskId is null, try to read from route arguments
    if (_taskId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _taskId = args;
      } else {
        _taskId = widget.taskId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final isEdit = _taskId != null;

    // Look up the task from the provider's current tasks list.
    Task? task;
    if (isEdit) {
      final matches = provider.tasks.where((t) => t.id == _taskId).toList();
      if (matches.isNotEmpty) {
        task = matches.first;
      } else {
        task = null;
      }
    }

    // If we're in edit mode and the task is not available yet, show a loading/placeholder.
    if (isEdit && task == null) {
      // It's possible the provider is still syncing from Firestore.
      // Show a helpful UI instead of throwing.
      return Scaffold(
        appBar: AppBar(title: Text(loc.editTaskLabel)),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(
                    loc.loadingTaskMessage,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? loc.editTaskLabel : loc.addTask),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TaskForm(
            isSaving: _saving,
            initialTitle: task?.title,
            initialDescription: task?.description,
            initialStatus: task?.status,
            onSave: ({required title, required description, required status}) async {
              setState(() => _saving = true);
              try {
                if (isEdit && task != null) {
                  await provider.updateTask(task.id,
                      title: title, description: description, status: status);
                } else {
                  await provider.addTask(
                      title: title, description: description, status: status);
                }
                if (mounted) Navigator.of(context).pop(true);
              } finally {
                if (mounted) setState(() => _saving = false);
              }
            },
          ),
        ),
      ),
    );
  }
}
